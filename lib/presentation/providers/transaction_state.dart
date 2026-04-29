import '../../domain/entities/transaction.dart';

enum TransactionSort { dateDesc, dateAsc, amountDesc, amountAsc }

class TransactionState {
  final List<Transaction> allTransactions;
  final bool isLoading;
  final String? errorMessage;
  final String debugInfo;
  final bool isShowingSampleData;
  final String? selectedBank;
  final PaymentMethod? selectedMethod;
  final TransactionSort currentSort;

  TransactionState({
    this.allTransactions = const [],
    this.isLoading = false,
    this.errorMessage,
    this.debugInfo = "",
    this.isShowingSampleData = false,
    this.selectedBank,
    this.selectedMethod,
    this.currentSort = TransactionSort.dateDesc,
  });

  // Summary Data
  double get totalDebit => filteredTransactions
      .where((t) => t.type == TransactionType.debit)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalCredit => filteredTransactions
      .where((t) => t.type == TransactionType.credit)
      .fold(0, (sum, t) => sum + t.amount);

  double get balance => totalCredit - totalDebit;

  List<Transaction> get transactions => filteredTransactions;

  List<Transaction> get filteredTransactions {
    final filtered = allTransactions.where((t) {
      bool matchesBank = true;
      if (selectedBank != null) {
        if (selectedBank == 'unsupported') {
          matchesBank = !t.isVerified;
        } else {
          matchesBank = t.isVerified && t.bankName == selectedBank;
        }
      }
      bool matchesMethod = true;
      if (selectedMethod != null) {
        matchesMethod = t.method == selectedMethod;
      }
      return matchesBank && matchesMethod;
    }).toList();

    switch (currentSort) {
      case TransactionSort.dateDesc:
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case TransactionSort.dateAsc:
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case TransactionSort.amountDesc:
        filtered.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case TransactionSort.amountAsc:
        filtered.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }
    return filtered;
  }

  List<String> getAvailableBanks() {
    final banks =
        allTransactions
            .where((t) => t.isVerified)
            .map((t) => t.bankName)
            .toSet()
            .toList()
          ..sort();
    return banks;
  }

  bool hasUnsupportedTransactions() {
    return allTransactions.any((t) => !t.isVerified);
  }

  List<PaymentMethod> getAvailableMethods() {
    return allTransactions
        .map((t) => t.method)
        .where((m) => m != PaymentMethod.unknown)
        .toSet()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  TransactionState copyWith({
    List<Transaction>? allTransactions,
    bool? isLoading,
    String? Function()? errorMessage,
    String? debugInfo,
    bool? isShowingSampleData,
    String? Function()? selectedBank,
    PaymentMethod? Function()? selectedMethod,
    TransactionSort? currentSort,
  }) {
    return TransactionState(
      allTransactions: allTransactions ?? this.allTransactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      debugInfo: debugInfo ?? this.debugInfo,
      isShowingSampleData: isShowingSampleData ?? this.isShowingSampleData,
      selectedBank: selectedBank != null ? selectedBank() : this.selectedBank,
      selectedMethod: selectedMethod != null ? selectedMethod() : this.selectedMethod,
      currentSort: currentSort ?? this.currentSort,
    );
  }
}
