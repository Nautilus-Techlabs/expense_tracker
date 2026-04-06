enum TransactionType { debit, credit }

enum PaymentMethod { upi, card, atm, imps, neft, rtgs, unknown }

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
