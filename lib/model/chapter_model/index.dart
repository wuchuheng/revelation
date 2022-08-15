import 'package:json_annotation/json_annotation.dart';
import 'package:snotes/dao/directory_dao/index.dart';
import 'package:snotes/model/directory_model/index.dart';

part 'index.g.dart';

@JsonSerializable()
class ChapterModel {
  static String tableName = 'chapter';

  int id;
  String title;
  String content;
  DateTime updatedAt;
  DateTime? deletedAt;
  int sortNum;
  int directoryId;

  ChapterModel({
    required this.title,
    required this.updatedAt,
    this.deletedAt,
    required this.sortNum,
    required this.id,
    required this.content,
    required this.directoryId,
  });

  DirectoryModel get directory {
    return DirectoryDao().has(id: directoryId)!;
  }

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return _$ChapterModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ChapterModelToJson(this);
}
