import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadFromStorage() async {
    // TODO: Implement with new Drift schema
    state = state.copyWith(
      allTransactions: [],
      openingBalances: [],
      isShowingSampleData: false,
    );
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
    // TODO: Implement with new Drift schema
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
    // TODO: Implement with new Drift schema
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
    // TODO: Implement with new Drift schema
  }

  Future<void> setOpeningBalance(OpeningBalance balance) async {
    // TODO: Implement with new Drift schema
  }

  Future<void> loadCategories() async {
    // TODO: Implement with new Drift schema
    state = state.copyWith(categories: []);
  }

  Future<int?> addCategory(
    String name, {
    String icon = 'category',
    int? color,
  }) async {
    // TODO: Implement with new Drift schema
    return null;
  }

  Future<void> deleteTransaction(int id) async {
    // TODO: Implement with new Drift schema
  }
}
