import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportFilterState {
  final DateTime startDate;
  final DateTime endDate;

  const ReportFilterState({required this.startDate, required this.endDate});
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

  void previousMonth() {
    final currentStart = state.startDate;
    state = ReportFilterState(
      startDate: DateTime(currentStart.year, currentStart.month - 1, 1),
      endDate: DateTime(currentStart.year, currentStart.month, 0),
    );
  }

  void nextMonth() {
    final currentStart = state.startDate;
    state = ReportFilterState(
      startDate: DateTime(currentStart.year, currentStart.month + 1, 1),
      endDate: DateTime(currentStart.year, currentStart.month + 2, 0),
    );
  }
}
