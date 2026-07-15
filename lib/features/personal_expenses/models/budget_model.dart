import 'package:json_annotation/json_annotation.dart';

part 'budget_model.g.dart';

@JsonSerializable()
class UserMonthlyBudget {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'amount')
  final double amount;

  @JsonKey(name: 'month', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime month;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const UserMonthlyBudget({
    required this.id,
    required this.userId,
    required this.amount,
    required this.month,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserMonthlyBudget.fromJson(Map<String, dynamic> json) =>
      _$UserMonthlyBudgetFromJson(json);

  Map<String, dynamic> toJson() => _$UserMonthlyBudgetToJson(this);

  /// Ensures only the date part is stored (YYYY-MM-DD)
  static DateTime _dateFromJson(String value) => DateTime.parse(value);

  static String _dateToJson(DateTime date) =>
      "${date.year.toString().padLeft(4, '0')}-"
      "${date.month.toString().padLeft(2, '0')}-"
      "${date.day.toString().padLeft(2, '0')}";
}
