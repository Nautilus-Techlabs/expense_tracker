// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPayload _$UserPayloadFromJson(Map<String, dynamic> json) => UserPayload(
  authID: json['auth_id'] as String?,
  name: json['full_name'] as String,
  email: json['email'] as String,
  password: json['password'] as String?,
);

Map<String, dynamic> _$UserPayloadToJson(UserPayload instance) =>
    <String, dynamic>{
      'auth_id': ?instance.authID,
      'email': instance.email,
      'password': instance.password,
      'full_name': instance.name,
    };
