import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../models/category_model.dart';

class CategoryListItem extends StatelessWidget {
  final CategoryModel category;

  const CategoryListItem({super.key, required this.category});

  IconData _getIcon() {
    return Icons.category_rounded;
  }

  Color _getColor() {
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.colors.border,
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
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                UIHelpers.verticalSpace(4),
                Text(
                  category.type.name.toUpperCase(),
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
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
