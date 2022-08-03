// EMAIL_ACCOUNT=2831473954@qq.com
// EMAIL_PASSWORD=owtdtjnltfnndegh
// EMAIL_HOST=imap.qq.com
// EMAIL_PORT=993
import 'dart:async';
import 'dart:convert';

import 'package:snotes/service/cache_service/cache_service_abstract.dart';

import 'imap_service/imap_service.dart'; // for the utf8.encode method

class CacheService implements CacheServiceAbstract {
  static CacheService? _instance;
  static bool _isFirstSyncLocalAndOnlineData = false; // 是否已经同步过一次数据了

  static Future<CacheService> getInstance() async {
    _instance ??= CacheService();
    if (!_isFirstSyncLocalAndOnlineData) {
      _isFirstSyncLocalAndOnlineData = true;
      await _instance!._syncLocalAndOnlineData();
    }

    return _instance!;
  }

  // 同步线上和本地的数据
  Future<void> _syncLocalAndOnlineData() async {
    bool hasOnlineRegister = await ImapService.getInstance().hasRegister();
    final initData = jsonEncode(
      {"lastUpdatedAt": DateTime.now().toString(), "data": {}},
    );
    if (!hasOnlineRegister) {
      await ImapService.getInstance().setRegister(data: initData);
    }
  }

  Future<void> set({
    required String name,
    required String content,
  }) async {
    await ImapService.getInstance().set(name: name, value: content);
  }

  Future<void> unset({required String name}) async {
    return await ImapService.getInstance().unset(name: name);
  }

  @override
  Future<String> get({required String key}) async {
    return await ImapService.getInstance().get(key: key);
  }

  Future<bool> has({required String name}) async {
    return await ImapService.getInstance().has(name: name);
  }
}
