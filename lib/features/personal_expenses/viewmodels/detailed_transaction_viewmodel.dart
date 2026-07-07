import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/transaction.dart';
import 'transaction_notifier.dart';

// ──────────────────────────────────────────────
// State
// ──────────────────────────────────────────────

class DetailedTransactionState {
  final PaymentMethod method;
  final String account;
  final String bankName;
  final String amount;
  final String description;
  final String merchant;
  final bool isVerified;
  final int? categoryId;
  final bool isEditing;
  final bool isSaving;
  final String? error;
  final bool isInitialized;

  DetailedTransactionState({
    this.method = PaymentMethod.upi,
    this.account = '',
    this.bankName = '',
    this.amount = '0.00',
    this.description = '',
    this.merchant = '',
    this.isVerified = false,
    this.categoryId,
    this.isEditing = false,
    this.isSaving = false,
    this.error,
    this.isInitialized = false,
  });

  DetailedTransactionState copyWith({
    PaymentMethod? method,
    String? account,
    String? bankName,
    String? amount,
    String? description,
    String? merchant,
    bool? isVerified,
    int? categoryId,
    bool? isEditing,
    bool? isSaving,
    String? error,
    bool? isInitialized,
  }) {
    return DetailedTransactionState(
      method: method ?? this.method,
      account: account ?? this.account,
      bankName: bankName ?? this.bankName,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      merchant: merchant ?? this.merchant,
      isVerified: isVerified ?? this.isVerified,
      categoryId: categoryId ?? this.categoryId,
      isEditing: isEditing ?? this.isEditing,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

// ──────────────────────────────────────────────
// ViewModel
// ──────────────────────────────────────────────

class DetailedTransactionViewModel extends Notifier<DetailedTransactionState> {
  late Transaction _transaction;

  @override
  DetailedTransactionState build() {
    return DetailedTransactionState();
  }

  /// Call once from initState to seed the ViewModel with the given transaction.
  void init(Transaction transaction) {
    _transaction = transaction;
    state = DetailedTransactionState(
      method: transaction.method == PaymentMethod.unknown
          ? PaymentMethod.upi
          : transaction.method,
      account: transaction.account ?? '',
      bankName: transaction.bankName,
      amount: transaction.amount.toStringAsFixed(2),
      description: transaction.description ?? '',
      merchant: transaction.merchant ?? '',
      isVerified: transaction.isVerified,
      categoryId: transaction.categoryId,
      isInitialized: true,
    );
  }

  void toggleEditing() {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  void updateField({
    String? account,
    String? bankName,
    String? amount,
    String? description,
    String? merchant,
    PaymentMethod? method,
    int? categoryId,
    bool? isVerified,
  }) {
    state = state.copyWith(
      account: account,
      bankName: bankName,
      amount: amount,
      description: description,
      merchant: merchant,
      method: method,
      categoryId: categoryId,
      isVerified: isVerified,
      error: null,
    );
  }

  Future<bool> saveTransaction() async {
    final parsedAmount = double.tryParse(state.amount);
    if (parsedAmount == null) {
      state = state.copyWith(error: 'Please enter a valid amount');
      return false;
    }
    if (_transaction.id == null) {
      state = state.copyWith(error: 'Cannot edit sample transactions');
      return false;
    }

    state = state.copyWith(isSaving: true, error: null);
    try {
      final isManual = _transaction.source == TransactionSource.manual;
      await ref.read(transactionProvider.notifier).updateTransactionDetails(
            id: _transaction.id!,
            amount: parsedAmount,
            method: state.method,
            isVerified: isManual ? true : state.isVerified,
            description: state.description.trim().isEmpty
                ? null
                : state.description.trim(),
            categoryId: state.categoryId,
            merchant: state.merchant.trim().isEmpty
                ? null
                : state.merchant.trim(),
          );
      state = state.copyWith(isSaving: false, isEditing: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: 'Failed to save: $e');
      return false;
    }
  }

  Future<bool> deleteTransaction() async {
    if (_transaction.id == null) return false;
    state = state.copyWith(isSaving: true, error: null);
    try {
      await ref
          .read(transactionProvider.notifier)
          .deleteTransaction(_transaction.id!);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: 'Failed to delete: $e');
      return false;
    }
  }
}

// ──────────────────────────────────────────────
// Provider
// ──────────────────────────────────────────────

final detailedTransactionViewModelProvider =
    NotifierProvider<DetailedTransactionViewModel, DetailedTransactionState>(
  DetailedTransactionViewModel.new,
);
