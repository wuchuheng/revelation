// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_io_abstract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterItemInfo _$RegisterItemInfoFromJson(Map<String, dynamic> json) =>
    RegisterItemInfo(
      lastUpdatedAt: json['lastUpdatedAt'] as String,
      deletedAt: json['deletedAt'] as String?,
      uid: json['uid'] as int,
      hash: json['hash'] as String,
    );

Map<String, dynamic> _$RegisterItemInfoToJson(RegisterItemInfo instance) =>
    <String, dynamic>{
      'lastUpdatedAt': instance.lastUpdatedAt,
      'deletedAt': instance.deletedAt,
      'uid': instance.uid,
      'hash': instance.hash,
    };

RegisterInfo _$RegisterInfoFromJson(Map<String, dynamic> json) => RegisterInfo(
      uidMapKey: (json['uidMapKey'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as String),
      ),
      data: (json['data'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, RegisterItemInfo.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$RegisterInfoToJson(RegisterInfo instance) =>
    <String, dynamic>{
      'uidMapKey': instance.uidMapKey.map((k, e) => MapEntry(k.toString(), e)),
      'data': instance.data,
    };
