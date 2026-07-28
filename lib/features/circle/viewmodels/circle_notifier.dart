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

  Future<void> createCircle({
    required String name,
    String? description,
    CircleType type = CircleType.ongoing,
    double? budget,
    bool splitEnabled = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref
        .read(supabaseHelperProvider)
        .createCircle(
          name: name,
          description: description,
          type: type,
          budget: budget,
          splitEnabled: splitEnabled,
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
    CircleMemberRole role = CircleMemberRole.member,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref
        .read(supabaseHelperProvider)
        .addCircleMember(
          circleId: circleId,
          targetUserId: targetUserId,
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

  Future<void> transferCircleOwnership({required int circleId}) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref
        .read(supabaseHelperProvider)
        .transferCircleOwnership(circleId: circleId);
    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> removeCircleMember({
    required int circleId,
    required int targetUserId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref
        .read(supabaseHelperProvider)
        .removeCircleMember(circleId: circleId, targetUserId: targetUserId);
    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> leaveCircle({required int circleId}) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref
        .read(supabaseHelperProvider)
        .leaveCircle(circleId: circleId);
    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> deleteCircle({required int circleId}) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref
        .read(supabaseHelperProvider)
        .deleteCircle(circleId: circleId);
    result.fold(
      (failure) =>
          state = state.copyWith(error: failure.message, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }
}

final circleProvider = NotifierProvider<CircleNotifier, CircleState>(
  CircleNotifier.new,
);
