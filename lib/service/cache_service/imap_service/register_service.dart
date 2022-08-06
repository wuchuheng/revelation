import 'dart:async';
import 'dart:convert';

import 'package:enough_mail/enough_mail.dart';
import 'package:snotes/service/cache_service/cache_io_abstract.dart';
import 'package:snotes/service/cache_service/errors/not_found_register_error.dart';
import 'package:snotes/service/cache_service/imap_service/register_service_abstract.dart';
import 'package:snotes/service/cache_service/utils/multiplex_task_pool.dart';
import 'package:snotes/service/cache_service/utils/single_task_pool.dart';

import '../cache_common_config.dart';
import 'common.dart';

class RegisterSubjectInfo extends NameInfo {
  final int uid;

  RegisterSubjectInfo({
    required this.uid,
    required super.name,
    required super.timestamp,
    required super.hash,
  });
}

class RegisterService extends Common implements RegisterServiceAbstract {
  static ImapClient? _clientInstance;
  static List<Function({required bool isResult, bool? result})> callbackList = [];
  static SingleTaskPool singleTaskPool = SingleTaskPool();
  static MultiplexTaskPool getRegisterTaskPool = MultiplexTaskPool.builder(); // 多路任务复用池-用于getRegister方法

  Future<ImapClient> _getClient() async {
    if (_clientInstance != null && _clientInstance!.isConnected) {
      return _clientInstance!;
    }
    _clientInstance = await Common().getClient(mailboxName: registerMailBox);
    await _clientInstance!.selectMailboxByPath(registerMailBox);

    return _clientInstance!;
  }

  @override
  Future<RegisterInfo?> hasRegister() async {
    try {
      final RegisterInfo res = await getRegister();
      return res;
    } on NotFoundRegisterError catch(e) {
      return null;
    } catch(e) {
      rethrow;
    }
  }

  static String? previousRegisterHash;
  static RegisterInfo? previousRegisterInfo;

  @override
  Future<RegisterInfo> getRegister() {
    Completer<RegisterInfo> completer = Completer();
    getRegisterTaskPool.start<RegisterInfo?>(() async {
      final client = await _getClient();
      final RegisterSubjectInfo? registerSubjectInfo = await _getUidForRegister(name: CacheCommonConfig.registerSymbol);
      if (registerSubjectInfo != null) {
        if (previousRegisterHash != null &&
            previousRegisterHash == registerSubjectInfo.hash) {
          completer.complete(previousRegisterInfo!);
        } else {
          final data = await client.uidFetchMessage(registerSubjectInfo.uid, 'BODY[]');
          String? bodyJson = data.messages[0].decodeTextPlainPart();
          bodyJson = checkPlainText(bodyJson!);
          final Map<String, dynamic> body = jsonDecode(bodyJson);
          RegisterInfo result = body.isNotEmpty
              ? RegisterInfo.fromJson(bodyJson)
              : RegisterInfo(uidMapKey: {}, data: {});
          previousRegisterHash = registerSubjectInfo.hash;
          previousRegisterInfo = result;
          completer.complete(result);
        }
      } else {
        completer.completeError(NotFoundRegisterError());
      }
      return null;
    });
    return completer.future;
  }

  @override
  Future<void> setRegister({required RegisterInfo data}) async {
    await singleTaskPool.start(() async {
      String dataJson = "";
      dataJson = jsonEncode(data);
      final String name = getRegisterName(dataJson);
      final client = await _getClient();
      final res = await client.uidSearchMessagesWithQuery(
        SearchQueryBuilder.from(
          CacheCommonConfig.registerSymbol,
          SearchQueryType.subject,
        ),
      );
      await write(
        name: name,
        value: dataJson,
        client: client,
      );
      if (res.matchingSequence != null &&
          res.matchingSequence!.toList().isNotEmpty) {
        final uids = res.matchingSequence!.toList();
        for (final uid in uids) {
          final sequence = MessageSequence.fromId(uid, isUid: true);
          await client.uidStore(sequence, ["\\Deleted"]);
          await client.uidExpunge(sequence);
        }
      }
    });
  }

  Future<RegisterSubjectInfo?> _getUidForRegister({
    required String name,
  }) async {
    final client = await _getClient();
    final res = await client.uidSearchMessagesWithQuery(
        SearchQueryBuilder.from(name, SearchQueryType.subject));
    if (res.matchingSequence != null &&
        res.matchingSequence!.toList().isNotEmpty) {
      final uids = res.matchingSequence!.toList();
      final data = await client.uidFetchMessages(
        MessageSequence.fromIds(uids, isUid: true),
        'BODY.PEEK[HEADER.FIELDS (subject)]',
      );
      int lastUpdateAt = 0;
      RegisterSubjectInfo? result;
      for (final message in data.messages) {
        final subject = message.getHeaderValue('Subject');
        final nameInfo = decodeName(subject!);
        if (nameInfo.name != CacheCommonConfig.registerSymbol) {
          continue;
        }
        if (nameInfo.timestamp > lastUpdateAt) {
          lastUpdateAt = nameInfo.timestamp;
          result = RegisterSubjectInfo(
            uid: message.uid!,
            name: nameInfo.name,
            timestamp: nameInfo.timestamp,
            hash: nameInfo.hash,
          );
        }
      }
      if (result != null) return result;
    }
    return null;
  }
}
