import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/app_logger.dart';
import '../../data/local/app_database.dart';
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

      if (entries.isNotEmpty) {
        final List<Transaction> allTransactions = entries.map((e) {
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
          rawSms: t.rawSms,
          bankName: t.bankName,
          templateName: Value(t.templateName),
          isVerified: Value(t.isVerified),
          isSample: Value(t.isSample),
          description: Value(t.description),
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
        // forceSampleData: true,
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
  }) async {
    try {
      final db = ref.read(databaseProvider);

      await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
        TransactionsCompanion(
          amount: Value(amount),
          method: Value(method),
          isVerified: Value(isVerified),
          description: Value(description),
        ),
      );

      await loadFromStorage();
    } catch (e, stack) {
      AppLogger.e("Transaction update failed", e, stack);
      state = state.copyWith(errorMessage: () => "Update failed: $e");
    }
  }
}
