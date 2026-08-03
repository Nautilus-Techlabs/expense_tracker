import 'package:expense_tracker/features/personal_expenses/models/transaction_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'circle_transaction_split_model.g.dart';

@JsonSerializable()
class CircleTransactionSplitModel {
  @JsonKey(name: "splits")
  List<Split> splits;
  @JsonKey(name: "transaction")
  TransactionModel transaction;

  CircleTransactionSplitModel({
    required this.splits,
    required this.transaction,
  });

  factory CircleTransactionSplitModel.fromJson(Map<String, dynamic> json) =>
      _$CircleTransactionSplitModelFromJson(json);

  Map<String, dynamic> toJson() => _$CircleTransactionSplitModelToJson(this);
}

@JsonSerializable()
class Split {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "user_id")
  int userId;
  @JsonKey(name: "full_name")
  String fullName;
  @JsonKey(name: "split_type")
  String splitType;
  @JsonKey(name: "split_value")
  dynamic splitValue;
  @JsonKey(name: "actual_amount")
  int actualAmount;

  Split({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.splitType,
    required this.splitValue,
    required this.actualAmount,
  });

  factory Split.fromJson(Map<String, dynamic> json) => _$SplitFromJson(json);

  Map<String, dynamic> toJson() => _$SplitToJson(this);
}
