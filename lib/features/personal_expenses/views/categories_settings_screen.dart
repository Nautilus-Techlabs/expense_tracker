import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/ui_helpers.dart';
import '../viewmodels/category_notifier.dart';
import '../models/category_model.dart';

class CategoriesSettingsScreen extends ConsumerWidget {
  const CategoriesSettingsScreen({super.key});

  void _showAddCategorySheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddCategoryBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(categoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            size: 20.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Categories',
          style: context.appTexts.displayMedium.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: categoryState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryState.categories.isEmpty
              ? Center(
                  child: Text(
                    'No categories found.',
                    textAlign: TextAlign.center,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  itemCount: categoryState.categories.length,
                  separatorBuilder: (context, index) => UIHelpers.verticalSpace(12),
                  itemBuilder: (context, index) {
                    final category = categoryState.categories[index];
                    return _CategoryListItem(category: category, isDark: isDark);
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCategorySheet(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Category',
          style: context.appTexts.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _CategoryListItem extends StatelessWidget {
  final CategoryModel category;
  final bool isDark;

  const _CategoryListItem({required this.category, required this.isDark});

  IconData _getIcon() {
    // Basic mapping or default
    return Icons.category_rounded;
  }

  Color _getColor() {
    // Parse hex or return default
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: _getColor().withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIcon(), color: _getColor(), size: 20.sp),
          ),
          UIHelpers.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: context.appTexts.bodyMedium.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                UIHelpers.verticalSpace(4),
                Text(
                  category.type.name.toUpperCase(),
                  style: context.appTexts.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 10.sp,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          if (!category.isActive)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.expense.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Inactive',
                style: context.appTexts.bodySmall.copyWith(
                  color: AppColors.expense,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddCategoryBottomSheet extends ConsumerStatefulWidget {
  const _AddCategoryBottomSheet();

  @override
  ConsumerState<_AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends ConsumerState<_AddCategoryBottomSheet> {
  final _nameController = TextEditingController();
  String _selectedType = 'expense';
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

    final success = await ref.read(categoryProvider.notifier).addCategory(
          name: name,
          type: _selectedType,
          icon: 'category_rounded', // Default icon as requested
          color: '#4CAF50', // Default green color for simplicity
        );

    if (mounted) {
      if (success) {
        context.pop();
      } else {
        final error = ref.read(categoryProvider).errorMessage ?? 'Failed to add category';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.expense),
        );
      }
    }
  }

  Widget _buildSegment(String label, String value, bool isDark) {
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
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.appTexts.bodyMedium.copyWith(
              color: isSelected
                  ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
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
          color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
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
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            UIHelpers.verticalSpace(24),

            // Header
            Text(
              'New Category',
              style: context.appTexts.displayMedium.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
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
                  _buildSegment('Expense', 'expense', isDark),
                  _buildSegment('Income', 'income', isDark),
                  _buildSegment('Both', 'both', isDark),
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
                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                if (_nameError) ...[
                  UIHelpers.horizontalSpace(8),
                  Icon(Icons.error_outline_rounded, size: 14.sp, color: AppColors.expense),
                ],
              ],
            ),
            UIHelpers.verticalSpace(12),
            TextField(
              controller: _nameController,
              style: context.appTexts.bodyMedium.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Groceries',
                hintStyle: context.appTexts.bodyMedium.copyWith(
                  color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
                      .withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: _nameError
                        ? AppColors.expense
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: _nameError
                        ? AppColors.expense
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
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
                onPressed: ref.watch(categoryProvider).isLoading ? null : _submit,
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
