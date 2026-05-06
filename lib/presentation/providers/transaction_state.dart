import '../../domain/entities/opening_balance.dart';
import '../../domain/entities/transaction.dart';

enum TransactionSort { dateDesc, dateAsc, amountDesc, amountAsc }

class BankAccount {
  final String bankName;
  final String accountNumber;

  BankAccount({required this.bankName, required this.accountNumber});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankAccount &&
          runtimeType == other.runtimeType &&
          bankName == other.bankName &&
          accountNumber == other.accountNumber;

  @override
  int get hashCode => bankName.hashCode ^ accountNumber.hashCode;

  String get displayName =>
      "$bankName ${accountNumber.isNotEmpty ? '...${accountNumber.replaceAll(RegExp(r'[^0-9]'), '')}' : ''}"
          .trim();
}

class TransactionState {
  final List<Transaction> allTransactions;
  final bool isLoading;
  final String? errorMessage;
  final String debugInfo;
  final bool isShowingSampleData;
  final List<OpeningBalance> openingBalances;
  final String? selectedBank;
  final PaymentMethod? selectedMethod;
  final TransactionSort currentSort;
  final Map<String, String> bankLogos;

  TransactionState({
    this.allTransactions = const [],
    this.openingBalances = const [],
    this.isLoading = false,
    this.errorMessage,
    this.debugInfo = "",
    this.isShowingSampleData = false,
    this.selectedBank,
    this.selectedMethod,
    this.currentSort = TransactionSort.dateDesc,
    this.bankLogos = const {},
  });

  // Global (Unfiltered) Summary Data - For Dashboard
  // Global (Unfiltered) Summary Data - For Dashboard
  double get totalGlobalDebit {
    double total = 0;
    final accounts = getUniqueAccounts();
    
    // 1. Sum debits from accounts with opening balances (from opening date onwards)
    for (final acc in accounts) {
      final opening = _getOpeningFor(acc.bankName, acc.accountNumber);
      if (opening != null) {
        total += allTransactions
            .where((t) => t.bankName == acc.bankName && t.account == acc.accountNumber)
            .where((t) => t.type == TransactionType.debit)
            .where((t) => t.date.isAfter(opening.date.subtract(const Duration(seconds: 1))))
            .fold(0.0, (sum, t) => sum + t.amount);
      } else {
        // No opening balance, sum all
        total += allTransactions
            .where((t) => t.bankName == acc.bankName && t.account == acc.accountNumber)
            .where((t) => t.type == TransactionType.debit)
            .fold(0.0, (sum, t) => sum + t.amount);
      }
    }

    // 2. Add debits from transactions without accounts
    total += allTransactions
        .where((t) => t.account == null || t.account!.isEmpty)
        .where((t) => t.type == TransactionType.debit)
        .fold(0.0, (sum, t) => sum + t.amount);

    return total;
  }

  double get totalGlobalCredit {
    double total = 0;
    final accounts = getUniqueAccounts();
    
    for (final acc in accounts) {
      final opening = _getOpeningFor(acc.bankName, acc.accountNumber);
      if (opening != null) {
        total += allTransactions
            .where((t) => t.bankName == acc.bankName && t.account == acc.accountNumber)
            .where((t) => t.type == TransactionType.credit)
            .where((t) => t.date.isAfter(opening.date.subtract(const Duration(seconds: 1))))
            .fold(0.0, (sum, t) => sum + t.amount);
      } else {
        total += allTransactions
            .where((t) => t.bankName == acc.bankName && t.account == acc.accountNumber)
            .where((t) => t.type == TransactionType.credit)
            .fold(0.0, (sum, t) => sum + t.amount);
      }
    }

    total += allTransactions
        .where((t) => t.account == null || t.account!.isEmpty)
        .where((t) => t.type == TransactionType.credit)
        .fold(0.0, (sum, t) => sum + t.amount);

    return total;
  }

  double get globalBalance {
    double total = 0;
    final accounts = getUniqueAccounts();

    // 1. Sum up per-account balances
    for (final acc in accounts) {
      final opening = _getOpeningFor(acc.bankName, acc.accountNumber);
      double accountTotal = opening?.amount ?? 0;
      
      final txs = allTransactions.where((t) => 
        t.bankName == acc.bankName && t.account == acc.accountNumber);
      
      final filteredTxs = opening != null 
          ? txs.where((t) => t.date.isAfter(opening.date.subtract(const Duration(seconds: 1))))
          : txs;

      for (final t in filteredTxs) {
        if (t.type == TransactionType.credit) {
          accountTotal += t.amount;
        } else {
          accountTotal -= t.amount;
        }
      }
      total += accountTotal;
    }

    // 2. Add impact of transactions without accounts
    final orphanedTxs = allTransactions.where((t) => t.account == null || t.account!.isEmpty);
    for (final t in orphanedTxs) {
      if (t.type == TransactionType.credit) {
        total += t.amount;
      } else {
        total -= t.amount;
      }
    }

    return total;
  }

