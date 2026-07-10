import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonEnum()
enum CategoryType {
  @JsonValue('both')
  both,
  @JsonValue('expense')
  expense,
  @JsonValue('income')
  income,
}

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'user_id')
  final dynamic userId;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'icon')
  final String icon;

  @JsonKey(name: 'color')
  final String color;

  @JsonKey(name: 'type')
  final CategoryType type;

  @JsonKey(name: 'is_system')
  final bool isSystem;

  @JsonKey(name: 'is_protected')
  final bool isProtected;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const CategoryModel({
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
