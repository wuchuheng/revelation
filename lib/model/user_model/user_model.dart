import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  static String tableName = 'user';

  final String userName;
  final String password;
  final String host;
  final int port;
  final bool tls;

  UserModel({
    required this.userName,
    required this.password,
    required this.host,
    required this.port,
    required this.tls,
  });
  static const String _saveKey = 'userAccount';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
