import 'package:json_annotation/json_annotation.dart';

part 'tree_item_model.g.dart';

@JsonSerializable()
class TreeItemModel {
  int id;
  int pid;
  int sortId;
  String title;
  bool isDelete;
  String updatedAt;
  List<TreeItemModel> children;
  int count;

  TreeItemModel({
    required this.count,
    required this.children,
    required this.id,
    required this.pid,
    required this.sortId,
    required this.title,
    required this.isDelete,
    required this.updatedAt,
  });

  factory TreeItemModel.fromJson(Map<String, dynamic> json) {
    return _$TreeItemModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TreeItemModelToJson(this);
}
