import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:snotes/service/cache_service/cache_io_abstract.dart';
import '../cache_common_config.dart';

class NameInfo {
  final String name;
  final int timestamp;

  NameInfo({
    required this.name,
    required this.timestamp,
  });
}

class ImapService implements CacheIOAbstract {
  String userName = '2831473954@qq.com';
  String password = 'owtdtjnltfnndegh';
  String imapServerHost = 'imap.qq.com';
  int imapServerPort = 993;
  bool isImapServerSecure = true;
  String dbName = 'snotes';
  static ImapClient _clientInstance = ImapClient(isLogEnabled: true);
  static ImapService? _instance;
  static List<Function()> taskRegisterList = []; // 任务注册列表

  Future<int> startTask() {
    int taskNum = DateTime.now().microsecondsSinceEpoch;
    Completer<int> c = Completer();
    taskRegisterList.add(() {
      print('${DateTime.now()} start task: $taskNum');
      c.complete(taskNum);
    });
    if (taskRegisterList.length == 1) {
      taskRegisterList[0]();
    }

    return c.future;
  }

  completeTask(int taskNum) {
    print('${DateTime.now()} completed task: $taskNum');
    taskRegisterList.removeAt(0);
    if (taskRegisterList.isNotEmpty) {
      try {
        taskRegisterList[0]();
      } catch (e) {
        sleep(const Duration(seconds: 1));
        taskRegisterList[0]();
      }
    }
  }

  static ImapService getInstance() {
    _instance ??= ImapService();
    return _instance!;
  }

  Future<ImapClient> _getClient() async {
    if (_clientInstance.isConnected) {
      return _clientInstance;
    }
    ImapService._clientInstance = await _reGetClient();

    return _clientInstance;
  }

  @override
  Future<String> get({required String key}) async {
    final taskNum = await startTask();
    final instance = ImapService.getInstance();
    try {
      final client = await instance._getClient();
      final uid = await instance._getUid(name: key);
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

  String _encodeName(String name) {
    final now = DateTime.now().microsecondsSinceEpoch;
    final timestring = DateTime.now().toString();

    return '$name--$now-$timestring';
  }

  NameInfo _decode(String name) {
    final res = name.split('--');
    final timestamp = int.parse(res[1].split('-')[1]);

    return NameInfo(name: res[0], timestamp: timestamp);
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
      int lastUpdateAt = 0;
      int? uid;
      for (final message in data.messages) {
        final subject = message.getHeaderValue('Subject');
        final nameInfo = _decode(subject!);
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

  Future<ImapClient> _reGetClient() async {
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
      final isExistBox = hasBox(mailboxName: dbName, mailboxes: mailboxes);
      if (!isExistBox) {
        await createBox(mailboxName: dbName, client: client);
      }
      await client.selectMailboxByPath(dbName);
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
      sleep(const Duration(seconds: 1));
      final mailboxes = await client.listMailboxes();
      if (!hasBox(mailboxName: mailboxName, mailboxes: mailboxes)) {
        rethrow;
      }
    }
  }

  Future<void> initOnlineCache({required ImapClient client}) async {
    const data = '{}';
    final name = _convertDataStringToRegisterName(data);
    await set(name: name, value: data);
  }

  String _convertDataStringToRegisterName(String data) {
    final bytes1 = utf8.encode(data);
    String hashString = sha256.convert(bytes1).toString();

    return '${CacheCommonConfig.registerSymbol}_$hashString';
  }

  Future<void> set({
    required String name,
    required String value,
  }) async {
    int taskNum = await startTask();
    final instance = getInstance();
    try {
      final client = await instance._getClient();
      final oldUid = await instance._getUid(name: name);
      final builder = MessageBuilder()
        ..addText(value)
        ..subject = _encodeName(name);
      await client.appendMessage(builder.buildMimeMessage());
      if (oldUid != null) {
        await instance._deleteMessageByUid(uid: oldUid, client: client);
      }
    } on ImapException catch (e) {
      print('IMAP failed with $e');
    }
    completeTask(taskNum);
  }

  Future<void> _deleteMessageByUid({
    required int uid,
    required ImapClient client,
  }) async {
    final sequence = MessageSequence.fromId(uid, isUid: true);
    await client.uidStore(sequence, ["\\Deleted"]);
    await client.uidExpunge(sequence);
  }

  Future<bool> has({required String name}) async {
    final res = await _getUid(name: name) != null;

    return res;
  }

  Future<void> unset({required String name}) async {
    final taskNum = await startTask();
    final instance = getInstance();
    try {
      final client = await instance._getClient();
      final uid = await instance._getUid(name: name);
      if (uid != null) {
        await instance._deleteMessageByUid(uid: uid, client: client);
      }
    } on ImapException catch (e) {
      print('IMAP failed with $e');
    }
    completeTask(taskNum);
  }

  Future<List<MimeMessage>?> queryMessagesBySubject(
      {required String subject}) async {
    final client = await _getClient();
    final res = await client.uidSearchMessagesWithQuery(
        SearchQueryBuilder.from(subject, SearchQueryType.subject));

    if (res.matchingSequence != null &&
        res.matchingSequence!.toList().isNotEmpty) {
      final uids = res.matchingSequence!.toList();
      final data = await client.uidFetchMessages(
        MessageSequence.fromIds(uids, isUid: true),
        'BODY[]',
      );
      return data.messages;
    }
  }

  @override
  Future<bool> hasRegister() async {
    int taskNum = await startTask();
    final messages =
        await queryMessagesBySubject(subject: CacheCommonConfig.registerSymbol);
    if (messages != null) {
      for (final message in messages) {
        String subject = message.getHeaderValue('Subject')!;
        subject = subject.split('_')[0];
        if (subject == CacheCommonConfig.registerSymbol) {
          return true;
        }
      }
    }
    completeTask(taskNum);

    return false;
  }

  @override
  Future<void> setRegister({required String data}) async {
    int taskNum = await startTask();
    final String name = _convertDataStringToRegisterName(data);
    final client = await _getClient();
    final res = await client.uidSearchMessagesWithQuery(
      SearchQueryBuilder.from(
        CacheCommonConfig.registerSymbol,
        SearchQueryType.subject,
      ),
    );
    completeTask(taskNum);
    await set(name: name, value: data);
    taskNum = await startTask();
    if (res.matchingSequence != null &&
        res.matchingSequence!.toList().isNotEmpty) {
      final uids = res.matchingSequence!.toList();
      for (final uid in uids) {
        final sequence = MessageSequence.fromId(uid, isUid: true);
        await client.uidStore(sequence, ["\\Deleted"]);
        await client.uidExpunge(sequence);
      }
    }
    completeTask(taskNum);
  }
}
