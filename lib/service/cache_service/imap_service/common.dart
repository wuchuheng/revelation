import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:enough_mail/enough_mail.dart';
import '../cache_common_config.dart';

class NameInfo {
  final String name;
  final int timestamp;

  NameInfo({
    required this.name,
    required this.timestamp,
  });
}

class Common {
  String userName = '2831473954@qq.com';
  String password = 'owtdtjnltfnndegh';
  // String imapServerHost = 'imap.qq.com';
  String imapServerHost = 'local.wuchuheng.com';
  int imapServerPort = 993;
  bool isImapServerSecure = true;
  String boxName = 'snotes';
  String registerMailBox = 'snotes_register';

  /// 获取IMAP客户端
  Future<ImapClient> getClient() async {
    final client = ImapClient(isLogEnabled: false);
    try {
      await client.connectToServer(
        imapServerHost,
        imapServerPort,
        isSecure: isImapServerSecure,
        timeout: const Duration(seconds: 30),
      );
      await client.login(userName, password);
      final mailboxes = await client.listMailboxes();
      bool isExistBox = hasBox(mailboxName: boxName, mailboxes: mailboxes);
      if (!isExistBox) {
        await createBox(mailboxName: boxName, client: client);
      }
      isExistBox = hasBox(mailboxName: registerMailBox, mailboxes: mailboxes);
      if (!isExistBox) {
        await createBox(mailboxName: registerMailBox, client: client);
      }
    } catch (e) {
      rethrow;
    }
    return client;
  }

  bool hasBox({required String mailboxName, required List<Mailbox> mailboxes}) {
    for (var mailbox in mailboxes) {
      if (mailbox.name == mailboxName) {
        return true;
      }
    }
    return false;
  }

  Future<void> createBox({
    required String mailboxName,
    required ImapClient client,
  }) async {
    try {
      await client.createMailbox(mailboxName);
    } on ImapException catch (e) {
      print(' create Box exception!');
      await Future.delayed(const Duration(seconds: 1));
      final mailboxes = await client.listMailboxes();
      if (!hasBox(mailboxName: mailboxName, mailboxes: mailboxes)) {
        rethrow;
      }
    }
  }

  String convertDataStringToRegisterName(String data) {
    final bytes1 = utf8.encode(data);
    String hashString =
        sha256.convert(bytes1).toString().replaceAll(RegExp(r'\s+'), '');

    return '${CacheCommonConfig.registerSymbol}_$hashString';
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
        ..subject = _encodeName(name);
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

  String _encodeName(String name) {
    final now = DateTime.now().microsecondsSinceEpoch;
    final timestring = DateTime.now().toString();

    return '$name--$now-$timestring';
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
        final nameInfo = decode(subject!);
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

  NameInfo decode(String name) {
    final res = name.split('--');
    final timestamp = int.parse(res[1].split('-')[1]);

    return NameInfo(name: res[0], timestamp: timestamp);
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
