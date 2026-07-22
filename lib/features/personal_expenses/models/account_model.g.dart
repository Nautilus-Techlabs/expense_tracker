// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  name: json['name'] as String,
  type: $enumDecode(_$AccountTypeEnumMap, json['type']),
  balance: (json['balance'] as num).toDouble(),
  openingBalance: (json['opening_balance'] as num?)?.toDouble(),
  openingBalanceDate: json['opening_balance_date'] == null
      ? null
      : DateTime.parse(json['opening_balance_date'] as String),
  billingCycleDay: (json['billing_cycle_day'] as num?)?.toInt(),
  lastResetAt: json['last_reset_at'] == null
      ? null
      : DateTime.parse(json['last_reset_at'] as String),
  isDeleted: json['is_deleted'] as bool,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'type': _$AccountTypeEnumMap[instance.type]!,
      'balance': instance.balance,
      'opening_balance': instance.openingBalance,
      'opening_balance_date': instance.openingBalanceDate?.toIso8601String(),
      'billing_cycle_day': instance.billingCycleDay,
      'last_reset_at': instance.lastResetAt?.toIso8601String(),
      'is_deleted': instance.isDeleted,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$AccountTypeEnumMap = {
  AccountType.bank: 'bank',
  AccountType.creditCard: 'credit_card',
  AccountType.cash: 'cash',
};
