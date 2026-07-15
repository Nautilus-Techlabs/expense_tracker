// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'],
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      type: $enumDecode(_$CategoryTypeEnumMap, json['type']),
      isSystem: json['is_system'] as bool,
      isProtected: json['is_protected'] as bool,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'type': _$CategoryTypeEnumMap[instance.type]!,
      'is_system': instance.isSystem,
      'is_protected': instance.isProtected,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$CategoryTypeEnumMap = {
  CategoryType.both: 'both',
  CategoryType.expense: 'expense',
  CategoryType.income: 'income',
};
