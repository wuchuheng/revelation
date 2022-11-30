import 'package:json_annotation/json_annotation.dart';
import 'package:revelation/dao/directory_dao/directory_dao.dart';
import 'package:revelation/model/directory_model/directory_model.dart';

part 'chapter_model.g.dart';

@JsonSerializable()
class ChapterModel {
  static String tableName = 'chapter';

  int id;
  String title;
  String content;
  DateTime updatedAt;
  DateTime? deletedAt;
  String uuid;
  int sortNum;
  int directoryId;

  ChapterModel({
    required this.title,
    required this.updatedAt,
    required this.uuid,
    this.deletedAt,
    required this.sortNum,
    required this.id,
    required this.content,
    required this.directoryId,
  });

  String get describe {
    String result = content;
    final regexp = RegExp(r'---(.*?)---', multiLine: true, dotAll: true);
    result = result.replaceAll(regexp, '');
    result = result.replaceAll(RegExp(r'^\s+\n', multiLine: true, dotAll: true), '');
    if (result.isNotEmpty) {
      result = result.split('\n')[0];
      const length = 10;
      result = result.length > length ? result.substring(0, length) : result;
    } else {
      result = '';
    }
    return result;
  }

  DirectoryModel get directory {
    final result = DirectoryDao().has(id: directoryId);
    return result!;
  }

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return _$ChapterModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ChapterModelToJson(this);
}
