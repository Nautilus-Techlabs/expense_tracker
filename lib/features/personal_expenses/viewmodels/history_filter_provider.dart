import 'package:expense_tracker/features/personal_expenses/viewmodels/transaction_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../domain/entities/transaction.dart';
import 'transaction_state.dart';

class HistoryFilterState {
  final String? selectedBank;
  final PaymentMethod? selectedMethod;
  final TransactionType? selectedType;
  final Set<int> selectedCategoryIds;
  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionSort currentSort;

  HistoryFilterState({
    this.selectedBank,
    this.selectedMethod,
    this.selectedType,
    this.selectedCategoryIds = const {},
    this.startDate,
    this.endDate,
    this.currentSort = TransactionSort.dateDesc,
  });

  int get activeFiltersCount {
    int count = 0;
    if (selectedBank != null) count++;
    if (selectedMethod != null) count++;
    if (selectedType != null) count++;
    if (selectedCategoryIds.isNotEmpty) count++;
    if (startDate != null || endDate != null) count++;
    return count;
  }

  HistoryFilterState copyWith({
    String? Function()? selectedBank,
    PaymentMethod? Function()? selectedMethod,
    TransactionType? Function()? selectedType,
    Set<int>? selectedCategoryIds,
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
    TransactionSort? currentSort,
  }) {
    return HistoryFilterState(
      selectedBank: selectedBank != null ? selectedBank() : this.selectedBank,
      selectedMethod: selectedMethod != null
          ? selectedMethod()
          : this.selectedMethod,
      selectedType: selectedType != null ? selectedType() : this.selectedType,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      currentSort: currentSort ?? this.currentSort,
    );
  }
}

class HistoryFilterNotifier extends StateNotifier<HistoryFilterState> {
  HistoryFilterNotifier() : super(HistoryFilterState());

  void setBankFilter(String? bank) {
    state = state.copyWith(selectedBank: () => bank);
  }

  void setMethodFilter(PaymentMethod? method) {
    state = state.copyWith(selectedMethod: () => method);
  }

  void setTypeFilter(TransactionType? type) {
    state = state.copyWith(selectedType: () => type);
  }

  void toggleCategoryFilter(int categoryId) {
    final current = Set<int>.from(state.selectedCategoryIds);
    if (current.contains(categoryId)) {
      current.remove(categoryId);
    } else {
      current.add(categoryId);
    }
    state = state.copyWith(selectedCategoryIds: current);
  }

  void clearCategoryFilter() {
    state = state.copyWith(selectedCategoryIds: {});
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: () => start, endDate: () => end);
  }

  void setSort(TransactionSort sort) {
    state = state.copyWith(currentSort: sort);
  }

  void clearAll() {
    state = HistoryFilterState();
  }
}

final historyFilterProvider =
    StateNotifierProvider<HistoryFilterNotifier, HistoryFilterState>((ref) {
      return HistoryFilterNotifier();
    });

final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final allTransactions = ref.watch(transactionProvider).allTransactions;
  final filters = ref.watch(historyFilterProvider);

  final filtered = allTransactions.where((t) {
    // 1. Bank/Account Filter
    bool matchesBank = true;
    if (filters.selectedBank != null) {
      if (filters.selectedBank == 'unsupported') {
        matchesBank = !t.isVerified && (t.account == null || t.account!.isEmpty);
      } else {
        final normalizedSelected = TransactionState.normalizeAccount(
          filters.selectedBank,
        );
        final hasAccount = t.account != null && t.account!.isNotEmpty;
        final isKnown = t.isVerified || hasAccount;

        final matchesName = isKnown && t.bankName == filters.selectedBank;
        final matchesAcc =
            isKnown &&
            hasAccount &&
            TransactionState.normalizeAccount(t.account) == normalizedSelected;
        matchesBank = matchesName || matchesAcc;
      }
    }

    // 2. Method Filter
    bool matchesMethod = true;
    if (filters.selectedMethod != null) {
      matchesMethod = t.method == filters.selectedMethod;
    }

    // 3. Type Filter
    bool matchesType = true;
    if (filters.selectedType != null) {
      matchesType = t.type == filters.selectedType;
    }

    // 4. Date Range Filter
    bool matchesDate = true;
    if (filters.startDate != null && filters.endDate != null) {
      final endOfRange = DateTime(
        filters.endDate!.year,
        filters.endDate!.month,
        filters.endDate!.day,
        23,
        59,
        59,
      );
      matchesDate =
          t.date.isAfter(
            filters.startDate!.subtract(const Duration(seconds: 1)),
          ) &&
          t.date.isBefore(endOfRange.add(const Duration(seconds: 1)));
    } else if (filters.startDate != null) {
      matchesDate = t.date.isAfter(
        filters.startDate!.subtract(const Duration(seconds: 1)),
      );
    } else if (filters.endDate != null) {
      final endOfRange = DateTime(
        filters.endDate!.year,
        filters.endDate!.month,
        filters.endDate!.day,
        23,
        59,
        59,
      );
      matchesDate = t.date.isBefore(endOfRange.add(const Duration(seconds: 1)));
    }

    // 5. Category Filter
    bool matchesCategory = true;
    if (filters.selectedCategoryIds.isNotEmpty) {
      matchesCategory = filters.selectedCategoryIds.contains(t.categoryId);
    }

    return matchesBank &&
        matchesMethod &&
        matchesType &&
        matchesDate &&
        matchesCategory;
  }).toList();

  switch (filters.currentSort) {
    case TransactionSort.dateDesc:
      filtered.sort((a, b) => b.date.compareTo(a.date));
      break;
    case TransactionSort.dateAsc:
      filtered.sort((a, b) => a.date.compareTo(b.date));
      break;
    case TransactionSort.amountDesc:
      filtered.sort((a, b) => b.amount.compareTo(a.amount));
      break;
    case TransactionSort.amountAsc:
      filtered.sort((a, b) => a.amount.compareTo(b.amount));
      break;
  }
  return filtered;
});
