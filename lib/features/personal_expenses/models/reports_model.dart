import 'package:json_annotation/json_annotation.dart';

part 'reports_model.g.dart';

@JsonSerializable()
class ReportModel {
  @JsonKey(name: "trend")
  Trend trend;
  @JsonKey(name: "summary")
  Summary summary;
  @JsonKey(name: "end_date")
  String endDate;
  @JsonKey(name: "group_by")
  String groupBy;
  @JsonKey(name: "start_date")
  String startDate;
  @JsonKey(name: "account_summary")
  AccountSummary accountSummary;
  @JsonKey(name: "spending_breakdown")
  SpendingBreakdown spendingBreakdown;

  ReportModel({
    required this.trend,
    required this.summary,
    required this.endDate,
    required this.groupBy,
    required this.startDate,
    required this.accountSummary,
    required this.spendingBreakdown,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}

@JsonSerializable()
class AccountSummary {
  @JsonKey(name: "accounts")
  List<Account> accounts;
  @JsonKey(name: "total_net")
  int totalNet;
  @JsonKey(name: "total_income")
  int totalIncome;
  @JsonKey(name: "total_expense")
  int totalExpense;

  AccountSummary({
    required this.accounts,
    required this.totalNet,
    required this.totalIncome,
    required this.totalExpense,
  });

  factory AccountSummary.fromJson(Map<String, dynamic> json) =>
      _$AccountSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$AccountSummaryToJson(this);
}

@JsonSerializable()
class Account {
  @JsonKey(name: "net")
  int net;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "type")
  String type;
  @JsonKey(name: "income")
  int income;
  @JsonKey(name: "expense")
  int expense;
  @JsonKey(name: "account_id")
  int accountId;
  @JsonKey(name: "current_balance")
  int currentBalance;

  Account({
    required this.net,
    required this.name,
    required this.type,
    required this.income,
    required this.expense,
    required this.accountId,
    required this.currentBalance,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

@JsonSerializable()
class SpendingBreakdown {
  @JsonKey(name: "categories")
  List<Category> categories;
  @JsonKey(name: "total_spent")
  int totalSpent;

  SpendingBreakdown({required this.categories, required this.totalSpent});

  factory SpendingBreakdown.fromJson(Map<String, dynamic> json) =>
      _$SpendingBreakdownFromJson(json);

  Map<String, dynamic> toJson() => _$SpendingBreakdownToJson(this);
}

@JsonSerializable()
class Category {
  @JsonKey(name: "icon")
  String icon;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "color")
  String color;
  @JsonKey(name: "amount")
  int amount;
  @JsonKey(name: "percentage")
  double percentage;
  @JsonKey(name: "category_id")
  int categoryId;

  Category({
    required this.icon,
    required this.name,
    required this.color,
    required this.amount,
    required this.percentage,
    required this.categoryId,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Summary {
  @JsonKey(name: "net")
  int net;
  @JsonKey(name: "income")
  int income;
  @JsonKey(name: "expense")
  int expense;

  Summary({required this.net, required this.income, required this.expense});

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryToJson(this);
}

@JsonSerializable()
class Trend {
  @JsonKey(name: "points")
  List<Point> points;
  @JsonKey(name: "end_date")
  String endDate;
  @JsonKey(name: "group_by")
  String groupBy;
  @JsonKey(name: "start_date")
  String startDate;

  Trend({
    required this.points,
    required this.endDate,
    required this.groupBy,
    required this.startDate,
  });

  factory Trend.fromJson(Map<String, dynamic> json) => _$TrendFromJson(json);

  Map<String, dynamic> toJson() => _$TrendToJson(this);
}

@JsonSerializable()
class Point {
  @JsonKey(name: "label")
  String label;
  @JsonKey(name: "bucket")
  String bucket;
  @JsonKey(name: "income")
  int income;
  @JsonKey(name: "expense")
  int expense;

  Point({
    required this.label,
    required this.bucket,
    required this.income,
    required this.expense,
  });

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);

  Map<String, dynamic> toJson() => _$PointToJson(this);
}
