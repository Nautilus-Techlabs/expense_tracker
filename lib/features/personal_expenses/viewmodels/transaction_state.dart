import '../models/transaction_model.dart';

class TransactionState {
  final bool isLoading;
  final List<TransactionModel> transactions;
  final String? errorMessage;

  TransactionState({
    this.isLoading = false,
    this.transactions = const [],
    this.errorMessage,
  });

  TransactionState copyWith({
    bool? isLoading,
    List<TransactionModel>? transactions,
    String? Function()? errorMessage,
  }) {
    return TransactionState(
      isLoading: isLoading ?? this.isLoading,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
