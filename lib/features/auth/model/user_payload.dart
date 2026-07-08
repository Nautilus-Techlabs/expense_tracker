import 'package:json_annotation/json_annotation.dart';

part 'user_payload.g.dart';

@JsonSerializable()
class UserPayload {
  @JsonKey(name: "auth_id", includeIfNull: false)
  final String? authID;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "full_name")
  final String name;
  @JsonKey(name: "phone", includeIfNull: false)
  final String? phone;

  UserPayload({
    this.authID,
    required this.name,
    required this.email,
    this.password,
    this.phone,
  });

  Map<String, dynamic> toJson() => _$UserPayloadToJson(this);
}
