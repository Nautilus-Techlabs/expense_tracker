import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/app_logger.dart';
import '../../data/local/app_database.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/opening_balance.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/parsers/combined_parser.dart';
import '../../domain/sms_service.dart';
import 'transaction_state.dart';

final transactionProvider =
    NotifierProvider<TransactionController, TransactionState>(() {
      return TransactionController();
    });

class TransactionController extends Notifier<TransactionState> {
  final SmsService _smsService = SmsService();

  @override
  TransactionState build() {
    Future.microtask(() => _init());
    return TransactionState(isLoading: true);
  }

  Future<void> _init() async {
    try {
      await loadCategories();
      await loadFromStorage();
      await syncTransactions(isStartup: true);
      // ✅ Populate logos from the config engine
      state = state.copyWith(bankLogos: BankParserFactory.getBankLogos());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadFromStorage() async {
    try {
      final db = ref.read(databaseProvider);
      final entries = await db.getAllTransactions();
      final List<OpeningBalanceEntry> balanceEntries = await db
          .getAllOpeningBalances();

      final List<OpeningBalance> openingBalances = balanceEntries.map((e) {
        return OpeningBalance(
          bankName: e.bankName,
          accountNumber: e.accountNumber,
          amount: e.amount,
          date: e.date,
        );
      }).toList();

      if (entries.isNotEmpty || openingBalances.isNotEmpty) {
        final List<Transaction> allTransactions = entries.map((e) {
          final cat = state.categories.firstWhere(
            (c) => c.id == e.categoryId,
            orElse: () => const Category(name: 'Uncategorized', id: -1),
          );
          return Transaction(
            amount: e.amount,
            type: e.type,
            merchant: e.merchant,
            date: e.date,
            method: e.method,
            account: e.account,
            availableBalance: e.availableBalance,
            rawSms: e.rawSms,
            bankName: e.bankName,
            templateName: e.templateName,
            isVerified: e.isVerified,
            isSample: e.isSample,
            id: e.id,
            description: e.description,
            source: e.source,
            categoryId: e.categoryId,
            category: cat.id == -1 ? null : cat,
          );
        }).toList();

        // Auto-switch away from 'unsupported' if no more unverified transactions exist
        String? currentBank = state.selectedBank;
        if (currentBank == 'unsupported' &&
            !allTransactions.any((t) => !t.isVerified)) {
          currentBank = null;
        }

        state = state.copyWith(
          allTransactions: allTransactions,
          openingBalances: openingBalances,
          isShowingSampleData: false,
          selectedBank: () => currentBank,
        );
      }
    } catch (e, stack) {
      AppLogger.e("Failed to load transactions from storage", e, stack);
      state = state.copyWith(debugInfo: "${state.debugInfo}Load Error: $e\n");
    }
  }

  Future<void> _saveToStorage(List<Transaction> transactions) async {
    try {
      final db = ref.read(databaseProvider);
      final realTransactions = transactions.where((t) => !t.isSample).toList();

      if (realTransactions.isEmpty) return;

      final companions = realTransactions.map((t) {
        return TransactionsCompanion.insert(
          amount: t.amount,
          type: t.type,
          merchant: Value(t.merchant),
          date: t.date,
          method: t.method,
          account: Value(t.account),
          availableBalance: Value(t.availableBalance),
          rawSms: Value(t.rawSms),
          bankName: t.bankName,
          templateName: Value(t.templateName),
          isVerified: Value(t.isVerified),
          isSample: Value(t.isSample),
          description: Value(t.description),
          source: Value(t.source),
          categoryId: Value(t.categoryId),
        );
      }).toList();

      await db.insertTransactions(companions);
    } catch (e, stack) {
      AppLogger.e("Failed to save transactions to storage", e, stack);
      state = state.copyWith(debugInfo: "${state.debugInfo}Save Error: $e\n");
    }
  }

  Future<void> syncTransactions({bool isStartup = false}) async {
    if (!isStartup && state.isLoading) return;

    if (!isStartup) {
      state = state.copyWith(isLoading: true, errorMessage: () => null);
    }

    AppLogger.i("SMS Sync started (${isStartup ? 'Startup' : 'Manual'})");
    state = state.copyWith(
      debugInfo:
          "${state.debugInfo}Sync started (${isStartup ? 'Startup' : 'Manual'})...\n",
    );

    try {
      final fetched = await _smsService.syncTransactions(
        forceAll: false,
        db: ref.read(databaseProvider),
        forceSampleData: true,
      );

      bool hasRealDataInResult = fetched.any((t) => !t.isSample);

      if (hasRealDataInResult) {
        // Save new transactions to DB
        await _saveToStorage(fetched);

        // Reload all transactions from DB to get the merged state
        await loadFromStorage();

        state = state.copyWith(isLoading: false);
      } else {
        if (state.allTransactions.isNotEmpty &&
            state.allTransactions.any((t) => !t.isSample)) {
          state = state.copyWith(isShowingSampleData: false, isLoading: false);
        } else if (fetched.isNotEmpty && fetched.every((t) => t.isSample)) {
          state = state.copyWith(
            allTransactions: fetched,
            isShowingSampleData: true,
            isLoading: false,
          );
        } else {
          state = state.copyWith(isLoading: false);
        }
      }
    } catch (e, stack) {
      AppLogger.e("SMS Sync exception", e, stack);
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => "Sync failed: ${e.toString()}",
        debugInfo: "${state.debugInfo}Sync Exception: $e\n",
      );
    }
  }

  void setSort(TransactionSort sort) {
    state = state.copyWith(currentSort: sort);
  }

  void setBankFilter(String? bank) {
    state = state.copyWith(selectedBank: () => bank);
  }

  void setMethodFilter(PaymentMethod? method) {
    state = state.copyWith(selectedMethod: () => method);
  }

  void setTypeFilter(TransactionType? type) {
    state = state.copyWith(selectedType: () => type);
  }

  void setCategoryFilter(int? categoryId) {
    state = state.copyWith(selectedCategoryId: () => categoryId);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: () => start, endDate: () => end);
  }

