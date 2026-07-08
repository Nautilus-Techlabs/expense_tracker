import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'account_id')
  final String accountId;

  @JsonKey(name: 'category_id')
  final String? categoryId;

  @JsonKey(name: 'circle_id')
  final String? circleId;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'amount')
  final double amount;

  @JsonKey(name: 'note')
  final String? note;

  @JsonKey(name: 'txn_date')
  final DateTime txnDate;

  @JsonKey(name: 'is_circle_transaction')
  final bool isCircleTransaction;

  @JsonKey(name: 'is_reimbursement')
  final bool isReimbursement;

  @JsonKey(name: 'reimbursement_ref_id')
  final String? reimbursementRefId;

  @JsonKey(name: 'is_credit_card_txn')
  final bool isCreditCardTxn;

  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  @JsonKey(name: 'is_synced')
  final bool isSynced;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.accountId,
    this.categoryId,
    this.circleId,
    required this.type,
    required this.amount,
    this.note,
    required this.txnDate,
    required this.isCircleTransaction,
    required this.isReimbursement,
    this.reimbursementRefId,
    required this.isCreditCardTxn,
    required this.isDeleted,
    this.deletedAt,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
