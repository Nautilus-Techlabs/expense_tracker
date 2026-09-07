import 'package:expense_tracker/features/circle/models/circle_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCircleFormState {
  final CircleType selectedType;
  final bool includeSettlements;
  final int? selectedAccountId;
  final bool nameError;

  const CreateCircleFormState({
    this.selectedType = CircleType.ongoing,
    this.includeSettlements = true,
    this.selectedAccountId,
    this.nameError = false,
  });

  CreateCircleFormState copyWith({
    CircleType? selectedType,
    bool? includeSettlements,
    int? selectedAccountId,
    bool? nameError,
  }) {
    return CreateCircleFormState(
      selectedType: selectedType ?? this.selectedType,
      includeSettlements: includeSettlements ?? this.includeSettlements,
      selectedAccountId: selectedAccountId ?? this.selectedAccountId,
      nameError: nameError ?? this.nameError,
    );
  }
}

class CreateCircleFormNotifier extends Notifier<CreateCircleFormState> {
  @override
  CreateCircleFormState build() {
    return const CreateCircleFormState();
  }

  void updateSelectedType(CircleType type) {
    state = state.copyWith(selectedType: type);
  }

  void updateIncludeSettlements(bool include) {
    state = state.copyWith(
      includeSettlements: include,
      selectedAccountId: include ? state.selectedAccountId : null,
    );
  }

  void updateSelectedAccountId(int? id) {
    state = state.copyWith(selectedAccountId: id);
  }

  void setNameError(bool hasError) {
    state = state.copyWith(nameError: hasError);
  }
}

final createCircleFormStateProvider =
    NotifierProvider.autoDispose<
      CreateCircleFormNotifier,
      CreateCircleFormState
    >(CreateCircleFormNotifier.new);
