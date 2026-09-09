class RecurringBillModel {
  final String id;
  final String title;
  final double amount;
  final int categoryId;
  final int accountId;
  final int dayOfMonth; // 1 to 31
  final String? lastLoggedMonth; // Format 'YYYY-MM'
  final bool isActive;
  final DateTime createdAt;

  const RecurringBillModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.accountId,
    required this.dayOfMonth,
    this.lastLoggedMonth,
    this.isActive = true,
    required this.createdAt,
  });

  bool isDueForMonth(DateTime now) {
    if (!isActive) return false;
    final currentMonthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    if (lastLoggedMonth == currentMonthKey) return false;
    return now.day >= dayOfMonth;
  }

  RecurringBillModel copyWith({
    String? id,
    String? title,
    double? amount,
    int? categoryId,
    int? accountId,
    int? dayOfMonth,
    String? lastLoggedMonth,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return RecurringBillModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      lastLoggedMonth: lastLoggedMonth ?? this.lastLoggedMonth,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category_id': categoryId,
      'account_id': accountId,
      'day_of_month': dayOfMonth,
      'last_logged_month': lastLoggedMonth,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory RecurringBillModel.fromJson(Map<String, dynamic> json) {
    return RecurringBillModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Recurring Bill',
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['category_id'] as int,
      accountId: json['account_id'] as int,
      dayOfMonth: json['day_of_month'] as int,
      lastLoggedMonth: json['last_logged_month'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
