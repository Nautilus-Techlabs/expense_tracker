import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/features/personal_expenses/models/transaction_model.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/transaction_notifier.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/transaction_filter_notifier.dart';

class FilteredTransactionsData {
  final List<TransactionModel> filteredTransactions;
  final List<DateTime> availableMonths;
  final double totalCredit;
  final double totalDebit;

  const FilteredTransactionsData({
    required this.filteredTransactions,
    required this.availableMonths,
    required this.totalCredit,
    required this.totalDebit,
  });
}

final filteredTransactionsProvider = Provider<FilteredTransactionsData>((ref) {
  final transactionState = ref.watch(transactionProvider);
  final filterState = ref.watch(transactionFilterProvider);

  final transactions = transactionState.transactions;

  // Generate Months
  final Set<String> uniqueMonths = {};
  final List<DateTime> months = [];
  for (var t in transactions) {
    final key = '${t.txnDate.year}-${t.txnDate.month}';
    if (!uniqueMonths.contains(key)) {
      uniqueMonths.add(key);
      months.add(DateTime(t.txnDate.year, t.txnDate.month, 1));
    }
  }
  months.sort((a, b) => a.compareTo(b));
  if (months.isEmpty) {
    months.add(DateTime(DateTime.now().year, DateTime.now().month, 1));
  }

  // Determine which month is active
  final selectedMonthDate = filterState.selectedMonthDate ?? months.last;

  // Filter
  final String search = filterState.searchQuery.trim().toLowerCase();

  final filteredList = transactions.where((t) {
    if (filterState.selectedSpecificDate == null) {
      if (t.txnDate.year != selectedMonthDate.year ||
          t.txnDate.month != selectedMonthDate.month) {
        return false;
      }
    } else {
      if (t.txnDate.year != filterState.selectedSpecificDate!.year ||
          t.txnDate.month != filterState.selectedSpecificDate!.month ||
          t.txnDate.day != filterState.selectedSpecificDate!.day) {
        return false;
      }
    }

    if (filterState.selectedCategoryId != null &&
        t.categoryId != filterState.selectedCategoryId) {
      return false;
    }

    if (search.isNotEmpty) {
      if (t.note == null || !t.note!.toLowerCase().contains(search)) {
        return false;
      }
    }

    return true;
  }).toList();

  // Sums
  final totalCredit = filteredList
      .where((t) => t.type == 'income')
      .fold<double>(0, (sum, t) => sum + t.amount);

  final totalDebit = filteredList
      .where((t) => t.type == 'expense' || t.type == 'withdrawal')
      .fold<double>(0, (sum, t) => sum + t.amount);

  return FilteredTransactionsData(
    filteredTransactions: filteredList,
    availableMonths: months,
    totalCredit: totalCredit,
    totalDebit: totalDebit,
  );
});
