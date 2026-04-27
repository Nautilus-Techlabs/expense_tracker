enum TransactionType { 
  debit, credit, meta, unknown; 

  static TransactionType fromString(String name) => 
    TransactionType.values.firstWhere((e) => e.name == name, orElse: () => unknown);
}

enum PaymentMethod { 
  upi, card, atm, imps, neft, rtgs, unknown;

  static PaymentMethod fromString(String name) => 
    PaymentMethod.values.firstWhere((e) => e.name == name, orElse: () => unknown);
}

class Transaction {
  final double amount;
  final TransactionType type;
  final String? merchant;
  final DateTime date;
  final PaymentMethod method;
  final String? account;
  final double? availableBalance;
  final String rawSms;
  
  // Metadata for debugging and confidence
  final String bankName;
  final String? templateName;
  final bool isVerified;
  
  // New: Persistence & Sample flags
  final bool isSample;

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
  });

  Map<String, dynamic> toMap() {
    return {
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
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
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
    );
  }

  Transaction copyWith({bool? isSample}) {
    return Transaction(
      amount: amount,
      type: type,
      merchant: merchant,
      date: date,
      method: method,
      account: account,
      availableBalance: availableBalance,
      rawSms: rawSms,
      bankName: bankName,
      templateName: templateName,
      isVerified: isVerified,
      isSample: isSample ?? this.isSample,
    );
  }

  @override
  String toString() {
    return 'Transaction(amount: $amount, type: $type, method: $method, bank: $bankName, isSample: $isSample)';
  }
}
