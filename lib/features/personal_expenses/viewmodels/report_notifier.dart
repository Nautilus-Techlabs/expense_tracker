import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/remote/supabase/supabase_helper.dart';
import '../../auth/viewmodels/auth_notifier.dart';
import 'report_state.dart';

final reportProvider = NotifierProvider<ReportNotifier, ReportState>(() {
  return ReportNotifier();
});

class ReportNotifier extends Notifier<ReportState> {
  // Cache of last-used params so refresh() can replay the last fetch.
  Map<String, dynamic>? _lastReportParams;
  Map<String, dynamic>? _lastBreakdownParams;

  @override
  ReportState build() {
    return ReportState();
  }

  Future<void> fetchReports({
    required DateTime startDate,
    required DateTime endDate,
    String groupBy = 'month',
    bool fillGaps = true,
    int topCategories = 5,
    bool includeZeroAcc = true,
  }) async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    // Cache the params for later refresh
    _lastReportParams = {
      'startDate': startDate,
      'endDate': endDate,
      'groupBy': groupBy,
      'fillGaps': fillGaps,
      'topCategories': topCategories,
      'includeZeroAcc': includeZeroAcc,
    };

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await SupabaseHelper().fetchUserReports(
      userId: user.id,
      startDate: startDate,
      endDate: endDate,
      groupBy: groupBy,
      fillGaps: fillGaps,
      topCategories: topCategories,
      includeZeroAcc: includeZeroAcc,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: () => failure.message,
      ),
      (report) =>
          state = state.copyWith(isLoading: false, report: () => report),
    );
  }

  Future<void> fetchSpendingBreakdown({
    required DateTime startDate,
    required DateTime endDate,
    int topCategories = 5,
    bool groupByOthers = false,
  }) async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    // Cache the params for later refresh
    _lastBreakdownParams = {
      'startDate': startDate,
      'endDate': endDate,
      'topCategories': topCategories,
      'groupByOthers': groupByOthers,
    };

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await SupabaseHelper().getSpendingBreakdown(
      userId: user.id,
      startDate: startDate,
      endDate: endDate,
      topCategories: topCategories,
      groupByOthers: groupByOthers,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: () => failure.message,
      ),
      (breakdown) =>
          state = state.copyWith(isLoading: false, breakdown: () => breakdown),
    );
  }

  /// Re-fetches reports and spending breakdown using the last-used params.
  /// Called automatically after any transaction mutation.
  void refresh() {
    if (_lastReportParams != null) {
      fetchReports(
        startDate: _lastReportParams!['startDate'] as DateTime,
        endDate: _lastReportParams!['endDate'] as DateTime,
        groupBy: _lastReportParams!['groupBy'] as String,
        fillGaps: _lastReportParams!['fillGaps'] as bool,
        topCategories: _lastReportParams!['topCategories'] as int,
        includeZeroAcc: _lastReportParams!['includeZeroAcc'] as bool,
      );
    }
    if (_lastBreakdownParams != null) {
      fetchSpendingBreakdown(
        startDate: _lastBreakdownParams!['startDate'] as DateTime,
        endDate: _lastBreakdownParams!['endDate'] as DateTime,
        topCategories: _lastBreakdownParams!['topCategories'] as int,
        groupByOthers: _lastBreakdownParams!['groupByOthers'] as bool,
      );
    }
  }
}

