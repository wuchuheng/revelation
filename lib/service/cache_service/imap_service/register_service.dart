import 'dart:async';
import 'dart:convert';

import 'package:enough_mail/enough_mail.dart';
import 'package:snotes/service/cache_service/cache_io_abstract.dart';
import 'package:snotes/service/cache_service/imap_service/register_service_abstract.dart';
import 'package:snotes/service/cache_service/utils/multiplex_task_pool.dart';
import 'package:snotes/service/cache_service/utils/single_task_pool.dart';

import '../cache_common_config.dart';
import 'common.dart';

class RegisterService extends Common implements RegisterServiceAbstract {
  static ImapClient? _clientInstance;
  static List<Function({required bool isResult, bool? result})> callbackList =
      [];
  static MultiplexTaskPool hasRegisterTaskPool =
      MultiplexTaskPool.builder(); // 多路任务复用池-用于hasRegister方法
  static SingleTaskPool singleTaskPool = SingleTaskPool();
  static MultiplexTaskPool getRegisterTaskPool =
      MultiplexTaskPool.builder(); // 多路任务复用池-用于getRegister方法

  Future<ImapClient> _getClient() async {
    if (_clientInstance != null && _clientInstance!.isConnected) {
      return _clientInstance!;
    }
    _clientInstance = await Common().getClient();

    await _clientInstance!.selectMailboxByPath(registerMailBox);

    return _clientInstance!;
  }

  @override
  Future<bool> hasRegister() async {
    return await hasRegisterTaskPool.start<bool>(() async {
      final messages = await queryMessagesBySubject(
        subject: CacheCommonConfig.registerSymbol,
        client: await _getClient(),
      );
      for (final message in messages) {
        String subject = message.getHeaderValue('Subject')!;
        String onlineSubject = '';
        if (subject.length > CacheCommonConfig.registerSymbol.length) {
          onlineSubject =
              subject.substring(0, CacheCommonConfig.registerSymbol.length);
        }
        if (onlineSubject == CacheCommonConfig.registerSymbol) {
          return true;
        }
      }
      return false;
    });
  }

  @override
  Future<RegisterInfo> getRegister() async {
    return await getRegisterTaskPool.start<RegisterInfo>(() async {
      try {
        final client = await _getClient();
        final uid =
            await _getUidForRegister(name: CacheCommonConfig.registerSymbol);
        if (uid != null) {
          final data = await client.uidFetchMessage(uid, 'BODY[]');
          String? bodyJson = data.messages[0].decodeTextPlainPart();
          bodyJson = checkPlainText(bodyJson!);
          final Map<String, dynamic> body = jsonDecode(bodyJson);
          if (body.isNotEmpty) {
            return RegisterInfo.fromJson(body);
          } else {
            return RegisterInfo(uidMapKey: {}, data: {});
          }
        }
        throw Error();
      } on ImapException catch (e) {
        rethrow;
      }
    });
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

  Future<int?> _getUidForRegister({
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
      int? uid;
      for (final message in data.messages) {
        final subject = message.getHeaderValue('Subject');
        final nameInfo = decode(subject!);
        if (nameInfo.name.length <= CacheCommonConfig.registerSymbol.length) {
          continue;
        }
        String onlineKeyName =
            nameInfo.name.substring(0, CacheCommonConfig.registerSymbol.length);
        if (onlineKeyName == name && nameInfo.timestamp > lastUpdateAt) {
          lastUpdateAt = nameInfo.timestamp;
          uid = message.uid!;
        }
      }
      if (uid != null) {
        return uid;
      }
    }
    return null;
  }
}
