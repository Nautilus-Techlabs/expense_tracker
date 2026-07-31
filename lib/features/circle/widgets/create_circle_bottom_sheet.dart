import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:expense_tracker/core/theme/app_colors_extension.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:expense_tracker/features/circle/models/circle_model.dart';
import 'package:expense_tracker/features/circle/viewmodels/circle_notifier.dart';
import 'package:expense_tracker/features/circle/viewmodels/create_circle_form_notifier.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/account_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

void showCreateCircleBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const CreateCircleBottomSheet(),
  );
}

class CreateCircleBottomSheet extends ConsumerStatefulWidget {
  const CreateCircleBottomSheet({super.key});

  @override
  ConsumerState<CreateCircleBottomSheet> createState() =>
      _CreateCircleBottomSheetState();
}

class _CreateCircleBottomSheetState
    extends ConsumerState<CreateCircleBottomSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final formNotifier = ref.read(createCircleFormStateProvider.notifier);
    final formState = ref.read(createCircleFormStateProvider);

    if (name.isEmpty) {
      formNotifier.setNameError(true);
      return;
    }
    formNotifier.setNameError(false);

    if (formState.includeSettlements && formState.selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a settlement account'),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }

    final user = ref.read(authProvider).user;
    if (user == null) return;

    final budget = double.tryParse(_budgetController.text.trim());
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();

    final success = await ref
        .read(circleProvider.notifier)
        .createCircle(
          name: name,
          includeSettlementsInPersonalLedger: formState.includeSettlements,
          settlementAccountId: formState.includeSettlements ? formState.selectedAccountId : null,
          description: description,
          type: formState.selectedType,
          budget: budget,
          userId: user.id,
        );

    if (mounted) {
      if (success) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Circle created successfully!'),
            backgroundColor: AppColors.income,
          ),
        );
      } else {
        final error =
            ref.read(circleProvider).error ?? 'Failed to create circle';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.expense),
        );
      }
    }
  }

  Widget _buildTypeSegment(String label, CircleType value, bool isDark, CreateCircleFormState formState, CreateCircleFormNotifier formNotifier) {
    final isSelected = formState.selectedType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => formNotifier.updateSelectedType(value),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF333333) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: isSelected && !isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.appTexts.bodyMedium.copyWith(
              color: isSelected
                  ? context.colors.textPrimary
                  : context.colors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accountsState = ref.watch(accountProvider);
    final accounts = accountsState.accounts;
    final formState = ref.watch(createCircleFormStateProvider);
    final formNotifier = ref.read(createCircleFormStateProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Material(
          color: context.colors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grabber
                  Center(
                    child: Container(
                      width: 48.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: context.colors.border,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  UIHelpers.verticalSpace(24),

                  // Header
                  Text(
                    'Create Circle',
                    style: context.appTexts.displayMedium.copyWith(
                      color: context.colors.textPrimary,
                      fontSize: 24.sp,
                    ),
                  ),
                  UIHelpers.verticalSpace(20),

                  // Circle Type Segmented Toggle
                  Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        _buildTypeSegment('Ongoing', CircleType.ongoing, isDark, formState, formNotifier),
                        _buildTypeSegment('One-Time', CircleType.oneTime, isDark, formState, formNotifier),
                      ],
                    ),
                  ),
                  UIHelpers.verticalSpace(20),

                  // Name Input
                  Row(
                    children: [
                      Text(
                        'Circle Name',
                        style: context.appTexts.bodySmall.copyWith(
                          color: formState.nameError
                              ? AppColors.expense
                              : context.colors.textSecondary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                      if (formState.nameError) ...[
                        UIHelpers.horizontalSpace(8),
                        Icon(
                          Icons.error_outline_rounded,
                          size: 14.sp,
                          color: AppColors.expense,
                        ),
                      ],
                    ],
                  ),
                  UIHelpers.verticalSpace(8),
                  TextField(
                    controller: _nameController,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. Goa Trip 2026',
                      hintStyle: context.appTexts.bodyMedium.copyWith(
                        color: context.colors.textSecondary.withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: context.colors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: formState.nameError
                              ? AppColors.expense
                              : context.colors.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: formState.nameError
                              ? AppColors.expense
                              : context.colors.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: formState.nameError ? AppColors.expense : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  UIHelpers.verticalSpace(16),

                  // Description Input
                  Text(
                    'Description (Optional)',
                    style: context.appTexts.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  UIHelpers.verticalSpace(8),
                  TextField(
                    controller: _descriptionController,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. Shared expenses for summer trip',
                      hintStyle: context.appTexts.bodyMedium.copyWith(
                        color: context.colors.textSecondary.withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: context.colors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  UIHelpers.verticalSpace(16),

                  // Budget Input
                  Text(
                    'Budget (Optional)',
                    style: context.appTexts.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  UIHelpers.verticalSpace(8),
                  TextField(
                    controller: _budgetController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. 10000',
                      hintStyle: context.appTexts.bodyMedium.copyWith(
                        color: context.colors.textSecondary.withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: context.colors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  UIHelpers.verticalSpace(20),

                  // Include settlements switch
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Include settlements in personal ledger',
                      style: context.appTexts.bodyMedium.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Reflect circle settlements in your personal account balance',
                      style: context.appTexts.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    value: formState.includeSettlements,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      formNotifier.updateIncludeSettlements(val);
                    },
                  ),
                  UIHelpers.verticalSpace(12),

                  // Settlement Account dropdown (conditional)
                  if (formState.includeSettlements) ...[
                    Text(
                      'Settlement Account',
                      style: context.appTexts.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    UIHelpers.verticalSpace(8),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: context.colors.card,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: formState.selectedAccountId,
                          isExpanded: true,
                          dropdownColor: context.colors.card,
                          hint: Text(
                            'Select account',
                            style: context.appTexts.bodyMedium.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                          style: context.appTexts.bodyMedium.copyWith(
                            color: context.colors.textPrimary,
                          ),
                          items: accounts.map((acc) {
                            return DropdownMenuItem<int>(
                              value: acc.id,
                              child: Text(acc.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            formNotifier.updateSelectedAccountId(val);
                          },
                        ),
                      ),
                    ),
                    UIHelpers.verticalSpace(24),
                  ],

                  // Create Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ref.watch(circleProvider).isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        elevation: 0,
                      ),
                      child: ref.watch(circleProvider).isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Create Circle',
                              style: context.appTexts.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
