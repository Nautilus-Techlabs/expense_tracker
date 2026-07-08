// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String,
      userId: json['user_id'],
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      type: $enumDecode(_$TypeEnumMap, json['type']),
      isSystem: json['is_system'] as bool,
      isProtected: json['is_protected'] as bool,
      isActive: json['is_active'] as bool,
      createdAt: $enumDecode(_$CreatedAtEnumMap, json['created_at']),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'type': _$TypeEnumMap[instance.type]!,
      'is_system': instance.isSystem,
      'is_protected': instance.isProtected,
      'is_active': instance.isActive,
      'created_at': _$CreatedAtEnumMap[instance.createdAt]!,
    };

const _$TypeEnumMap = {
  Type.BOTH: 'both',
  Type.EXPENSE: 'expense',
  Type.INCOME: 'income',
};

const _$CreatedAtEnumMap = {
  CreatedAt.THE_202607061059084590900: '2026-07-06 10:59:08.45909+00',
  CreatedAt.THE_2026070610593133884800: '2026-07-06 10:59:31.338848+00',
};
