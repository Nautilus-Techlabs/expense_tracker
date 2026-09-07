import 'package:expense_tracker/data/repositories/supabase_provider.dart';
import 'package:expense_tracker/features/personal_expenses/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CircleAllTransactionsState {
  final bool isLoading;
  final String? error;
  final List<TransactionModel> transactions;

  const CircleAllTransactionsState({
    this.isLoading = false,
    this.error,
    this.transactions = const [],
  });

  CircleAllTransactionsState copyWith({
    bool? isLoading,
    String? error,
    List<TransactionModel>? transactions,
    bool clearError = false,
  }) {
    return CircleAllTransactionsState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      transactions: transactions ?? this.transactions,
    );
  }
}

class CircleAllTransactionsNotifier
    extends Notifier<CircleAllTransactionsState> {
  final int circleId;

  CircleAllTransactionsNotifier(this.circleId);

  @override
  CircleAllTransactionsState build() {
    return const CircleAllTransactionsState();
  }

  Future<void> fetchTransactions() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref
        .read(supabaseHelperProvider)
        .getCircleTransactions(circleId: circleId);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (transactions) {
        // Sort by date descending
        transactions.sort((a, b) => b.txnDate.compareTo(a.txnDate));
        state = state.copyWith(isLoading: false, transactions: transactions);
      },
    );
  }
}

final circleAllTransactionsProvider =
    NotifierProvider.family<
      CircleAllTransactionsNotifier,
      CircleAllTransactionsState,
      int
    >(CircleAllTransactionsNotifier.new);
