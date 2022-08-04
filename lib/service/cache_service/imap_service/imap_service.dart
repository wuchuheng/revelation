import 'dart:async';

import 'package:enough_mail/enough_mail.dart';
import 'package:snotes/service/cache_service/cache_io_abstract.dart';
import 'package:snotes/service/cache_service/errors/unset_error.dart';
import 'package:snotes/service/cache_service/imap_service/common.dart';
import 'package:snotes/service/cache_service/utils/single_task_pool.dart';
import 'package:snotes/service/cache_service/utils/task_pool.dart';

import '../errors/key_not_found_error.dart';
import '../utils/logger.dart';
import 'register_service.dart';

class ImapService extends Common implements CacheIOAbstract {
  static ImapClient? _clientInstance;
  static ImapService? _instance;
  static TaskPool taskPool = TaskPool.builder();
  startTask() => taskPool.startTask();
  completeTask(int taskNum) => taskPool.completeTask(taskNum);
  static SingleTaskPool singleTaskPool = SingleTaskPool.builder();

  static ImapService getInstance() {
    _instance ??= ImapService();
    return _instance!;
  }

  Future<ImapClient> _getClient() async {
    if (_clientInstance != null && _clientInstance!.isConnected) {
      return _clientInstance!;
    }
    ImapService._clientInstance = await Common().getClient();
    await _clientInstance!.selectMailboxByPath(boxName);

    return _clientInstance!;
  }

  @override
  Future<String> get({required String key}) async {
    Completer<String> completer = Completer();
    await singleTaskPool.start(() async {
      try {
        final client = await _getClient();
        RegisterInfo register = await RegisterService().getRegister();
        if (register.data.containsKey(key)) {
          final int uid = register.data[key]!.uid;
          final data = await client.uidFetchMessage(uid, 'BODY[]');
          final body = data.messages[0].decodeTextPlainPart();
          completer.complete(body);
        } else {
          completer.completeError(KeyNotFoundError());
        }
      } on ImapException catch (e) {
        rethrow;
      }
    });

    return completer.future;
  }

  Future<void> initOnlineCache({required ImapClient client}) async {
    const data = '{}';
    final name = convertDataStringToRegisterName(data);
    await set(key: name, value: data);
  }

  Future<void> set({
    required String key,
    required String value,
  }) async {
    await singleTaskPool.start(() async {
      final client = await _getClient();
      await write(name: key, value: value, client: client);
      RegisterInfo register = await RegisterService().getRegister();
      int? lastUid = await getLastUid(key: key, registerInfo: register);
      if (register.data[key]?.uid != null) {
        int? removeId = register.data[key]?.uid;
        register.uidMapKey.remove(removeId!);
      }
      register.uidMapKey[lastUid!] = key;
      register.data[key] = RegisterItemInfo(
          lastUpdatedAt: DateTime.now().toString(), uid: lastUid);
      await RegisterService().setRegister(data: register);
    });
  }

  Future<int?> getLastUid({
    required String key,
    required RegisterInfo registerInfo,
  }) async {
    List<int> uids = [];
    registerInfo.uidMapKey.forEach((key, _) => uids.add(key));
    ImapClient client = await _getClient();
    final res = await client.uidSearchMessagesWithQuery(
      SearchQueryBuilder.from(
        key,
        SearchQueryType.subject,
      ),
    );

    int? lastUid;
    if (res.matchingSequence != null &&
        res.matchingSequence!.toList().isNotEmpty) {
      List<int> onlineUids = res.matchingSequence!.toList();
      onlineUids = onlineUids.where((e) => !uids.contains(e)).toList();
      int updatedAt = 0;

      for (var uid in onlineUids) {
        FetchImapResult res = await client.uidFetchMessage(
            uid, 'BODY.PEEK[HEADER.FIELDS (subject)]');
        String subject = res.messages[0].getHeaderValue('Subject')!;
        final subjectList = subject.split('--');
        subject = subjectList[0];
        int newUpdatedAt = int.parse(subjectList[1].split('-')[0]);
        if (subject == key && newUpdatedAt > updatedAt) {
          lastUid = uid;
        }
      }
      if (lastUid != null) {
        return lastUid;
      }
    }
    if (lastUid == null) {
      await Future.delayed(const Duration(milliseconds: 500));
      return await getLastUid(key: key, registerInfo: registerInfo);
    }
  }

  Future<bool> has({required String key}) async {
    final ImapClient client = await _getClient();
    final res = await getUid(name: key, client: client) != null;

    return res;
  }

  Future<void> unset({required String key}) async {
    await singleTaskPool.start(() async {
      Logger.info("online: Start unset key: $key.");
      try {
        final client = await _getClient();
        final register = await RegisterService().getRegister();
        if (!register.data.containsKey(key)) {
          throw KeyNotFoundError();
        }
        int uid = register.data[key]!.uid;
        register.data.remove(key);
        register.uidMapKey.remove(uid);
        await Future.wait([
          deleteMessageByUid(uid: uid, client: client),
          RegisterService().setRegister(data: register)
        ]);
        Logger.info("online: complete unset key: $key.");
      } on ImapException catch (e) {
        throw UnsetError();
      }
    });
  }
}
