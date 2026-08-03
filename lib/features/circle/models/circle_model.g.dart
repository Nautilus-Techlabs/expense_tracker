// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CircleModel _$CircleModelFromJson(Map<String, dynamic> json) => CircleModel(
  id: (json['id'] as num).toInt(),
  ownerId: (json['owner_id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  type: $enumDecode(_$CircleTypeEnumMap, json['type']),
  budget: (json['budget'] as num?)?.toDouble(),
  splitEnabled: json['split_enabled'] as bool,
  isSettled: json['is_settled'] as bool,
  settledAt: json['settled_at'] == null
      ? null
      : DateTime.parse(json['settled_at'] as String),
  ownershipTransferredAt: json['ownership_transferred_at'] == null
      ? null
      : DateTime.parse(json['ownership_transferred_at'] as String),
  previousOwnerId: (json['previous_owner_id'] as num?)?.toInt(),
  isDeleted: json['is_deleted'] as bool,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CircleModelToJson(CircleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'type': _$CircleTypeEnumMap[instance.type]!,
      'budget': instance.budget,
      'split_enabled': instance.splitEnabled,
      'is_settled': instance.isSettled,
      'settled_at': instance.settledAt?.toIso8601String(),
      'ownership_transferred_at': instance.ownershipTransferredAt
          ?.toIso8601String(),
      'previous_owner_id': instance.previousOwnerId,
      'is_deleted': instance.isDeleted,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$CircleTypeEnumMap = {
  CircleType.one_time: 'one_time',
  CircleType.ongoing: 'ongoing',
};
