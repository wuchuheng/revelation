// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryChapterModel _$HistoryChapterModelFromJson(Map<String, dynamic> json) =>
    HistoryChapterModel(
      id: json['id'] as int,
      pid: json['pid'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$HistoryChapterModelToJson(
        HistoryChapterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pid': instance.pid,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
    };
