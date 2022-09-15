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
    return DirectoryDao().has(id: directoryId)!;
  }

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return _$ChapterModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ChapterModelToJson(this);
}
