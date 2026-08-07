import 'package:json_annotation/json_annotation.dart';

part 'circle_transaction_payload.g.dart';

@JsonSerializable()
class CircleTransactionPayload {
  @JsonKey(name: "p_circle_id")
  final int circleId;

  @JsonKey(name: "p_account_id")
  final int accountId;

  @JsonKey(name: "p_category_id")
  final int categoryId;

  @JsonKey(name: "p_type")
  final String type;

  @JsonKey(name: "p_amount")
  final double amount;

  @JsonKey(name: "p_note")
  final String? note;

  @JsonKey(name: "p_txn_date")
  final String txnDate;

  @JsonKey(name: "p_splits")
  final List<CircleSplitModel> splits;

  const CircleTransactionPayload({
    required this.circleId,
    required this.accountId,
    required this.categoryId,
    required this.type,
    required this.amount,
    this.note,
    required this.txnDate,
    required this.splits,
  });

  factory CircleTransactionPayload.fromJson(Map<String, dynamic> json) =>
      _$CircleTransactionPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$CircleTransactionPayloadToJson(this);
}

@JsonSerializable()
class CircleSplitModel {
  @JsonKey(name: "user_id")
  final int userId;

  @JsonKey(name: "split_type")
  final String splitType;

  @JsonKey(name: "split_value")
  final double? splitValue;

  const CircleSplitModel({
    required this.userId,
    required this.splitType,
    this.splitValue,
  });

  factory CircleSplitModel.fromJson(Map<String, dynamic> json) =>
      _$CircleSplitModelFromJson(json);

  Map<String, dynamic> toJson() => _$CircleSplitModelToJson(this);
}
