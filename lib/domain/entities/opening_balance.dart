class OpeningBalance {
  final String bankName;
  final String accountNumber;
  final double amount;
  final DateTime date;

  OpeningBalance({
    required this.bankName,
    required this.accountNumber,
    required this.amount,
    required this.date,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpeningBalance &&
          runtimeType == other.runtimeType &&
          bankName == other.bankName &&
          accountNumber == other.accountNumber;

  @override
  int get hashCode => bankName.hashCode ^ accountNumber.hashCode;
}
