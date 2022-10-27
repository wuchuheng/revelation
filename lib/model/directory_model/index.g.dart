// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectoryModel _$DirectoryModelFromJson(Map<String, dynamic> json) => DirectoryModel(
      deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt'] as String),
      id: json['id'] as int,
      pid: json['pid'] as int,
      sortNum: json['sortNum'] as int,
      title: json['title'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      children:
          (json['children'] as List<dynamic>).map((e) => DirectoryModel.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$DirectoryModelToJson(DirectoryModel instance) => <String, dynamic>{
      'id': instance.id,
      'pid': instance.pid,
      'sortNum': instance.sortNum,
      'title': instance.title,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'children': instance.children,
    };
