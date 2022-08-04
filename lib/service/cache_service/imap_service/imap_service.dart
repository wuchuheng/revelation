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
    final taskNum = await startTask();
    final instance = ImapService.getInstance();
    try {
      final client = await instance._getClient();
      final uid = await getUid(name: key, client: client);
      if (uid != null) {
        final data = await client.uidFetchMessage(uid, 'BODY[]');
        final body = data.messages[0].decodeTextPlainPart();
        completeTask(taskNum);
        return body!;
      }
      throw Error();
    } on ImapException catch (e) {
      rethrow;
    }
  }

  Future<void> initOnlineCache({required ImapClient client}) async {
    const data = '{}';
    final name = convertDataStringToRegisterName(data);
    await set(name: name, value: data);
  }

  Future<void> set({
    required String name,
    required String value,
  }) async {
    await singleTaskPool.start(() async {
      final client = await _getClient();
      await write(name: name, value: value, client: client);
      RegisterInfo register = await RegisterService().getRegister();
      int? lastUid = await getLastUid(key: name, registerInfo: register);
      if (register.data[name]?.uid != null) {
        register.uidMapKey.remove([register.data[name]?.uid]);
      }

      register.uidMapKey[lastUid!] = name;
      register.data[name] = RegisterItemInfo(
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

  Future<bool> has({required String name}) async {
    final ImapClient client = await _getClient();
    final res = await getUid(name: name, client: client) != null;

    return res;
  }

  Future<void> unset({required String name}) async {
    await singleTaskPool.start(() async {
      Logger.info("online: Start unset key: $name.");
      try {
        final client = await _getClient();
        final register = await RegisterService().getRegister();
        if (!register.data.containsKey(name)) {
          throw keyNotFoundError();
        }
        int? uid = register.data[name]!.uid;
        register.data.remove(name);
        if (uid != null) {
          register.uidMapKey.remove(uid);
        } else {
          uid = await getLastUid(key: name, registerInfo: register);
        }
        await Future.wait([
          deleteMessageByUid(uid: uid!, client: client),
          RegisterService().setRegister(data: register)
        ]);
        Logger.info("online: complete unset key: $name.");
      } on ImapException catch (e) {
        throw UnsetError();
      }
    });
  }
}
