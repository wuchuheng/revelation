// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAccountModel _$UserAccountModelFromJson(Map<String, dynamic> json) =>
    UserAccountModel(
      userName: json['userName'] as String,
      password: json['password'] as String,
      imapServerHost: json['imapServerHost'] as String,
      imapServerPort: json['imapServerPort'] as int,
      isImapServerSecure: json['isImapServerSecure'] as bool,
    );

Map<String, dynamic> _$UserAccountModelToJson(UserAccountModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password,
      'imapServerHost': instance.imapServerHost,
      'imapServerPort': instance.imapServerPort,
      'isImapServerSecure': instance.isImapServerSecure,
    };
