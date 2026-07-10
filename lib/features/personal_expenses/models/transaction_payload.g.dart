// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionPayload _$TransactionPayloadFromJson(Map<String, dynamic> json) =>
    TransactionPayload(
      userId: json['user_id'] as String,
      accountId: json['account_id'] as String,
      categoryId: json['category_id'] as String?,
      circleId: json['circle_id'] as String?,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String?,
      txnDate: json['txn_date'] == null
          ? null
          : DateTime.parse(json['txn_date'] as String),
      isCircleTransaction: json['is_circle_transaction'] as bool? ?? false,
      isReimbursement: json['is_reimbursement'] as bool? ?? false,
      reimbursementRefId: json['reimbursement_ref_id'] as String?,
      isCreditCardTxn: json['is_credit_card_txn'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      isSynced: json['is_synced'] as bool? ?? false,
    );

Map<String, dynamic> _$TransactionPayloadToJson(TransactionPayload instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'account_id': instance.accountId,
      'category_id': ?instance.categoryId,
      'circle_id': ?instance.circleId,
      'type': instance.type,
      'amount': instance.amount,
      'note': ?instance.note,
      'txn_date': ?instance.txnDate?.toIso8601String(),
      'is_circle_transaction': instance.isCircleTransaction,
      'is_reimbursement': instance.isReimbursement,
      'reimbursement_ref_id': ?instance.reimbursementRefId,
      'is_credit_card_txn': instance.isCreditCardTxn,
      'is_deleted': instance.isDeleted,
      'deleted_at': ?instance.deletedAt?.toIso8601String(),
      'is_synced': instance.isSynced,
    };
