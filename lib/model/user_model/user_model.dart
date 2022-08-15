import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  static String tableName = 'user';

  final String userName;
  final String password;
  final String imapServerHost;
  final int imapServerPort;
  final bool isImapServerSecure;

  UserModel({
    required this.userName,
    required this.password,
    required this.imapServerHost,
    required this.imapServerPort,
    required this.isImapServerSecure,
  });
  static const String _saveKey = 'userAccount';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
