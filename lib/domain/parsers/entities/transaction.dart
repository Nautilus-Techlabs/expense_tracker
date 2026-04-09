enum TransactionType { 
  debit, credit; 

  static TransactionType fromString(String name) => 
    TransactionType.values.firstWhere((e) => e.name == name, orElse: () => debit);
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

  Transaction({
    required this.amount,
    required this.type,
    this.merchant,
    required this.date,
    required this.method,
    this.account,
    this.availableBalance,
    required this.rawSms,
  });

  @override
  String toString() {
    return 'Transaction(amount: $amount, type: $type, method: $method, merchant: "$merchant", date: $date, account: "$account", avlBal: $availableBalance)';
  }
}
