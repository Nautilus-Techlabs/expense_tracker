import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../viewmodels/category_notifier.dart';

class TransactionFilterSheet extends ConsumerStatefulWidget {
  final int? initialCategoryId;
  final DateTime? initialSpecificDate;
  final Function(int? categoryId, DateTime? specificDate) onApply;

  const TransactionFilterSheet({
    super.key,
    this.initialCategoryId,
    this.initialSpecificDate,
    required this.onApply,
  });

  @override
  ConsumerState<TransactionFilterSheet> createState() =>
      _TransactionFilterSheetState();
}

class _TransactionFilterSheetState
    extends ConsumerState<TransactionFilterSheet> {
  int? _selectedCategoryId;
  DateTime? _selectedSpecificDate;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
    _selectedSpecificDate = widget.initialSpecificDate;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedSpecificDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedSpecificDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
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

          Text(
            'Filters',
            style: context.appTexts.displayMedium.copyWith(
              color: context.colors.textPrimary,
              fontSize: 24.sp,
            ),
          ),
          UIHelpers.verticalSpace(24),

          // Date Filter
          Text(
            'Specific Date',
            style: context.appTexts.bodySmall.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          UIHelpers.verticalSpace(12),
          InkWell(
            onTap: _pickDate,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.border),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedSpecificDate != null
                        ? DateFormat(
                            'MMM dd, yyyy',
                          ).format(_selectedSpecificDate!)
                        : 'Select Date',
                    style: context.appTexts.bodyMedium.copyWith(
                      color: _selectedSpecificDate != null
                          ? context.colors.textPrimary
                          : context.colors.textSecondary,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 20.sp,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          UIHelpers.verticalSpace(24),

          // Category Filter
          Text(
            'Category',
            style: context.appTexts.bodySmall.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          UIHelpers.verticalSpace(12),
          Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            children: categoryState.categories.map((cat) {
              final isSelected = _selectedCategoryId == cat.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryId = isSelected ? null : cat.id;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : context.colors.border,
                    ),
                  ),
                  child: Text(
                    cat.name,
                    style: context.appTexts.bodySmall.copyWith(
                      color: isSelected
                          ? Colors.white
                          : context.colors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          UIHelpers.verticalSpace(40),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategoryId = null;
                      _selectedSpecificDate = null;
                    });
                    widget.onApply(null, null);
                    context.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    side: BorderSide(color: context.colors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                  ),
                  child: Text(
                    'Clear All',
                    style: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              UIHelpers.horizontalSpace(16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_selectedCategoryId, _selectedSpecificDate);
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Apply',
                    style: context.appTexts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
