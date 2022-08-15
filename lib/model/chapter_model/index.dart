import 'package:json_annotation/json_annotation.dart';

part 'index.g.dart';

@JsonSerializable()
class ChapterModel {
  static String tableName = 'chapter';

  final int id;
  final String title;
  final String content;
  final DateTime updatedAt;
  final DateTime deletedAt;
  final int sortNum;
  final int pid;

  ChapterModel({
    required this.title,
    required this.updatedAt,
    required this.deletedAt,
    required this.sortNum,
    required this.id,
    required this.content,
    required this.pid,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return _$ChapterModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ChapterModelToJson(this);
}
