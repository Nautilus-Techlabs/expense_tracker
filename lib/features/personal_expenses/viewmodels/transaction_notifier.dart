import 'package:drift/drift.dart';
import 'package:expense_tracker/data/local/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../domain/entities/category.dart';
import '../../../../domain/entities/opening_balance.dart';
import '../../../../domain/entities/transaction.dart';
import '../viewmodels/transaction_state.dart';

final transactionProvider =
    NotifierProvider<TransactionController, TransactionState>(() {
      return TransactionController();
    });

class TransactionController extends Notifier<TransactionState> {
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
      // state = state.copyWith(bankLogos: BankParserFactory.getBankLogos());
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

        state = state.copyWith(
          allTransactions: allTransactions,
          openingBalances: openingBalances,
          isShowingSampleData: false,
        );

        // 🔔 Update Notifications based on missing balances
        final notificationService = NotificationService.instance;
        final missing = state.missingInitialBalances;
        if (missing.isNotEmpty) {
          notificationService.scheduleBalanceReminders(
            missingBanks: missing.map((e) => e.bankName).toSet().toList(),
          );
        } else {
          notificationService.cancelAllReminders();
        }
      }
    } catch (e, stack) {
      AppLogger.e("Failed to load transactions from storage", e, stack);
      state = state.copyWith(debugInfo: "${state.debugInfo}Load Error: $e\n");
    }
  }

  Future<void> syncTransactions({bool isStartup = false}) async {
    // SMS Sync removed
  }

  void setSort(TransactionSort sort) {
    state = state.copyWith(currentSort: sort);
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
    String? merchant,
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
          merchant: Value(merchant),
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

      // We no longer snap to midnight to allow precise timing for opening balance
      // If a user picks a transaction, we want the exact timestamp.
      await db.setOpeningBalance(
        OpeningBalancesCompanion(
          bankName: Value(balance.bankName),
          accountNumber: Value(balance.accountNumber),
          amount: Value(balance.amount),
          date: Value(balance.date),
        ),
      );
      await loadFromStorage();

      // 🔔 Refresh notifications after change
      final missing = state.missingInitialBalances;
      if (missing.isEmpty) {
        NotificationService.instance.cancelAllReminders();
      } else {
        NotificationService.instance.scheduleBalanceReminders(
          missingBanks: missing.map((e) => e.bankName).toSet().toList(),
        );
      }
    } catch (e, stack) {
      AppLogger.e("Failed to set opening balance", e, stack);
      String userMessage = "Failed to set opening balance";

      final errorStr = e.toString();
      if (errorStr.contains("2067") ||
          errorStr.contains("UNIQUE constraint failed")) {
        userMessage = "An opening balance for this account already exists.";
      } else {
        userMessage = "Error: $e";
      }

      state = state.copyWith(errorMessage: () => userMessage);
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
      String userMessage = "Failed to add category";
      final errorStr = e.toString();
      if (errorStr.contains("2067") ||
          errorStr.contains("UNIQUE constraint failed")) {
        userMessage = "A category with this name already exists.";
      } else {
        userMessage = "Error: $e";
      }
      state = state.copyWith(errorMessage: () => userMessage);
      return null;
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      final transaction = state.allTransactions.firstWhere((t) => t.id == id);
      if (transaction.source != TransactionSource.manual) {
        state = state.copyWith(
          errorMessage: () => "Only manual transactions can be deleted",
        );
        return;
      }

      final db = ref.read(databaseProvider);
      await (db.delete(db.transactions)..where((t) => t.id.equals(id))).go();
      await loadFromStorage();
    } catch (e, stack) {
      AppLogger.e("Failed to delete transaction", e, stack);
      state = state.copyWith(errorMessage: () => "Delete failed: $e");
    }
  }
}
