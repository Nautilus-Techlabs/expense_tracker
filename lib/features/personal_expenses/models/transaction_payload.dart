import 'package:json_annotation/json_annotation.dart';


part 'transaction_payload.g.dart';

@JsonSerializable(includeIfNull: false)
class TransactionPayload {
  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'account_id')
  final int accountId;

  @JsonKey(name: 'category_id')
  final int? categoryId;

  @JsonKey(name: 'circle_id')
  final int? circleId;

  final String type;

  final double amount;

  final String? note;

  @JsonKey(name: 'txn_date')
  final DateTime? txnDate;

  @JsonKey(name: 'is_circle_transaction')
  final bool isCircleTransaction;

  @JsonKey(name: 'is_reimbursement')
  final bool isReimbursement;

  @JsonKey(name: 'paid_by_user_id')
  final int paidByUserId;

  @JsonKey(name: 'reimbursement_ref_id')
  final int? reimbursementRefId;
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  const TransactionPayload({
    required this.userId,
    required this.accountId,
    this.categoryId,
    this.circleId,
    required this.type,
    required this.amount,
    required this.paidByUserId,
    this.note,
    this.txnDate,
    this.isCircleTransaction = false,
    this.isReimbursement = false,
    this.reimbursementRefId,
    this.isDeleted = false,
    this.deletedAt,
  });

  factory TransactionPayload.fromJson(Map<String, dynamic> json) =>
      _$TransactionPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionPayloadToJson(this);
}
