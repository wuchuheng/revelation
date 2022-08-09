import 'package:json_annotation/json_annotation.dart';

part 'tree_item_model.g.dart';

@JsonSerializable()
class TreeItemModel {
  final int id;
  final int pid;
  final int sortId;
  final String title;
  final bool isDelete;
  final String updatedAt;
  final List<TreeItemModel> children;
  final int count;

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
