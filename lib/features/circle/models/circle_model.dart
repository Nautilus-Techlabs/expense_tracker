import 'package:json_annotation/json_annotation.dart';

part 'circle_model.g.dart';

@JsonEnum()
enum CircleType {
  @JsonValue('one_time')
  oneTime,
  @JsonValue('ongoing')
  ongoing,
}

@JsonEnum()
enum CircleMemberRole {
  @JsonValue('owner')
  owner,
  @JsonValue('member')
  member,
  @JsonValue('viewer')
  viewer,
}

@JsonSerializable()
class CircleModel {
  final int id;
  @JsonKey(name: 'owner_id')
  final int ownerId;

  final String name;
  final String? description;
  final CircleType type;
  final double? budget;

  @JsonKey(name: 'split_enabled')
  final bool splitEnabled;

  @JsonKey(name: 'is_settled')
  final bool isSettled;

  @JsonKey(name: 'settled_at')
  final DateTime? settledAt;

  @JsonKey(name: 'ownership_transferred_at')
  final DateTime? ownershipTransferredAt;

  @JsonKey(name: 'previous_owner_id')
  final int? previousOwnerId;

  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const CircleModel({
    required this.id,
    required this.ownerId,
    required this.name,
    this.description,
    required this.type,
    this.budget,
    required this.splitEnabled,
    required this.isSettled,
    this.settledAt,
    this.ownershipTransferredAt,
    this.previousOwnerId,
    required this.isDeleted,
    this.deletedAt,

    required this.createdAt,
    required this.updatedAt,
  });

  factory CircleModel.fromJson(Map<String, dynamic> json) =>
      _$CircleModelFromJson(json);

  Map<String, dynamic> toJson() => _$CircleModelToJson(this);

  CircleModel copyWith({
    int? id,
    int? ownerId,
    String? name,
    String? description,
    CircleType? type,
    double? budget,
    bool? splitEnabled,
    bool? isSettled,
    DateTime? settledAt,
    DateTime? ownershipTransferredAt,
    int? previousOwnerId,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CircleModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      budget: budget ?? this.budget,
      splitEnabled: splitEnabled ?? this.splitEnabled,
      isSettled: isSettled ?? this.isSettled,
      settledAt: settledAt ?? this.settledAt,
      ownershipTransferredAt:
          ownershipTransferredAt ?? this.ownershipTransferredAt,
      previousOwnerId: previousOwnerId ?? this.previousOwnerId,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,

      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
