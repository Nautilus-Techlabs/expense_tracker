import 'package:expense_tracker/data/repositories/supabase_provider.dart';
import 'package:expense_tracker/features/circle/models/circle_model.dart';
import 'package:expense_tracker/features/circle/viewmodels/circle_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CircleNotifier extends Notifier<CircleState> {
  @override
  CircleState build() {
    return const CircleState();
  }

  Future<void> fetchCirclesScreenData(int userId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref
        .read(supabaseHelperProvider)
        .getCirclesScreenData(userId: userId);
    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (data) => state = state.copyWith(screenData: data, isLoading: false),
    );
  }

  // --- RPC Calls ---

  Future<bool> createCircle({
    required String name,
    required bool includeSettlementsInPersonalLedger,
    int? settlementAccountId,
    String? description,
    CircleType type = CircleType.ongoing,
    double? budget,
    bool splitEnabled = false,
    required int userId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref
        .read(supabaseHelperProvider)
        .createCircle(
          name: name,
          userId: userId,
          includeSettlementsInPersonalLedger:
              includeSettlementsInPersonalLedger,
          settlementAccountId: settlementAccountId,
          description: description,
          type: type,
          budget: budget,
          splitEnabled: splitEnabled,
        );
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message, isLoading: false);
        return false;
      },
      (id) {
        state = state.copyWith(isLoading: false);
        fetchCirclesScreenData(userId);
        return true;
      },
    );
  }

  Future<void> joinCircle({
    required int circleId,
    required bool includeSettlementsInPersonalLedger,
    int? settlementAccountId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref
        .read(supabaseHelperProvider)
        .joinCircle(
          circleId: circleId,
          includeSettlementsInPersonalLedger:
              includeSettlementsInPersonalLedger,
          settlementAccountId: settlementAccountId,
        );
    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (id) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> addCircleMember({
    required int circleId,
    required int targetUserId,
    required bool includeSettlementsInPersonalLedger,
    int? settlementAccountId,
    CircleMemberRole role = CircleMemberRole.member,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref
        .read(supabaseHelperProvider)
        .addCircleMember(
          circleId: circleId,
          targetUserId: targetUserId,
          includeSettlementsInPersonalLedger:
              includeSettlementsInPersonalLedger,
          settlementAccountId: settlementAccountId,
          role: role,
        );
    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (id) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> changeMemberRole({
    required int circleId,
    required int targetUserId,
    required CircleMemberRole newRole,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref
        .read(supabaseHelperProvider)
        .changeMemberRole(
          circleId: circleId,
          targetUserId: targetUserId,
          newRole: newRole,
        );
    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  Future<String?> transferCircleOwnership({
    required int circleId,
    required int newOwnerUserId,
    required int currentUserId,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await ref
        .read(supabaseHelperProvider)
        .transferCircleOwnership(
          circleId: circleId,
          newOwnerUserId: newOwnerUserId,
        );
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false);
        return failure.message;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        fetchCirclesScreenData(currentUserId);
        return null;
      },
    );
  }

  Future<String?> removeCircleMember({
    required int circleId,
    required int targetUserId,
    required int currentUserId,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await ref
        .read(supabaseHelperProvider)
        .removeCircleMember(circleId: circleId, targetUserId: targetUserId);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false);
        return failure.message;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        fetchCirclesScreenData(currentUserId);
        return null;
      },
    );
  }

  Future<String?> leaveCircle({
    required int circleId,
    required int currentUserId,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await ref
        .read(supabaseHelperProvider)
        .leaveCircle(circleId: circleId);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false);
        return failure.message;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        fetchCirclesScreenData(currentUserId);
        return null;
      },
    );
  }

  Future<String?> deleteCircle({
    required int circleId,
    required int currentUserId,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await ref
        .read(supabaseHelperProvider)
        .deleteCircle(circleId: circleId);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false);
        return failure.message;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        fetchCirclesScreenData(currentUserId);
        return null;
      },
    );
  }
}

final circleProvider = NotifierProvider<CircleNotifier, CircleState>(
  CircleNotifier.new,
);
