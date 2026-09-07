import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/export_service.dart';
import 'account_notifier.dart';
import 'category_notifier.dart';
import 'export_state.dart';
import 'transaction_notifier.dart';

final exportProvider = NotifierProvider<ExportNotifier, ExportState>(
  () => ExportNotifier(),
);

class ExportNotifier extends Notifier<ExportState> {
  @override
  ExportState build() => const ExportState();

  /// Reads current data from Riverpod providers and triggers a CSV export.
  /// [context] is required for the native share sheet positioning on iPad/Mac.
  Future<void> exportCsv(BuildContext context) async {
    final transactions = ref.read(transactionProvider).transactions;
    final accounts = ref.read(accountProvider).accounts;
    final categories = ref.read(categoryProvider).categories;

    if (transactions.isEmpty) {
      state = state.copyWith(errorMessage: () => 'No transactions to export.');
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      exportCompleted: false,
    );

    try {
      await ExportService.exportToCsv(
        context: context,
        transactions: transactions,
        accounts: accounts,
        categories: categories,
      );

      state = state.copyWith(isLoading: false, exportCompleted: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Failed to export data: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: () => null);
  }
}
