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

class Transaction {
  final int? id;
  final double amount;
  final TransactionType type;
  final String? merchant;
  final DateTime date;
  final PaymentMethod method;
  final String? account;
  final double? availableBalance;
  final String rawSms;
  final String bankName;
  final String? templateName;
  final bool isVerified;
  final bool isSample;
  final String? description;

  Transaction({
    required this.amount,
    required this.type,
    this.merchant,
    required this.date,
    required this.method,
    this.account,
    this.availableBalance,
    required this.rawSms,
    required this.bankName,
    this.templateName,
    this.isVerified = true,
    this.isSample = false,
    this.id,
    this.description,
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
    );
  }

  Transaction copyWith({
    bool? isSample,
    int? id,
    String? Function()? merchant,
    double? amount,
    PaymentMethod? method,
    String? account,
    String? bankName,
    bool? isVerified,
    String? Function()? description,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type,
      merchant: merchant != null ? merchant() : this.merchant,
      date: date,
      method: method ?? this.method,
      account: account ?? this.account,
      availableBalance: availableBalance,
      rawSms: rawSms,
      bankName: bankName ?? this.bankName,
      templateName: templateName,
      isVerified: isVerified ?? this.isVerified,
      isSample: isSample ?? this.isSample,
      description: description != null ? description() : this.description,
    );
  }

  @override
  String toString() {
    return 'Transaction(amount: $amount, type: $type, method: $method, bank: $bankName, isSample: $isSample, desc: $description)';
  }
}
