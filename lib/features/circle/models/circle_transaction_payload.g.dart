// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_transaction_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CircleTransactionPayload _$CircleTransactionPayloadFromJson(
  Map<String, dynamic> json,
) => CircleTransactionPayload(
  circleId: (json['p_circle_id'] as num).toInt(),
  accountId: (json['p_account_id'] as num).toInt(),
  categoryId: (json['p_category_id'] as num).toInt(),
  type: json['p_type'] as String,
  amount: (json['p_amount'] as num).toDouble(),
  note: json['p_note'] as String?,
  txnDate: json['p_txn_date'] as String,
  splits: (json['p_splits'] as List<dynamic>)
      .map((e) => CircleSplitModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CircleTransactionPayloadToJson(
  CircleTransactionPayload instance,
) => <String, dynamic>{
  'p_circle_id': instance.circleId,
  'p_account_id': instance.accountId,
  'p_category_id': instance.categoryId,
  'p_type': instance.type,
  'p_amount': instance.amount,
  'p_note': instance.note,
  'p_txn_date': instance.txnDate,
  'p_splits': instance.splits,
};

CircleSplitModel _$CircleSplitModelFromJson(Map<String, dynamic> json) =>
    CircleSplitModel(
      userId: (json['user_id'] as num).toInt(),
      splitType: json['split_type'] as String,
      splitValue: (json['split_value'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CircleSplitModelToJson(CircleSplitModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'split_type': instance.splitType,
      'split_value': instance.splitValue,
    };
