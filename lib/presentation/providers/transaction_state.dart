import '../../domain/entities/category.dart';
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
  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionType? selectedType;
  final List<Category> categories;
  final int? selectedCategoryId;

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
    this.startDate,
    this.endDate,
    this.selectedType,
    this.categories = const [],
    this.selectedCategoryId,
  });

  int get activeFiltersCount {
    int count = 0;
    if (selectedBank != null) count++;
    if (selectedMethod != null) count++;
    if (selectedType != null) count++;
    if (selectedCategoryId != null) count++;
    if (startDate != null || endDate != null) count++;
    return count;
  }

  // Global (Unfiltered) Summary Data - For Dashboard

  double get totalGlobalCredit {
    double total = 0;
    
    for (final t in allTransactions) {
      if (t.type == TransactionType.credit && !isTransactionBeforeOpening(t)) {
        total += t.amount;
      }
    }
    
    return total;
  }

  double get totalGlobalDebit {
    double total = 0;
    
    for (final t in allTransactions) {
      if (t.type == TransactionType.debit && !isTransactionBeforeOpening(t)) {
        total += t.amount;
      }
    }
    
    return total;
  }

  double get globalBalance {
    double total = 0;
    
    // 1. Sum up per-account balances (correctly handling opening balances)
    final accounts = getUniqueAccounts();
    for (final acc in accounts) {
      total += getAccountBalance(acc.bankName, acc.accountNumber);
    }

    // 2. Add impact of transactions without accounts (orphaned)
    // We check them against the earliest opening balance of their respective bank if available
    final orphanedTxs = allTransactions.where(
      (t) => t.account == null || t.account!.isEmpty,
    );
    for (final t in orphanedTxs) {
      if (!isTransactionBeforeOpening(t)) {
        if (t.type == TransactionType.credit) {
          total += t.amount;
        } else {
          total -= t.amount;
        }
      }
    }

    return total;
  }

  /// Helper to compare account numbers flexibly (e.g., 'XX1234' matches '1234')
  bool _isSameAccount(String? a, String? b) {
    if (a == null || b == null) return a == b;
    if (a == b) return true;
    
    // Extract only digits
    final digitsA = a.replaceAll(RegExp(r'\D'), '');
    final digitsB = b.replaceAll(RegExp(r'\D'), '');
    
    if (digitsA.isEmpty || digitsB.isEmpty) return a.toLowerCase() == b.toLowerCase();
    
    // Compare last 4 digits if both are long enough
    if (digitsA.length >= 4 && digitsB.length >= 4) {
      return digitsA.substring(digitsA.length - 4) == digitsB.substring(digitsB.length - 4);
    }
    
    // Fallback to exact digit match
    return digitsA == digitsB;
  }

  double getAccountBalance(String bank, String acc) {
    final opening = _getOpeningFor(bank, acc);
    double accountTotal = opening?.amount ?? 0;

    final txs = allTransactions.where(
      (t) => t.bankName == bank && _isSameAccount(t.account, acc),
    );

    final filteredTxs = opening != null
        ? txs.where((t) => t.date.millisecondsSinceEpoch > opening.date.millisecondsSinceEpoch)
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
    final bank = t.bankName;
    final acc = t.account;
    
    // If we have an account number, check that specific opening balance
    if (acc != null && acc.isNotEmpty) {
      final matches = openingBalances.where(
        (ob) => ob.bankName == bank && _isSameAccount(ob.accountNumber, acc),
      );
      
      if (matches.isEmpty) return false;
      final opening = matches.first;
      return t.date.millisecondsSinceEpoch <= opening.date.millisecondsSinceEpoch;
    }
    
    // If no account number (orphaned transaction), check if ANY account in this bank has an opening balance.
    // If so, we should probably exclude it if it's before the EARLIEST opening balance for this bank.
    final bankOpenings = openingBalances.where((ob) => ob.bankName == bank);
    if (bankOpenings.isEmpty) return false;
    
    final earliestDate = bankOpenings.map((ob) => ob.date).reduce((a, b) => a.isBefore(b) ? a : b);
    return t.date.millisecondsSinceEpoch <= earliestDate.millisecondsSinceEpoch;
  }

  OpeningBalance? _getOpeningFor(String bank, String acc) {
    final matches = openingBalances.where(
      (ob) => ob.bankName == bank && _isSameAccount(ob.accountNumber, acc),
    );
    return matches.isEmpty ? null : matches.first;
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

  // Latest 10 Unfiltered Transactions - For Dashboard Global Preview
  List<Transaction> get latestTransactions {
    // 1. Get the 10 most recent transactions by date
    final list = List<Transaction>.from(allTransactions);
    list.sort((a, b) => b.date.compareTo(a.date));
    final latest10 = list.take(10).toList();

    // 2. Sort those 10 specifically based on user selection
    switch (currentSort) {
      case TransactionSort.dateDesc:
        latest10.sort((a, b) => b.date.compareTo(a.date));
        break;
      case TransactionSort.dateAsc:
        latest10.sort((a, b) => a.date.compareTo(b.date));
        break;
      case TransactionSort.amountDesc:
        latest10.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case TransactionSort.amountAsc:
        latest10.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }
    return latest10;
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

      // 3. Type Filter
      bool matchesType = true;
      if (selectedType != null) {
        matchesType = t.type == selectedType;
      }

      // 4. Date Range Filter
      bool matchesDate = true;
      if (startDate != null && endDate != null) {
        // Normalize endDate to end of day
        final endOfRange = DateTime(
          endDate!.year,
          endDate!.month,
          endDate!.day,
          23,
          59,
          59,
        );
        matchesDate =
            t.date.isAfter(startDate!.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(endOfRange.add(const Duration(seconds: 1)));
      } else if (startDate != null) {
        matchesDate = t.date.isAfter(
          startDate!.subtract(const Duration(seconds: 1)),
        );
      } else if (endDate != null) {
        final endOfRange = DateTime(
          endDate!.year,
          endDate!.month,
          endDate!.day,
          23,
          59,
          59,
        );
        matchesDate = t.date.isBefore(
          endOfRange.add(const Duration(seconds: 1)),
        );
      }

      // 5. Category Filter
      bool matchesCategory = true;
      if (selectedCategoryId != null) {
        matchesCategory = t.categoryId == selectedCategoryId;
      }

      return matchesBank &&
          matchesMethod &&
          matchesType &&
          matchesDate &&
          matchesCategory;
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
    final seen = <String>{};
    final accounts = <BankAccount>[];

    // 1. Add accounts from transactions
    for (final t in allTransactions) {
      if (t.isVerified && t.account != null && t.account!.isNotEmpty) {
        // Normalize for uniqueness check: "BankName_Last4Digits"
        final digits = t.account!.replaceAll(RegExp(r'\D'), '');
        final suffix = digits.length >= 4 ? digits.substring(digits.length - 4) : digits;
        final normalizedKey = "${t.bankName}_$suffix";
        
        if (!seen.contains(normalizedKey)) {
          seen.add(normalizedKey);
          accounts.add(BankAccount(bankName: t.bankName, accountNumber: t.account!));
        }
      }
    }

    // 2. Add accounts from opening balances that might not have transactions yet
    for (final ob in openingBalances) {
      final digits = ob.accountNumber.replaceAll(RegExp(r'\D'), '');
      final suffix = digits.length >= 4 ? digits.substring(digits.length - 4) : digits;
      final normalizedKey = "${ob.bankName}_$suffix";
      
      if (!seen.contains(normalizedKey)) {
        seen.add(normalizedKey);
        accounts.add(BankAccount(bankName: ob.bankName, accountNumber: ob.accountNumber));
      }
    }

    accounts.sort((a, b) => a.bankName.compareTo(b.bankName));
    return accounts;
  }

  List<BankAccount> get missingInitialBalances {
    final uniqueAccounts = getUniqueAccounts();
    return uniqueAccounts.where((acc) {
      return !_hasOpeningFor(acc.bankName, acc.accountNumber);
    }).toList();
  }

  bool _hasOpeningFor(String bank, String acc) {
    return openingBalances.any(
      (ob) => ob.bankName == bank && _isSameAccount(ob.accountNumber, acc),
    );
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
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
    TransactionType? Function()? selectedType,
    List<Category>? categories,
    int? Function()? selectedCategoryId,
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
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      selectedType: selectedType != null ? selectedType() : this.selectedType,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId != null
          ? selectedCategoryId()
          : this.selectedCategoryId,
    );
  }
}
