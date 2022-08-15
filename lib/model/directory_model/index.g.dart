// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectoryModel _$DirectoryModelFromJson(Map<String, dynamic> json) =>
    DirectoryModel(
      count: json['count'] as int,
      children: (json['children'] as List<dynamic>)
          .map((e) => DirectoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as int,
      pid: json['pid'] as int,
      sortId: json['sortId'] as int,
      title: json['title'] as String,
      isDelete: json['isDelete'] as bool,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$DirectoryModelToJson(DirectoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pid': instance.pid,
      'sortId': instance.sortId,
      'title': instance.title,
      'isDelete': instance.isDelete,
      'updatedAt': instance.updatedAt,
      'children': instance.children,
      'count': instance.count,
    };
