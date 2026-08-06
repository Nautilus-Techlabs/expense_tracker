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

  Future<String?> recordSettlement({
    required int paidByUserId,
    required int paidToUserId,
    required double amount,
    required int currentUserId,
    String? note,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await ref
        .read(supabaseHelperProvider)
        .recordSettlement(
          circleId: circleId,
          paidByUserId: paidByUserId,
          paidToUserId: paidToUserId,
          amount: amount,
          note: note,
        );
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false);
        return failure.message;
      },
      (_) {
        fetchCircleDetails(currentUserId);
        return null;
      },
    );
  }
}

final circleDetailsProvider =
    NotifierProvider.family<CircleDetailsNotifier, CircleDetailsState, int>(
      CircleDetailsNotifier.new,
    );
