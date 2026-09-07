import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int id;

  @JsonKey(name: 'auth_id')
  final String authId;

  @JsonKey(name: 'full_name')
  final String fullName;

  final String? phone;

  final String? email;

  @JsonKey(name: 'fcm_token')
  final String? fcmToken;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.authId,
    required this.fullName,
    this.phone,
    this.email,
    this.fcmToken,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
