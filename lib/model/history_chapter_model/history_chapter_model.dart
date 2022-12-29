import 'package:json_annotation/json_annotation.dart';

part 'history_chapter_model.g.dart';

@JsonSerializable()
class HistoryChapterModel {
  static String tableName = 'history_chapter';

  int id;
  int pid;
  String title;
  String content;
  DateTime createdAt;

  HistoryChapterModel({
    required this.id,
    required this.pid,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory HistoryChapterModel.fromJson(Map<String, dynamic> json) {
    return _$HistoryChapterModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$HistoryChapterModelToJson(this);
}
