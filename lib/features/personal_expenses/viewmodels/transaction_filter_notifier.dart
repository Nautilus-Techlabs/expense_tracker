import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionFilterState {
  final String searchQuery;
  final int? selectedCategoryId;
  final DateTime? selectedMonthDate;
  final DateTime? selectedSpecificDate;
  final bool isSearchVisible;

  const TransactionFilterState({
    this.searchQuery = '',
    this.selectedCategoryId,
    this.selectedMonthDate,
    this.selectedSpecificDate,
    this.isSearchVisible = false,
  });

  TransactionFilterState copyWith({
    String? searchQuery,
    int? Function()? selectedCategoryId,
    DateTime? Function()? selectedMonthDate,
    DateTime? Function()? selectedSpecificDate,
    bool? isSearchVisible,
  }) {
    return TransactionFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId != null
          ? selectedCategoryId()
          : this.selectedCategoryId,
      selectedMonthDate: selectedMonthDate != null
          ? selectedMonthDate()
          : this.selectedMonthDate,
      selectedSpecificDate: selectedSpecificDate != null
          ? selectedSpecificDate()
          : this.selectedSpecificDate,
      isSearchVisible: isSearchVisible ?? this.isSearchVisible,
    );
  }
}

final transactionFilterProvider =
    NotifierProvider.autoDispose<TransactionFilterNotifier, TransactionFilterState>(
  () => TransactionFilterNotifier(),
);

class TransactionFilterNotifier extends Notifier<TransactionFilterState> {
  @override
  TransactionFilterState build() {
    return const TransactionFilterState();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleSearchVisible() {
    state = state.copyWith(
      isSearchVisible: !state.isSearchVisible,
      searchQuery: state.isSearchVisible ? '' : null, // clear search when hiding
    );
  }

  void setFilters({int? categoryId, DateTime? specificDate}) {
    state = state.copyWith(
      selectedCategoryId: () => categoryId,
      selectedSpecificDate: () => specificDate,
    );
  }

  void clearFilters() {
    state = state.copyWith(
      selectedCategoryId: () => null,
      selectedSpecificDate: () => null,
    );
  }

  void setMonthDate(DateTime monthDate) {
    state = state.copyWith(selectedMonthDate: () => monthDate);
  }
}
