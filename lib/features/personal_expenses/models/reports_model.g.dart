// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
  trend: Trend.fromJson(json['trend'] as Map<String, dynamic>),
  summary: Summary.fromJson(json['summary'] as Map<String, dynamic>),
  endDate: json['end_date'] as String,
  groupBy: json['group_by'] as String,
  startDate: json['start_date'] as String,
  accountSummary: AccountSummary.fromJson(
    json['account_summary'] as Map<String, dynamic>,
  ),
  spendingBreakdown: SpendingBreakdown.fromJson(
    json['spending_breakdown'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'trend': instance.trend,
      'summary': instance.summary,
      'end_date': instance.endDate,
      'group_by': instance.groupBy,
      'start_date': instance.startDate,
      'account_summary': instance.accountSummary,
      'spending_breakdown': instance.spendingBreakdown,
    };

AccountSummary _$AccountSummaryFromJson(Map<String, dynamic> json) =>
    AccountSummary(
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => Account.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalNet: (json['total_net'] as num).toInt(),
      totalIncome: (json['total_income'] as num).toInt(),
      totalExpense: (json['total_expense'] as num).toInt(),
    );

Map<String, dynamic> _$AccountSummaryToJson(AccountSummary instance) =>
    <String, dynamic>{
      'accounts': instance.accounts,
      'total_net': instance.totalNet,
      'total_income': instance.totalIncome,
      'total_expense': instance.totalExpense,
    };

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
  net: (json['net'] as num).toInt(),
  name: json['name'] as String,
  type: json['type'] as String,
  income: (json['income'] as num).toInt(),
  expense: (json['expense'] as num).toInt(),
  accountId: (json['account_id'] as num).toInt(),
  currentBalance: (json['current_balance'] as num).toInt(),
);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
  'net': instance.net,
  'name': instance.name,
  'type': instance.type,
  'income': instance.income,
  'expense': instance.expense,
  'account_id': instance.accountId,
  'current_balance': instance.currentBalance,
};

SpendingBreakdown _$SpendingBreakdownFromJson(Map<String, dynamic> json) =>
    SpendingBreakdown(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalSpent: (json['total_spent'] as num).toInt(),
    );

Map<String, dynamic> _$SpendingBreakdownToJson(SpendingBreakdown instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'total_spent': instance.totalSpent,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  icon: json['icon'] as String,
  name: json['name'] as String,
  color: json['color'] as String,
  amount: (json['amount'] as num).toInt(),
  percentage: (json['percentage'] as num).toDouble(),
  categoryId: (json['category_id'] as num).toInt(),
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'icon': instance.icon,
  'name': instance.name,
  'color': instance.color,
  'amount': instance.amount,
  'percentage': instance.percentage,
  'category_id': instance.categoryId,
};

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
  net: (json['net'] as num).toInt(),
  income: (json['income'] as num).toInt(),
  expense: (json['expense'] as num).toInt(),
);

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
  'net': instance.net,
  'income': instance.income,
  'expense': instance.expense,
};

Trend _$TrendFromJson(Map<String, dynamic> json) => Trend(
  points: (json['points'] as List<dynamic>)
      .map((e) => Point.fromJson(e as Map<String, dynamic>))
      .toList(),
  endDate: json['end_date'] as String,
  groupBy: json['group_by'] as String,
  startDate: json['start_date'] as String,
);

Map<String, dynamic> _$TrendToJson(Trend instance) => <String, dynamic>{
  'points': instance.points,
  'end_date': instance.endDate,
  'group_by': instance.groupBy,
  'start_date': instance.startDate,
};

Point _$PointFromJson(Map<String, dynamic> json) => Point(
  label: json['label'] as String,
  bucket: json['bucket'] as String,
  income: (json['income'] as num).toInt(),
  expense: (json['expense'] as num).toInt(),
);

Map<String, dynamic> _$PointToJson(Point instance) => <String, dynamic>{
  'label': instance.label,
  'bucket': instance.bucket,
  'income': instance.income,
  'expense': instance.expense,
};
