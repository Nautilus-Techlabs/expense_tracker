// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMonthlyBudget _$UserMonthlyBudgetFromJson(Map<String, dynamic> json) =>
    UserMonthlyBudget(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      month: UserMonthlyBudget._dateFromJson(json['month'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserMonthlyBudgetToJson(UserMonthlyBudget instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'amount': instance.amount,
      'month': UserMonthlyBudget._dateToJson(instance.month),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
