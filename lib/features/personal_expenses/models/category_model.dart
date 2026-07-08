import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "user_id")
  dynamic userId;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "icon")
  String icon;
  @JsonKey(name: "color")
  String color;
  @JsonKey(name: "type")
  Type type;
  @JsonKey(name: "is_system")
  bool isSystem;
  @JsonKey(name: "is_protected")
  bool isProtected;
  @JsonKey(name: "is_active")
  bool isActive;
  @JsonKey(name: "created_at")
  CreatedAt createdAt;

  CategoryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    required this.isSystem,
    required this.isProtected,
    required this.isActive,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

enum CreatedAt {
  @JsonValue("2026-07-06 10:59:08.45909+00")
  THE_202607061059084590900,
  @JsonValue("2026-07-06 10:59:31.338848+00")
  THE_2026070610593133884800,
}

enum Type {
  @JsonValue("both")
  BOTH,
  @JsonValue("expense")
  EXPENSE,
  @JsonValue("income")
  INCOME,
}
