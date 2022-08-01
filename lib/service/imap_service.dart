// EMAIL_ACCOUNT=2831473954@qq.com
// EMAIL_PASSWORD=owtdtjnltfnndegh
// EMAIL_HOST=imap.qq.com
// EMAIL_PORT=993
import 'dart:async';
import 'dart:io';

import 'package:enough_mail/enough_mail.dart';

class ImapService {
  String userName = '2831473954@qq.com';
  String password = 'owtdtjnltfnndeghaa';
  String imapServerHost = 'imap.qq.com';
  int imapServerPort = 993;
  bool isImapServerSecure = true;
  String dbName = 'snotes';
  static final ImapClient _clientInstance = ImapClient(isLogEnabled: false);

  Future<ImapClient> _getClient() async {
    if (ImapService._clientInstance.isConnected) {
      return ImapService._clientInstance;
    }

    try {
      await ImapService._clientInstance.connectToServer(
        imapServerHost,
        imapServerPort,
        isSecure: isImapServerSecure,
        timeout: const Duration(seconds: 30),
      );
      await ImapService._clientInstance.login(userName, password);
      final mailboxes = await ImapService._clientInstance.listMailboxes();
      if (!hasBox(mailboxName: dbName, mailboxes: mailboxes)) {
        await createBox(
            mailboxName: dbName, client: ImapService._clientInstance);
      }
      await ImapService._clientInstance.selectMailboxByPath(dbName);
    } catch (e) {
      rethrow;
    }

    return ImapService._clientInstance;
  }

  Future<void> set({
    required String name,
    required String content,
  }) async {
    try {
      final client = await _getClient();
      final oldUid = await _getUid(name: name);
      if (oldUid != null) {
        await _deleteMessageByUid(uid: oldUid, client: client);
      }
      final builder = MessageBuilder()
        ..addText(content)
        ..subject = name;
      await client.appendMessage(builder.buildMimeMessage());
    } on ImapException catch (e) {
      print('IMAP failed with $e');
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

  Future<void> createBox({
    required String mailboxName,
    required ImapClient client,
  }) async {
    try {
      await client.createMailbox(mailboxName);
    } on ImapException catch (e) {
      sleep(const Duration(seconds: 1));
      final mailboxes = await client.listMailboxes();
      if (!hasBox(mailboxName: mailboxName, mailboxes: mailboxes)) {
        rethrow;
      }
    }
  }

  Future<void> unset({required String name}) async {
    try {
      final client = await _getClient();
      final uid = await _getUid(name: name);
      if (uid != null) {
        await _deleteMessageByUid(uid: uid, client: client);
      }
    } on ImapException catch (e) {
      print('IMAP failed with $e');
    }
  }

  Future<String> get({required String name}) async {
    try {
      final client = await _getClient();
      final uid = await _getUid(name: name);
      if (uid != null) {
        final data = await client.uidFetchMessage(uid, 'BODY[]');
        final body = data.messages[0].decodeTextPlainPart();
        return body!;
      }
      throw Error();
    } on ImapException catch (e) {
      rethrow;
    }
  }

  Future<bool> has({required String name}) async {
    final res = await _getUid(name: name) != null;

    return res;
  }

  Future<int?> _getUid({
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
        'BODY[]',
      );
      for (final message in data.messages) {
        final subject = message.getHeaderValue('Subject');
        if (subject == name) {
          return message.uid!;
        }
      }
    }
    return null;
  }

  Future<void> _deleteMessageByUid({
    required int uid,
    required ImapClient client,
  }) async {
    final sequence = MessageSequence.fromId(uid, isUid: true);
    await client.uidStore(sequence, ["\\Deleted"]);
    await client.uidExpunge(sequence);
  }
}
