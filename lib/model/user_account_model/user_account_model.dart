import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:local_cache/local_cache.dart';

part 'user_account_model.g.dart';

@JsonSerializable()
class UserAccountModel {
  final String userName;
  final String password;
  final String imapServerHost;
  final int imapServerPort;
  final bool isImapServerSecure;

  UserAccountModel({
    required this.userName,
    required this.password,
    required this.imapServerHost,
    required this.imapServerPort,
    required this.isImapServerSecure,
  });
  static const String _saveKey = 'userAccount';

  static Future<void> save(UserAccountModel userAccountModel) async {
    String res = jsonEncode(userAccountModel);
    LocalCache localCache = LocalCache();
    await localCache.set(key: _saveKey, value: res);
  }

  static Future<UserAccountModel?> getCacheAccount() async {
    LocalCache localCache = LocalCache();
    if (!await localCache.has(key: _saveKey)) return null;
    String jsonString = await localCache.get(key: _saveKey);
    Map<String, dynamic> jsonMapData = jsonDecode(jsonString);
    return UserAccountModel.fromJson(jsonMapData);
  }

  factory UserAccountModel.fromJson(Map<String, dynamic> json) {
    return _$UserAccountModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserAccountModelToJson(this);
}
