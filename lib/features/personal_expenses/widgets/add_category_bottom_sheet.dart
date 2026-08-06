import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../models/category_model.dart';
import '../viewmodels/category_notifier.dart';

void showAddCategorySheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddCategoryBottomSheet(),
  );
}

class AddCategoryBottomSheet extends ConsumerStatefulWidget {
  const AddCategoryBottomSheet({super.key});

  @override
  ConsumerState<AddCategoryBottomSheet> createState() =>
      _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState
    extends ConsumerState<AddCategoryBottomSheet> {
  final _nameController = TextEditingController();
  CategoryType _selectedType = CategoryType.expense;
  bool _nameError = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    setState(() {
      _nameError = false;
    });

    final success = await ref
        .read(categoryProvider.notifier)
        .addCategory(
          name: name,
          type: _selectedType,
          icon: 'category_rounded',
          color: '#4CAF50',
        );

    if (mounted) {
      if (success) {
        context.pop();
      } else {
        final error =
            ref.read(categoryProvider).errorMessage ?? 'Failed to add category';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.expense),
        );
      }
    }
  }

  Widget _buildSegment(String label, CategoryType value, bool isDark) {
    final isSelected = _selectedType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = value),
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

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
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
              'New Category',
              style: context.appTexts.displayMedium.copyWith(
                color: context.colors.textPrimary,
                fontSize: 24.sp,
              ),
            ),
            UIHelpers.verticalSpace(24),

            // Type Segment
            Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : const Color(0xFFEBEBEB),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Row(
                children: [
                  _buildSegment('Expense', CategoryType.expense, isDark),
                  _buildSegment('Income', CategoryType.income, isDark),
                  _buildSegment('Both', CategoryType.both, isDark),
                ],
              ),
            ),
            UIHelpers.verticalSpace(24),

            // Name Input
            Row(
              children: [
                Text(
                  'Name',
                  style: context.appTexts.bodySmall.copyWith(
                    color: _nameError
                        ? AppColors.expense
                        : context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                if (_nameError) ...[
                  UIHelpers.horizontalSpace(8),
                  Icon(
                    Icons.error_outline_rounded,
                    size: 14.sp,
                    color: AppColors.expense,
                  ),
                ],
              ],
            ),
            UIHelpers.verticalSpace(12),
            TextField(
              controller: _nameController,
              style: context.appTexts.bodyMedium.copyWith(
                color: context.colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Groceries',
                hintStyle: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textSecondary.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: context.colors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: _nameError
                        ? AppColors.expense
                        : context.colors.border,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: _nameError
                        ? AppColors.expense
                        : context.colors.border,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: _nameError ? AppColors.expense : AppColors.primary,
                  ),
                ),
              ),
            ),
            UIHelpers.verticalSpace(40),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ref.watch(categoryProvider).isLoading
                    ? null
                    : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  elevation: 0,
                ),
                child: ref.watch(categoryProvider).isLoading
                    ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Save Category',
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
    );
  }
}
