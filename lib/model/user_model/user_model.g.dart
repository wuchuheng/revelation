// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userName: json['userName'] as String,
      password: json['password'] as String,
      imapServerHost: json['imapServerHost'] as String,
      imapServerPort: json['imapServerPort'] as int,
      isImapServerSecure: json['isImapServerSecure'] as bool,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password,
      'imapServerHost': instance.imapServerHost,
      'imapServerPort': instance.imapServerPort,
      'isImapServerSecure': instance.isImapServerSecure,
    };
