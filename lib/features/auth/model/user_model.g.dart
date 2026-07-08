// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  authId: json['auth_id'] as String,
  fullName: json['full_name'] as String,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  isActive: json['is_active'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'auth_id': instance.authId,
  'full_name': instance.fullName,
  'phone': instance.phone,
  'email': instance.email,
  'avatar_url': instance.avatarUrl,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
