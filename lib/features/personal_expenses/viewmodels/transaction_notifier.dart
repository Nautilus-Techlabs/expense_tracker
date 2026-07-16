import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/remote/supabase/supabase_helper.dart';
import '../../auth/viewmodels/auth_notifier.dart';
import '../models/transaction_payload.dart';
import 'account_notifier.dart';
import 'budget_notifier.dart';
import 'report_notifier.dart';
import 'transaction_state.dart';

final transactionProvider =
    NotifierProvider<TransactionNotifier, TransactionState>(() {
      return TransactionNotifier();
    });

class TransactionNotifier extends Notifier<TransactionState> {
  @override
  TransactionState build() {
    // Attempt to fetch transactions if user is already available
    final user = ref.watch(authProvider).user;
    if (user != null) {
      Future.microtask(() => fetchTransactions());
    }
    return TransactionState();
  }

  Future<void> fetchTransactions() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    state = state.copyWith(isLoading: true);
    final result = await SupabaseHelper().fetchAllTransactions(user.id);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: () => failure.message,
      ),
      (transactions) {
        transactions.sort((a, b) => b.txnDate.compareTo(a.txnDate));
        state = state.copyWith(isLoading: false, transactions: transactions);
      },
    );
  }

  // Alias for Pull-to-refresh
  Future<void> syncTransactions() async {
    await fetchTransactions();
  }

  /// Re-fetches accounts, budget and reports after any mutation so all screens
  /// (dashboard, accounts list, budget tracker, reports) stay in sync.
  void _refreshDependentProviders() {
    ref.read(accountProvider.notifier).fetchAccounts();
    ref.read(budgetProvider.notifier).fetchBudget();
    ref.read(reportProvider.notifier).refresh();
  }

  Future<bool> addTransaction(TransactionPayload payload) async {
    final user = ref.read(authProvider).user;
    if (user == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await SupabaseHelper().addTransactions(payload);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      (transaction) {
        final newTransactions = [transaction, ...state.transactions];
        newTransactions.sort((a, b) => b.txnDate.compareTo(a.txnDate));
        state = state.copyWith(isLoading: false, transactions: newTransactions);
        _refreshDependentProviders();
        return true;
      },
    );
  }

  Future<bool> updateTransaction({
    required int transactionId,
    required TransactionPayload updates,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await SupabaseHelper().updateTransaction(
      transactionId: transactionId,
      updates: updates,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      (updatedTransaction) {
        final updatedList = state.transactions.map((t) {
          return t.id == transactionId ? updatedTransaction : t;
        }).toList();
        updatedList.sort((a, b) => b.txnDate.compareTo(a.txnDate));
        state = state.copyWith(isLoading: false, transactions: updatedList);
        _refreshDependentProviders();
        return true;
      },
    );
  }

  Future<bool> deleteTransaction(int transactionId) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await SupabaseHelper().deleteTransaction(
      transactionId: transactionId,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      (_) {
        final filtered = state.transactions
            .where((t) => t.id != transactionId)
            .toList();
        state = state.copyWith(isLoading: false, transactions: filtered);
        _refreshDependentProviders();
        return true;
      },
    );
  }
}

