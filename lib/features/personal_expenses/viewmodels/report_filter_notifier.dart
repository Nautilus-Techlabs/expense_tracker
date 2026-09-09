import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportFilterState {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? earliestTxnDate;
  final bool isLoadingEarliestDate;

  const ReportFilterState({
    required this.startDate,
    required this.endDate,
    this.earliestTxnDate,
    this.isLoadingEarliestDate = true,
  });

  ReportFilterState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    DateTime? earliestTxnDate,
    bool clearEarliestDate = false,
    bool? isLoadingEarliestDate,
  }) {
    return ReportFilterState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      earliestTxnDate:
          clearEarliestDate ? null : (earliestTxnDate ?? this.earliestTxnDate),
      isLoadingEarliestDate:
          isLoadingEarliestDate ?? this.isLoadingEarliestDate,
    );
  }
}

final reportFilterProvider =
    NotifierProvider.autoDispose<ReportFilterNotifier, ReportFilterState>(
      () => ReportFilterNotifier(),
    );

class ReportFilterNotifier extends Notifier<ReportFilterState> {
  @override
  ReportFilterState build() {
    final now = DateTime.now();
    return ReportFilterState(
      startDate: DateTime(now.year, now.month, 1),
      endDate: DateTime(now.year, now.month + 1, 0),
    );
  }

  void setEarliestDate(DateTime? date) {
    state = state.copyWith(
      earliestTxnDate: date,
      clearEarliestDate: date == null,
      isLoadingEarliestDate: false,
    );
  }

  void previousMonth() {
    final currentStart = state.startDate;
    state = state.copyWith(
      startDate: DateTime(currentStart.year, currentStart.month - 1, 1),
      endDate: DateTime(currentStart.year, currentStart.month, 0),
    );
  }

  void nextMonth() {
    final currentStart = state.startDate;
    state = state.copyWith(
      startDate: DateTime(currentStart.year, currentStart.month + 1, 1),
      endDate: DateTime(currentStart.year, currentStart.month + 2, 0),
    );
  }
}
