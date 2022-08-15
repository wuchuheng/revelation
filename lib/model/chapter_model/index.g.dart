// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterModel _$ChapterModelFromJson(Map<String, dynamic> json) => ChapterModel(
      title: json['title'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: DateTime.parse(json['deletedAt'] as String),
      sortNum: json['sortNum'] as int,
      id: json['id'] as int,
      content: json['content'] as String,
      pid: json['pid'] as int,
    );

Map<String, dynamic> _$ChapterModelToJson(ChapterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt.toIso8601String(),
      'sortNum': instance.sortNum,
      'pid': instance.pid,
    };
