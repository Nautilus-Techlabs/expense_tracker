import 'package:expense_tracker/features/circle/models/circle_details_screen_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/add_circle_expense_bottom_sheet.dart';

class AddCircleExpenseFormState {
  final int? selectedAccountId;
  final int? selectedCategoryId;
  final int paidByUserId;
  final SplitType splitType;
  final Set<int> includedMemberIds;
  final bool isSubmitting;

  const AddCircleExpenseFormState({
    this.selectedAccountId,
    this.selectedCategoryId,
    required this.paidByUserId,
    this.splitType = SplitType.equal,
    this.includedMemberIds = const {},
    this.isSubmitting = false,
  });

  AddCircleExpenseFormState copyWith({
    int? selectedAccountId,
    int? selectedCategoryId,
    int? paidByUserId,
    SplitType? splitType,
    Set<int>? includedMemberIds,
    bool? isSubmitting,
  }) {
    return AddCircleExpenseFormState(
      selectedAccountId: selectedAccountId ?? this.selectedAccountId,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      paidByUserId: paidByUserId ?? this.paidByUserId,
      splitType: splitType ?? this.splitType,
      includedMemberIds: includedMemberIds ?? this.includedMemberIds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class AddCircleExpenseFormNotifier extends Notifier<AddCircleExpenseFormState> {
  final List<Member> members;
  AddCircleExpenseFormNotifier(this.members);

  @override
  AddCircleExpenseFormState build() {
    return AddCircleExpenseFormState(
      paidByUserId: members.isNotEmpty ? members.first.userId : 0,
      includedMemberIds: members.map((m) => m.userId).toSet(),
    );
  }

  void updateAccountId(int? id) {
    state = state.copyWith(selectedAccountId: id);
  }

  void updateCategoryId(int? id) {
    state = state.copyWith(selectedCategoryId: id);
  }

  void updatePaidByUserId(int id) {
    state = state.copyWith(paidByUserId: id);
  }

  void updateSplitType(SplitType type) {
    state = state.copyWith(splitType: type);
  }

  void toggleMember(int userId) {
    final updated = Set<int>.from(state.includedMemberIds);
    if (updated.contains(userId)) {
      updated.remove(userId);
    } else {
      updated.add(userId);
    }
    state = state.copyWith(includedMemberIds: updated);
  }

  void setAllMembers(List<Member> members, bool selectAll) {
    if (selectAll) {
      state = state.copyWith(includedMemberIds: members.map((m) => m.userId).toSet());
    } else {
      state = state.copyWith(includedMemberIds: {});
    }
  }

  void setSubmitting(bool val) {
    state = state.copyWith(isSubmitting: val);
  }
}

final addCircleExpenseFormStateProvider =
    NotifierProvider.family<AddCircleExpenseFormNotifier, AddCircleExpenseFormState, List<Member>>(
  AddCircleExpenseFormNotifier.new,
);
