import '../models/budget_model.dart';

class BudgetState {
  final bool isLoading;
  final UserMonthlyBudget? budget;
  final String? errorMessage;

  BudgetState({this.isLoading = false, this.budget, this.errorMessage});

  BudgetState copyWith({
    bool? isLoading,
    UserMonthlyBudget? Function()? budget,
    String? Function()? errorMessage,
  }) {
    return BudgetState(
      isLoading: isLoading ?? this.isLoading,
      budget: budget != null ? budget() : this.budget,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
