import 'dart:io';

import 'package:enough_mail/enough_mail.dart';
import 'package:snotes/service/cache_service/utils/logger.dart';

import '../cache_common_config.dart';
import '../utils/hash.dart';

class NameInfo {
  final String name;
  final int timestamp;
  final String hash;

  NameInfo({
    required this.name,
    required this.timestamp,
    required this.hash,
  });
}

class Common {
  String userName = '';
  String password = '';
  // String imapServerHost = 'imap.qq.com';
  String imapServerHost = '';
  int imapServerPort = 993;
  bool isImapServerSecure = true;
  String boxName = 'snotes';
  String registerMailBox = 'snotes_register';

  /// 获取IMAP客户端
  Future<ImapClient> getClient(
      {int retryCount = 0}) async {
    final client = ImapClient(isLogEnabled: false);
    try {
      await client.connectToServer(
        imapServerHost,
        imapServerPort,
        isSecure: isImapServerSecure,
        timeout: const Duration(seconds: 30),
      );
      await client.login(userName, password);
      await createdBox(boxName: boxName, client: client);
      await createdBox(boxName: registerMailBox, client: client);
    } catch (e) {
      rethrow;
    }
    return client;
  }

  createdBox({
    required String boxName,
    int retryCount = 0,
    required ImapClient client,
  }) async {
    final mailboxes = await client.listMailboxes();
    bool isExistBox = hasBox(mailboxName: boxName, mailboxes: mailboxes);
    try {
      if (!isExistBox) {
        await client.createMailbox(boxName);
      }
    } on ImapException catch (e) {
      String expectMessage =
          'Unable to find just created mailbox with the path [$boxName]. Please report this problem.';
      if (retryCount < 5 && e.message == expectMessage) {
        await Future.delayed(const Duration(seconds: 1));
        return await createdBox(
          boxName: boxName,
          client: client,
          retryCount: retryCount + 1,
        );
      } else {
        rethrow;
      }
    }
  }

  bool hasBox({required String mailboxName, required List<Mailbox> mailboxes}) {
    for (var mailbox in mailboxes) {
      if (mailbox.name == mailboxName) {
        return true;
      }
    }
    return false;
  }

  String getRegisterName(String data) {
    return CacheCommonConfig.registerSymbol;
  }

  Future<void> write(
      {required String name,
      required String value,
      required ImapClient client,
      String? to,
      Map<String, String>? headers}) async {
    try {
      final oldUid = await getUid(name: name, client: client);
      final builder = MessageBuilder()
        ..addText(value)
        ..subject = encodeName(name: name, value: value);
      if (headers != null) {
        headers.forEach((key, value) => builder.addHeader(key, value));
      }
      if (to != null) {
        builder.to = [MailAddress('register', to)];
      }
      await client.appendMessage(builder.buildMimeMessage());
      if (oldUid != null) {
        await deleteMessageByUid(uid: oldUid, client: client);
      }
    } on ImapException catch (e) {
      print('IMAP failed with $e');
    }
  }

  Future<void> deleteMessageByUid({
    required int uid,
    required ImapClient client,
  }) async {
    final sequence = MessageSequence.fromId(uid, isUid: true);
    await client.uidStore(sequence, ["\\Deleted"]);
    await client.uidExpunge(sequence);
  }

  NameInfo decodeName(String name) {
    final List<String> nameInfo = name.split('#');
    return NameInfo(
      name: nameInfo[0],
      timestamp: int.parse(nameInfo[2]),
      hash: nameInfo[1].replaceAll(RegExp(r'\s+'), ''),
    );
  }

  String encodeName({required String name, required String value}) {
    final now = DateTime.now().microsecondsSinceEpoch;
    final timestamp = DateTime.now().toString();
    final String hash = Hash.convertStringToHash(value);

    return '$name#$hash#$now#$timestamp';
  }

  Future<int?> getUid({
    required String name,
    required ImapClient client,
  }) async {
    final res = await client.uidSearchMessagesWithQuery(
        SearchQueryBuilder.from(name, SearchQueryType.subject));
    if (res.matchingSequence != null &&
        res.matchingSequence!.toList().isNotEmpty) {
      final uids = res.matchingSequence!.toList();
      final data = await client.uidFetchMessages(
        MessageSequence.fromIds(uids, isUid: true),
        // BODY.PEEK[HEADER.FIELDS (date subject from to cc message-id in-reply-to references content-type x-priority x-uniform-type-identifier x-universally-unique-identifier list-id list-unsubscribe)]
        'BODY.PEEK[HEADER.FIELDS (subject)]',
      );
      int lastUpdateAt = 0;
      int? uid;
      for (final message in data.messages) {
        final subject = message.getHeaderValue('Subject');
        final nameInfo = decodeName(subject!);
        if (nameInfo.name == name && nameInfo.timestamp > lastUpdateAt) {
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

  Future<List<MimeMessage>> queryMessagesBySubject({
    required String subject,
    required ImapClient client,
  }) async {
    final res = await client.uidSearchMessagesWithQuery(
      SearchQueryBuilder.from(
        subject,
        SearchQueryType.subject,
      ),
    );

    if (res.matchingSequence != null &&
        res.matchingSequence!.toList().isNotEmpty) {
      final uids = res.matchingSequence!.toList();
      final data = await client.uidFetchMessages(
        MessageSequence.fromIds(uids, isUid: true),
        'BODY[]',
      );
      return data.messages;
    }
    return [];
  }

  String checkPlainText(String text) {
    return text.replaceAll(RegExp(r'\r\n'), '');
  }
}
