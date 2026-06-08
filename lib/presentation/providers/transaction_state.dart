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
  final TransactionSort currentSort;
  final Map<String, String> bankLogos;
  final List<Category> categories;

  TransactionState({
    this.allTransactions = const [],
    this.openingBalances = const [],
    this.isLoading = false,
    this.errorMessage,
    this.debugInfo = "",
    this.isShowingSampleData = false,
    this.currentSort = TransactionSort.dateDesc,
    this.bankLogos = const {},
    this.categories = const [],
  });

  // Global (Unfiltered) Summary Data - For Dashboard

  double get totalGlobalCredit {
    double total = 0;
    final map = _openingMap;
    for (final t in allTransactions) {
      if (t.type == TransactionType.credit && isAfterOpening(t, map)) {
        total += t.amount;
      }
    }
    return total;
  }

  double get totalGlobalDebit {
    double total = 0;
    final map = _openingMap;
    for (final t in allTransactions) {
      if (t.type == TransactionType.debit && isAfterOpening(t, map)) {
        total += t.amount;
      }
    }
    return total;
  }

  double get globalBalance {
    double total = 0;
    final map = _openingMap;

    // Sum up per-account balances
    final accounts = getUniqueAccounts();
    for (final acc in accounts) {
      total += getAccountBalance(acc.bankName, acc.accountNumber, map);
    }

    // Option C: Orphaned transactions are completely excluded from the global balance.
    return total;
  }

  // --- OPTIMIZATION: O(1) Opening Balance Lookups & Account Normalization ---

  static String normalizeAccount(String? a) {
    if (a == null || a.isEmpty) return '';
    final digits = a.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return a.toLowerCase();
    return digits.length >= 4 ? digits.substring(digits.length - 4) : digits;
  }

  Map<String, OpeningBalance> get _openingMap {
    final map = <String, OpeningBalance>{};
    for (final ob in openingBalances) {
      map['${ob.bankName}_${normalizeAccount(ob.accountNumber)}'] = ob;
    }
    return map;
  }

  OpeningBalance? _getOpeningFor(
    Map<String, OpeningBalance> map,
    String bank,
    String? acc,
  ) {
    if (acc == null || acc.isEmpty) return null;
    return map['${bank}_${normalizeAccount(acc)}'];
  }

  bool isAfterOpening(Transaction t, [Map<String, OpeningBalance>? map]) {
    if (t.account == null || t.account!.isEmpty) {
      return false; // Orphaned = excluded
    }

    final openingMap = map ?? _openingMap;
    final opening = _getOpeningFor(openingMap, t.bankName, t.account);

    if (opening == null) {
      return true; // No opening balance means it's always included
    }
    return t.date.millisecondsSinceEpoch > opening.date.millisecondsSinceEpoch;
  }

  // Used by the UI to dim transactions that don't affect the current balance
  // because they happened before the set opening balance date.
  bool isTransactionBeforeOpening(Transaction t) {
    if (t.account == null || t.account!.isEmpty) {
      return false; // Orphaned transactions aren't 'historical', they're just orphaned.
    }
    final opening = _getOpeningFor(_openingMap, t.bankName, t.account);
    if (opening == null) return false;
    return t.date.millisecondsSinceEpoch <= opening.date.millisecondsSinceEpoch;
  }

  double getAccountBalance(
    String bank,
    String acc, [
    Map<String, OpeningBalance>? map,
  ]) {
    final openingMap = map ?? _openingMap;
    final opening = _getOpeningFor(openingMap, bank, acc);
    double accountTotal = opening?.amount ?? 0;

    final normAcc = normalizeAccount(acc);
    final txs = allTransactions.where(
      (t) =>
          t.bankName == bank &&
          t.account != null &&
          normalizeAccount(t.account) == normAcc,
    );

    for (final t in txs) {
      if (opening != null &&
          t.date.millisecondsSinceEpoch <=
              opening.date.millisecondsSinceEpoch) {
        continue;
      }
      if (t.type == TransactionType.credit) {
        accountTotal += t.amount;
      } else {
        accountTotal -= t.amount;
      }
    }
    return accountTotal;
  }

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

  List<BankAccount> getUniqueAccounts() {
    final Map<String, BankAccount> byNormAcc = {};

    // 1. Add accounts from transactions
    for (final t in allTransactions) {
      if (t.account != null && t.account!.isNotEmpty) {
        final normAcc = normalizeAccount(t.account);
        if (normAcc.isEmpty) continue;

        final existing = byNormAcc[normAcc];
        if (existing == null) {
          byNormAcc[normAcc] = BankAccount(
            bankName: t.bankName,
            accountNumber: t.account!,
          );
        } else if (existing.bankName.startsWith('Bank:') &&
            !t.bankName.startsWith('Bank:')) {
          byNormAcc[normAcc] = BankAccount(
            bankName: t.bankName,
            accountNumber: t.account!,
          );
        }
      }
    }

    // 2. Add accounts from opening balances that might not have transactions yet
    for (final ob in openingBalances) {
      final normAcc = normalizeAccount(ob.accountNumber);
      if (normAcc.isEmpty) continue;

      final existing = byNormAcc[normAcc];
      if (existing == null) {
        byNormAcc[normAcc] = BankAccount(
          bankName: ob.bankName,
          accountNumber: ob.accountNumber,
        );
      } else if (existing.bankName.startsWith('Bank:') &&
          !ob.bankName.startsWith('Bank:')) {
        byNormAcc[normAcc] = BankAccount(
          bankName: ob.bankName,
          accountNumber: ob.accountNumber,
        );
      }
    }

    final accounts = byNormAcc.values.toList();
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
    return _getOpeningFor(_openingMap, bank, acc) != null;
  }

  List<String> getAvailableBanks() {
    final banks =
        allTransactions
            .where(
              (t) =>
                  t.isVerified || (t.account != null && t.account!.isNotEmpty),
            )
            .map((t) => t.bankName)
            .toSet()
            .toList()
          ..sort();
    return banks;
  }

  bool hasUnsupportedTransactions() {
    return allTransactions.any(
      (t) => !t.isVerified && (t.account == null || t.account!.isEmpty),
    );
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
    TransactionSort? currentSort,
    Map<String, String>? bankLogos,
    List<Category>? categories,
  }) {
    return TransactionState(
      allTransactions: allTransactions ?? this.allTransactions,
      openingBalances: openingBalances ?? this.openingBalances,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      debugInfo: debugInfo ?? this.debugInfo,
      isShowingSampleData: isShowingSampleData ?? this.isShowingSampleData,
      currentSort: currentSort ?? this.currentSort,
      bankLogos: bankLogos ?? this.bankLogos,
      categories: categories ?? this.categories,
    );
  }
}
