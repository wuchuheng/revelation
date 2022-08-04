import 'package:json_annotation/json_annotation.dart';
import 'package:snotes/service/cache_service/cache_service_abstract.dart';
part 'cache_io_abstract.g.dart';

@JsonSerializable()
class RegisterItemInfo {
  final String lastUpdatedAt;
  final String? deletedAt;
  final int? uid;

  RegisterItemInfo({required this.lastUpdatedAt, this.deletedAt, this.uid});

  factory RegisterItemInfo.fromJson(Map<String, dynamic> json) =>
      _$RegisterItemInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterItemInfoToJson(this);
}

@JsonSerializable()
class RegisterInfo {
  Map<int, String> uidMapKey;
  Map<String, RegisterItemInfo> data;

  RegisterInfo({required this.uidMapKey, required this.data});

  factory RegisterInfo.fromJson(Map<String, dynamic> json) =>
      _$RegisterInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterInfoToJson(this);
}

abstract class CacheIOAbstract extends CacheServiceAbstract {}
