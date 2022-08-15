// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectoryModel _$DirectoryModelFromJson(Map<String, dynamic> json) =>
    DirectoryModel(
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      id: json['id'] as int,
      pid: json['pid'] as int,
      sortId: json['sortId'] as int,
      title: json['title'] as String,
      updatedAt: json['updatedAt'] as String,
      count: json['count'] as int,
      children: (json['children'] as List<dynamic>)
          .map((e) => DirectoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DirectoryModelToJson(DirectoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pid': instance.pid,
      'sortId': instance.sortId,
      'title': instance.title,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt,
      'children': instance.children,
      'count': instance.count,
    };
