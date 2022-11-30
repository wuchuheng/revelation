// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userName: json['userName'] as String,
      password: json['password'] as String,
      host: json['host'] as String,
      port: json['port'] as int,
      tls: json['tls'] as bool,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password,
      'host': instance.host,
      'port': instance.port,
      'tls': instance.tls,
    };
