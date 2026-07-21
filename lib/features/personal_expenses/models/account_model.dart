import 'package:json_annotation/json_annotation.dart';

part 'account_model.g.dart';

@JsonEnum()
enum AccountType {
  @JsonValue('bank')
  bank,

  @JsonValue('credit_card')
  creditCard,

  @JsonValue('cash')
  cash,
}

@JsonSerializable()
class AccountModel {
  final int id;

  @JsonKey(name: 'user_id')
  final int userId;

  final String name;

  final AccountType type;

  /// PostgreSQL numeric(12,2)
  final double balance;

  @JsonKey(name: 'opening_balance')
  final double? openingBalance;

  @JsonKey(name: 'opening_balance_date')
  final DateTime? openingBalanceDate;

  @JsonKey(name: 'billing_cycle_day')
  final int? billingCycleDay;

  @JsonKey(name: 'last_reset_at')
  final DateTime? lastResetAt;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const AccountModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.balance,
    this.openingBalance,
    this.openingBalanceDate,
    this.billingCycleDay,
    this.lastResetAt,
    required this.isActive,
    required this.isDeleted,
    this.deletedAt,

    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
