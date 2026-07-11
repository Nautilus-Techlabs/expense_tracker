import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/remote/supabase/supabase_helper.dart';
import '../../auth/viewmodels/auth_notifier.dart';
import 'report_state.dart';

final reportProvider = NotifierProvider<ReportNotifier, ReportState>(() {
  return ReportNotifier();
});

class ReportNotifier extends Notifier<ReportState> {
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
}
