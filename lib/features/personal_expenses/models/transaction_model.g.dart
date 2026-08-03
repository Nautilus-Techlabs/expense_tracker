// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      accountId: (json['account_id'] as num).toInt(),
      categoryId: (json['category_id'] as num?)?.toInt(),
      circleId: (json['circle_id'] as num?)?.toInt(),
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String?,
      txnDate: DateTime.parse(json['txn_date'] as String),
      isCircleTransaction: json['is_circle_transaction'] as bool,
      isReimbursement: json['is_reimbursement'] as bool,
      reimbursementRefId: (json['reimbursement_ref_id'] as num?)?.toInt(),
      isDeleted: json['is_deleted'] as bool,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'account_id': instance.accountId,
      'category_id': instance.categoryId,
      'circle_id': instance.circleId,
      'type': instance.type,
      'amount': instance.amount,
      'note': instance.note,
      'txn_date': instance.txnDate.toIso8601String(),
      'is_circle_transaction': instance.isCircleTransaction,
      'is_reimbursement': instance.isReimbursement,
      'reimbursement_ref_id': instance.reimbursementRefId,
      'is_deleted': instance.isDeleted,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
