import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/sms_service.dart';
import 'transaction_state.dart';

final transactionProvider =
    NotifierProvider<TransactionController, TransactionState>(() {
      return TransactionController();
    });

class TransactionController extends Notifier<TransactionState> {
  static const String _storageKey = 'persisted_transactions_v2';
  final SmsService _smsService = SmsService();

  @override
  TransactionState build() {
    // Initial state
    // We can't do async work here directly, but we can trigger it
    Future.microtask(() => _init());
    return TransactionState();
  }

  Future<void> _init() async {
    await loadFromStorage();
    await syncTransactions(isStartup: true);
  }

  // Notifier state is accessed via 'state'

  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null) {
        final List<dynamic> decoded = json.decode(jsonStr);
        final List<Transaction> allTransactions = decoded
            .map((m) => Transaction.fromMap(m))
            .toList();
        state = state.copyWith(
          allTransactions: allTransactions,
          isShowingSampleData: false,
        );
      }
    } catch (e) {
      state = state.copyWith(debugInfo: "${state.debugInfo}Load Error: $e\n");
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final realTransactions = state.allTransactions
          .where((t) => !t.isSample)
          .toList();
      final jsonStr = json.encode(
        realTransactions.map((t) => t.toMap()).toList(),
      );
      await prefs.setString(_storageKey, jsonStr);
    } catch (e) {
      state = state.copyWith(debugInfo: "${state.debugInfo}Save Error: $e\n");
    }
  }

  Future<void> syncTransactions({bool isStartup = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      debugInfo:
          "${state.debugInfo}Sync started (${isStartup ? 'Startup' : 'Manual'})...\n",
    );

    try {
      final fetched = await _smsService.syncTransactions(
        forceAll: !isStartup,
        onDebug: (msg) {
          state = state.copyWith(debugInfo: "${state.debugInfo}$msg\n");
        },
      );

      bool hasRealDataInResult = fetched.any((t) => !t.isSample);

      if (hasRealDataInResult) {
        final existingSms = state.allTransactions
            .where((t) => !t.isSample)
            .map((t) => t.rawSms)
            .toSet();
        final List<Transaction> merged = state.allTransactions
            .where((t) => !t.isSample)
            .toList();

        for (var tx in fetched) {
          if (!tx.isSample && !existingSms.contains(tx.rawSms)) {
            merged.add(tx);
          }
        }

        state = state.copyWith(
          allTransactions: merged,
          isShowingSampleData: false,
          isLoading: false,
        );
        await _saveToStorage();
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
    } catch (e) {
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
}