  double getAccountBalance(String bank, String acc) {
    final opening = _getOpeningFor(bank, acc);
    double accountTotal = opening?.amount ?? 0;

    final txs = allTransactions.where((t) => t.bankName == bank && t.account == acc);

    final filteredTxs = opening != null
        ? txs.where((t) => t.date.isAfter(opening.date.subtract(const Duration(seconds: 1))))
        : txs;

    for (final t in filteredTxs) {
      if (t.type == TransactionType.credit) {
        accountTotal += t.amount;
      } else {
        accountTotal -= t.amount;
      }
    }
    return accountTotal;
  }

  bool isTransactionBeforeOpening(Transaction t) {
    if (t.account == null || t.account!.isEmpty) return false;
    final opening = _getOpeningFor(t.bankName, t.account!);
    if (opening == null) return false;
    return t.date.isBefore(opening.date);
  }

  OpeningBalance? _getOpeningFor(String bank, String acc) {
    try {
      return openingBalances.firstWhere(
        (ob) => ob.bankName == bank && ob.accountNumber == acc,
      );
    } catch (_) {
      return null;
    }
  }

  // Filtered Summary Data - For Transaction List
  double get totalDebit => filteredTransactions
      .where((t) => t.type == TransactionType.debit)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalCredit => filteredTransactions
      .where((t) => t.type == TransactionType.credit)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance {
    double total = 0;
    final accounts = getUniqueAccounts();
    
    // Check if we are filtering by a specific bank
    if (selectedBank != null) {
      // If filtering by bank, only sum verified accounts for that bank
      for (final acc in accounts.where((a) => a.bankName == selectedBank)) {
        total += getAccountBalance(acc.bankName, acc.accountNumber);
      }
      return total;
    }

    // Default: Return the global calculated balance
    return globalBalance;
  }

  List<Transaction> get transactions => filteredTransactions;

  // Latest 10 Transactions (All visible) - For Dashboard
  List<Transaction> get latestTransactions {
    final list = List<Transaction>.from(allTransactions);
    list.sort((a, b) => b.date.compareTo(a.date));
    return list.take(10).toList();
  }

  List<Transaction> get filteredTransactions {
    final filtered = allTransactions.where((t) {
      // 1. Bank Filter
      bool matchesBank = true;
      if (selectedBank != null) {
        if (selectedBank == 'unsupported') {
          matchesBank = !t.isVerified;
        } else {
          matchesBank = t.isVerified && t.bankName == selectedBank;
        }
      }

      // 2. Method Filter
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

  List<BankAccount> getUniqueAccounts() {
    final accounts = allTransactions
        .where((t) => t.isVerified && t.account != null && t.account!.isNotEmpty)
        .map(
          (t) => BankAccount(
            bankName: t.bankName,
            accountNumber: t.account!,
          ),
        )
        .toSet()
        .toList()
      ..sort((a, b) => a.bankName.compareTo(b.bankName));
    return accounts;
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
    List<OpeningBalance>? openingBalances,
    bool? isLoading,
    String? Function()? errorMessage,
    String? debugInfo,
    bool? isShowingSampleData,
    String? Function()? selectedBank,
    PaymentMethod? Function()? selectedMethod,
    TransactionSort? currentSort,
    Map<String, String>? bankLogos,
  }) {
    return TransactionState(
      allTransactions: allTransactions ?? this.allTransactions,
      openingBalances: openingBalances ?? this.openingBalances,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      debugInfo: debugInfo ?? this.debugInfo,
      isShowingSampleData: isShowingSampleData ?? this.isShowingSampleData,
      selectedBank: selectedBank != null ? selectedBank() : this.selectedBank,
      selectedMethod: selectedMethod != null
          ? selectedMethod()
          : this.selectedMethod,
      currentSort: currentSort ?? this.currentSort,
      bankLogos: bankLogos ?? this.bankLogos,
    );
  }
}
