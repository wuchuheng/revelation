import 'package:json_annotation/json_annotation.dart';
import 'package:snotes/dao/chapter_dao/index.dart';

part 'index.g.dart';

@JsonSerializable()
class DirectoryModel {
  static String tableName = 'directory';
  static const rootNodeId = 0;
  int id;
  int pid;
  int sortNum;
  String title;
  DateTime? deletedAt;
  DateTime updatedAt;
  List<DirectoryModel> children;

  int get count {
    if (id == DirectoryModel.rootNodeId) return ChapterDao().total();
    return ChapterDao().fetchByDirectoryId(id).length;
  }

  DirectoryModel({
    this.deletedAt,
    required this.id,
    required this.pid,
    required this.sortNum,
    required this.title,
    required this.updatedAt,
    required this.children,
  });
  DirectoryModel.create({
    this.deletedAt,
    required this.children,
    required this.id,
    required this.pid,
    required this.sortNum,
    required this.title,
  }) : updatedAt = DateTime.now();

  DirectoryModel.getRootNodeInitData()
      : updatedAt = DateTime.now(),
        children = [],
        id = rootNodeId,
        pid = 0,
        sortNum = 0,
        title = 'All';

  factory DirectoryModel.fromJson(Map<String, dynamic> json) {
    return _$DirectoryModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DirectoryModelToJson(this);
}