  Future<void> verifyTransaction({
    required String rawSms,
    required PaymentMethod method,
    required String account,
    required String bankName,
    String? description,
  }) async {
    try {
      final db = ref.read(databaseProvider);

      // 1. Update the transaction in DB
      await db.updateTransaction(
        TransactionsCompanion(
          rawSms: Value(rawSms),
          method: Value(method),
          account: Value(account),
          bankName: Value(bankName),
          isVerified: const Value(true),
          description: Value(description),
        ),
      );

      // 2. Remove from SmsLogs if exists (user mentioned double entry prevention)
      await db.deleteSmsLogByBody(rawSms);

      // 3. Refresh state
      await loadFromStorage();
    } catch (e, stack) {
      AppLogger.e("Transaction verification failed", e, stack);
      state = state.copyWith(errorMessage: () => "Verification failed: $e");
    }
  }

  Future<void> updateTransactionDetails({
    required int id,
    required double amount,
    required PaymentMethod method,
    required bool isVerified,
    String? description,
    int? categoryId,
  }) async {
    try {
      final db = ref.read(databaseProvider);

      await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
        TransactionsCompanion(
          amount: Value(amount),
          method: Value(method),
          isVerified: Value(isVerified),
          description: Value(description),
          categoryId: Value(categoryId),
        ),
      );

      await loadFromStorage();
    } catch (e, stack) {
      AppLogger.e("Transaction update failed", e, stack);
      state = state.copyWith(errorMessage: () => "Update failed: $e");
    }
  }

  Future<void> addManualTransaction({
    required double amount,
    required TransactionType type,
    required DateTime date,
    required PaymentMethod method,
    String? bankName,
    String? merchant,
    String? account,
    String? description,
    int? categoryId,
  }) async {
    try {
      final db = ref.read(databaseProvider);

      final companion = TransactionsCompanion.insert(
        amount: amount,
        type: type,
        date: date,
        method: method,
        bankName: bankName ?? 'Manual',
        merchant: Value(merchant),
        account: Value(account),
        description: Value(description),
        source: const Value(TransactionSource.manual),
        isVerified: const Value(true),
        rawSms: const Value(null),
        categoryId: Value(categoryId),
      );

      AppLogger.d(
        "Adding manual transaction: ${bankName ?? 'Manual'} - ₹$amount",
      );
      await db.into(db.transactions).insert(companion);

      // Force refresh from storage to ensure UI reflects the change
      await loadFromStorage();
    } catch (e, stack) {
      AppLogger.e("Failed to add manual transaction", e, stack);
      state = state.copyWith(
        errorMessage: () => "Failed to add transaction: $e",
      );
      rethrow;
    }
  }

  Future<void> setOpeningBalance(OpeningBalance balance) async {
    try {
      final db = ref.read(databaseProvider);

      // Safety: Always snap to midnight so transactions on the same day are included
      final snappedDate = DateTime(
        balance.date.year,
        balance.date.month,
        balance.date.day,
      );

      await db.setOpeningBalance(
        OpeningBalancesCompanion(
          bankName: Value(balance.bankName),
          accountNumber: Value(balance.accountNumber),
          amount: Value(balance.amount),
          date: Value(snappedDate),
        ),
      );
      await loadFromStorage();
    } catch (e, stack) {
      AppLogger.e("Failed to set opening balance", e, stack);
      state = state.copyWith(
        errorMessage: () => "Failed to set opening balance: $e",
      );
    }
  }

  Future<void> loadCategories() async {
    try {
      final db = ref.read(databaseProvider);
      var entries = await db.getAllCategories();

      if (entries.isEmpty) {
        // Seed if empty (for users who already migrated but have no data)
        final defaultCategories = [
          (name: 'Housing', icon: 'home', color: 0xFF2196F3),
          (name: 'Transportation', icon: 'directions_car', color: 0xFFFF9800),
          (name: 'Food & Dining', icon: 'restaurant', color: 0xFFF44336),
          (name: 'Utilities', icon: 'bolt', color: 0xFFFFEB3B),
          (name: 'Healthcare', icon: 'medical_services', color: 0xFF4CAF50),
          (name: 'Insurance', icon: 'verified_user', color: 0xFF009688),
          (
            name: 'Savings & Investments',
            icon: 'trending_up',
            color: 0xFF8BC34A,
          ),
          (name: 'Debt Payments', icon: 'payments', color: 0xFF9C27B0),
          (name: 'Shopping', icon: 'shopping_bag', color: 0xFFE91E63),
          (name: 'Entertainment', icon: 'movie', color: 0xFF3F51B5),
          (name: 'Personal Care', icon: 'face', color: 0xFFFF5722),
          (name: 'Education', icon: 'school', color: 0xFF795548),
          (name: 'Travel', icon: 'flight', color: 0xFF00BCD4),
          (name: 'Family & Kids', icon: 'child_care', color: 0xFFFF4081),
          (name: 'Miscellaneous', icon: 'more_horiz', color: 0xFF9E9E9E),
        ];

        for (final cat in defaultCategories) {
          await db.addCategory(
            CategoriesCompanion.insert(
              name: cat.name,
              icon: Value(cat.icon),
              color: Value(cat.color),
            ),
          );
        }
        entries = await db.getAllCategories();
      }

      final categories = entries
          .map(
            (e) =>
                Category(id: e.id, name: e.name, icon: e.icon, color: e.color),
          )
          .toList();
      state = state.copyWith(categories: categories);
    } catch (e, stack) {
      AppLogger.e("Failed to load categories", e, stack);
    }
  }

  Future<int?> addCategory(
    String name, {
    String icon = 'category',
    int? color,
  }) async {
    try {
      final db = ref.read(databaseProvider);
      final id = await db.addCategory(
        CategoriesCompanion.insert(
          name: name,
          icon: Value(icon),
          color: Value(color),
        ),
      );
      await loadCategories();
      return id;
    } catch (e, stack) {
      AppLogger.e("Failed to add category", e, stack);
      state = state.copyWith(errorMessage: () => "Failed to add category: $e");
      return null;
    }
  }
}
