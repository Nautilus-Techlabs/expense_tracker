import 'package:expense_tracker/data/repositories/supabase_provider.dart';
import 'package:expense_tracker/features/circle/viewmodels/circle_details_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CircleDetailsNotifier extends Notifier<CircleDetailsState> {
  final int circleId;
  CircleDetailsNotifier(this.circleId);

  @override
  CircleDetailsState build() {
    return const CircleDetailsState();
  }

  Future<void> fetchCircleDetails(int userId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref
        .read(supabaseHelperProvider)
        .getCircleDetailsScreenData(circleId: circleId, userId: userId);

    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (data) => state = state.copyWith(screenData: data, isLoading: false),
    );
  }
}

final circleDetailsProvider =
    NotifierProvider.family<CircleDetailsNotifier, CircleDetailsState, int>(
      CircleDetailsNotifier.new,
    );
