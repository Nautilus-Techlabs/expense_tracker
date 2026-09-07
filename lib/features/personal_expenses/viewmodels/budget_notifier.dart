import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/viewmodels/auth_notifier.dart';
import '../models/budget_model.dart';
import 'budget_state.dart';
import 'package:expense_tracker/data/repositories/supabase_provider.dart';

final budgetProvider = NotifierProvider<BudgetNotifier, BudgetState>(() {
  return BudgetNotifier();
});

class BudgetNotifier extends Notifier<BudgetState> {
  @override
  BudgetState build() {
    // Attempt to fetch budget if user is already available
    final user = ref.watch(authProvider).user;
    if (user != null) {
      Future.microtask(() => fetchBudget());
    }
    return BudgetState();
  }

  Future<void> fetchBudget() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    state = state.copyWith(isLoading: true);
    final result = await ref
        .read(supabaseHelperProvider)
        .fetchMonthlyBudget(userId: user.id);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: () => failure.message,
      ),
      (budget) =>
          state = state.copyWith(isLoading: false, budget: () => budget),
    );
  }

  Future<bool> createOrUpdateBudget({
    required double amount,
    required DateTime month,
  }) async {
    final user = ref.read(authProvider).user;
    if (user == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    // Normalize the month to the first of the month
    final normalizedMonth = DateTime(month.year, month.month, 1);

    final existingBudget = state.budget;

    late final Future<dynamic> resultFuture;
    if (existingBudget != null) {
      resultFuture = ref
          .read(supabaseHelperProvider)
          .updateMonthlyBudget(
            userId: user.id,
            amount: amount,
            month: normalizedMonth,
          );
    } else {
      resultFuture = ref
          .read(supabaseHelperProvider)
          .createMonthlyBudget(
            userId: user.id,
            amount: amount,
            month: normalizedMonth,
          );
    }

    final result = await resultFuture;

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      (budget) {
        state = state.copyWith(
          isLoading: false,
          budget: () => budget as UserMonthlyBudget,
        );
        return true;
      },
    );
  }
}
