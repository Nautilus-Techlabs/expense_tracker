import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/data/repositories/supabase_provider.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:expense_tracker/features/circle/models/circle_model.dart';
import 'package:expense_tracker/features/circle/models/circle_data.dart';
import 'package:expense_tracker/features/circle/viewmodels/circle_state.dart';

class CircleNotifier extends Notifier<CircleState> {
  @override
  CircleState build() {
    // Return mock data initially
    return CircleState(
      circles: [
        CircleData(
          name: 'Goa Trip',
          type: CircleType.oneTime,
          members: [
            CircleMember(initials: 'RK', color: AppColors.primary),
            CircleMember(initials: 'AM', color: AppColors.expense),
            const CircleMember(initials: 'PR', color: Color(0xFF7C3AED)),
          ],
          totalAmount: 3600,
          pending: 1200,
          lastActivity: '',
          settlementProgress: 0.5,
        ),
        CircleData(
          name: 'Flat Expenses',
          type: CircleType.ongoing,
          members: [
            CircleMember(initials: 'RK', color: AppColors.primary),
            CircleMember(initials: 'AM', color: AppColors.expense),
            const CircleMember(initials: 'PR', color: Color(0xFF7C3AED)),
            const CircleMember(initials: 'SJ', color: Color(0xFFB45309)),
          ],
          totalAmount: 8400,
          yourShare: 2100,
          lastActivity: '2 days ago',
          settlementProgress: 0,
        ),
        CircleData(
          name: 'Family',
          type: CircleType.ongoing,
          members: [
            CircleMember(initials: 'RK', color: AppColors.primary),
            CircleMember(initials: 'AM', color: AppColors.expense),
            const CircleMember(initials: 'PR', color: Color(0xFF7C3AED)),
            const CircleMember(initials: 'SJ', color: Color(0xFFB45309)),
            const CircleMember(initials: 'KL', color: Color(0xFF0891B2)),
          ],
          totalAmount: 12000,
          youOwe: 800,
          lastActivity: 'Today',
          settlementProgress: 0,
        ),
      ],
    );
  }

  // Future methods for adding/editing circles would go here
  void refreshCircles() {
    state = state.copyWith(isLoading: true);
    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(isLoading: false);
    });
  }

  // --- RPC Calls ---
  
  Future<void> createCircle({
    required String name,
    String? description,
    String type = 'ongoing',
    double? budget,
    bool splitEnabled = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref.read(supabaseHelperProvider).createCircle(
      name: name,
      description: description,
      type: type,
      budget: budget,
      splitEnabled: splitEnabled,
    );
    result.fold(
      (failure) => state = state.copyWith(error: failure.message, isLoading: false),
      (id) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> addCircleMember({
    required int circleId,
    required int targetUserId,
    String role = 'member',
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref.read(supabaseHelperProvider).addCircleMember(
      circleId: circleId,
      targetUserId: targetUserId,
      role: role,
    );
    result.fold(
      (failure) => state = state.copyWith(error: failure.message, isLoading: false),
      (id) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> changeMemberRole({
    required int circleId,
    required int targetUserId,
    required String newRole,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref.read(supabaseHelperProvider).changeMemberRole(
      circleId: circleId,
      targetUserId: targetUserId,
      newRole: newRole,
    );
    result.fold(
      (failure) => state = state.copyWith(error: failure.message, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> transferCircleOwnership({
    required int circleId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref.read(supabaseHelperProvider).transferCircleOwnership(
      circleId: circleId,
    );
    result.fold(
      (failure) => state = state.copyWith(error: failure.message, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> removeCircleMember({
    required int circleId,
    required int targetUserId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref.read(supabaseHelperProvider).removeCircleMember(
      circleId: circleId,
      targetUserId: targetUserId,
    );
    result.fold(
      (failure) => state = state.copyWith(error: failure.message, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> leaveCircle({
    required int circleId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref.read(supabaseHelperProvider).leaveCircle(
      circleId: circleId,
    );
    result.fold(
      (failure) => state = state.copyWith(error: failure.message, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> deleteCircle({
    required int circleId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await ref.read(supabaseHelperProvider).deleteCircle(
      circleId: circleId,
    );
    result.fold(
      (failure) => state = state.copyWith(error: failure.message, isLoading: false),
      (_) => state = state.copyWith(isLoading: false),
    );
  }
}

final circleProvider = NotifierProvider<CircleNotifier, CircleState>(
  CircleNotifier.new,
);
