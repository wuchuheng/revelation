// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterModel _$ChapterModelFromJson(Map<String, dynamic> json) => ChapterModel(
      title: json['title'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      uuid: json['uuid'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      sortNum: json['sortNum'] as int,
      id: json['id'] as int,
      content: json['content'] as String,
      directoryId: json['directoryId'] as int,
    );

Map<String, dynamic> _$ChapterModelToJson(ChapterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'uuid': instance.uuid,
      'sortNum': instance.sortNum,
      'directoryId': instance.directoryId,
    };
