// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userName: json['userName'] as String,
      password: json['password'] as String,
      host: json['imapServerHost'] as String,
      port: json['imapServerPort'] as int,
      tls: json['isImapServerSecure'] as bool,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password,
      'imapServerHost': instance.host,
      'imapServerPort': instance.port,
      'isImapServerSecure': instance.tls,
    };
