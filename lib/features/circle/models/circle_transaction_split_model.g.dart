// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_transaction_split_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CircleTransactionSplitModel _$CircleTransactionSplitModelFromJson(
  Map<String, dynamic> json,
) => CircleTransactionSplitModel(
  splits: (json['splits'] as List<dynamic>)
      .map((e) => Split.fromJson(e as Map<String, dynamic>))
      .toList(),
  transaction: TransactionModel.fromJson(
    json['transaction'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CircleTransactionSplitModelToJson(
  CircleTransactionSplitModel instance,
) => <String, dynamic>{
  'splits': instance.splits,
  'transaction': instance.transaction,
};

Split _$SplitFromJson(Map<String, dynamic> json) => Split(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  fullName: json['full_name'] as String,
  splitType: json['split_type'] as String,
  splitValue: json['split_value'],
  actualAmount: (json['actual_amount'] as num).toInt(),
);

Map<String, dynamic> _$SplitToJson(Split instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'full_name': instance.fullName,
  'split_type': instance.splitType,
  'split_value': instance.splitValue,
  'actual_amount': instance.actualAmount,
};
