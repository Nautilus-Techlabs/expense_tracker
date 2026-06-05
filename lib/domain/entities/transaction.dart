import 'package:expense_tracker/domain/entities/category.dart';
enum TransactionType {
  debit,
  credit,
  meta,
  unknown;

  static TransactionType fromString(String name) => TransactionType.values
      .firstWhere((e) => e.name == name, orElse: () => unknown);
}

enum PaymentMethod {
  upi,
  card,
  atm,
  imps,
  neft,
  rtgs,
  unknown;

  static PaymentMethod fromString(String name) => PaymentMethod.values
      .firstWhere((e) => e.name == name, orElse: () => unknown);
}

enum TransactionSource {
  sms,
  manual;

  static TransactionSource fromString(String name) => TransactionSource.values
      .firstWhere((e) => e.name == name, orElse: () => sms);
}

class Transaction {
  final int? id;
  final double amount;
  final TransactionType type;
  final String? merchant;
  final DateTime date;
  final PaymentMethod method;
  final String? account;
  final double? availableBalance;
  final String? rawSms;
  final String bankName;
  final String? templateName;
  final bool isVerified;
  final bool isSample;
  final String? description;
  final TransactionSource source;
  final int? categoryId;
  final Category? category;
  final String? senderId;

  Transaction({
    required this.amount,
    required this.type,
    this.merchant,
    required this.date,
    required this.method,
    this.account,
    this.availableBalance,
    this.rawSms,
    required this.bankName,
    this.templateName,
    this.isVerified = true,
    this.isSample = false,
    this.id,
    this.description,
    this.source = TransactionSource.sms,
    this.categoryId,
    this.category,
    this.senderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type.name,
      'merchant': merchant,
      'date': date.millisecondsSinceEpoch,
      'method': method.name,
      'account': account,
      'availableBalance': availableBalance,
      'rawSms': rawSms,
      'bankName': bankName,
      'templateName': templateName,
      'isVerified': isVerified,
      'isSample': isSample,
      'description': description,
      'source': source.name,
      'categoryId': categoryId,
      'senderId': senderId,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: (map['amount'] as num).toDouble(),
      type: TransactionType.fromString(map['type']),
      merchant: map['merchant'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      method: PaymentMethod.fromString(map['method']),
      account: map['account'],
      availableBalance: map['availableBalance'] != null
          ? (map['availableBalance'] as num).toDouble()
          : null,
      rawSms: map['rawSms'],
      bankName: map['bankName'],
      templateName: map['templateName'],
      isVerified: map['isVerified'] ?? true,
      isSample: map['isSample'] ?? false,
      description: map['description'],
      source: TransactionSource.fromString(map['source'] ?? 'sms'),
      categoryId: map['categoryId'],
      category: map['category'] != null ? Category.fromMap(map['category']) : null,
      senderId: map['senderId'],
    );
  }

  Transaction copyWith({
    bool? isSample,
    int? id,
    String? Function()? merchant,
    double? amount,
    PaymentMethod? method,
    String? Function()? account,
    double? Function()? availableBalance,
    String? bankName,
    bool? isVerified,
    String? Function()? description,
    TransactionSource? source,
    int? Function()? categoryId,
    Category? Function()? category,
    String? Function()? senderId,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type,
      merchant: merchant != null ? merchant() : this.merchant,
      date: date,
      method: method ?? this.method,
      account: account != null ? account() : this.account,
      availableBalance:
          availableBalance != null ? availableBalance() : this.availableBalance,
      rawSms: rawSms,
      bankName: bankName ?? this.bankName,
      templateName: templateName,
      isVerified: isVerified ?? this.isVerified,
      isSample: isSample ?? this.isSample,
      description: description != null ? description() : this.description,
      source: source ?? this.source,
      categoryId: categoryId != null ? categoryId() : this.categoryId,
      category: category != null ? category() : this.category,
      senderId: senderId != null ? senderId() : this.senderId,
    );
  }


  @override
  String toString() {
    return 'Transaction(amount: $amount, type: $type, method: $method, bank: $bankName, source: $source, isSample: $isSample, desc: $description, senderId: $senderId)';
  }
}
