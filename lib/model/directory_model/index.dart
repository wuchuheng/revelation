import 'package:json_annotation/json_annotation.dart';

part 'index.g.dart';

@JsonSerializable()
class DirectoryModel {
  static String tableName = 'directory';
  static const rootNodeId = 0;
  int id;
  int pid;
  int sortId;
  String title;
  bool isDelete;
  String updatedAt;
  List<DirectoryModel> children;
  int count;

  DirectoryModel({
    required this.id,
    required this.pid,
    required this.sortId,
    required this.title,
    required this.isDelete,
    required this.updatedAt,
    required this.count,
    required this.children,
  });
  DirectoryModel.create({
    required this.count,
    required this.children,
    required this.id,
    required this.pid,
    required this.sortId,
    required this.title,
    required this.isDelete,
  }) : updatedAt = DateTime.now().toString();

  DirectoryModel.getRootNodeInitData()
      : updatedAt = DateTime.now().toString(),
        count = 0,
        children = [],
        id = rootNodeId,
        pid = 0,
        sortId = 0,
        title = 'All',
        isDelete = false;

  factory DirectoryModel.fromJson(Map<String, dynamic> json) {
    return _$DirectoryModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DirectoryModelToJson(this);
}
