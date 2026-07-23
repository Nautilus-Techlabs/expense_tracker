import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/theme/app_colors_extension.dart';

class CircleSummaryCard extends StatelessWidget {
  final bool isDark;

  const CircleSummaryCard({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: context.colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUMMARY',
            style: context.appTexts.bodySmall.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          UIHelpers.verticalSpace(8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total spent:',
                style: context.appTexts.displayMedium.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
                  fontSize: 24.sp,
                ),
              ),
              UIHelpers.horizontalSpace(8),
              Text(
                '₹7,200',
                style: context.appTexts.displayMedium.copyWith(
                  color: isDark ? Colors.white : AppColors.primary,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          UIHelpers.verticalSpace(20),
          // Progress bar
          Stack(
            children: [
              Container(
                height: 8.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E0),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              Container(
                height: 8.h,
                width: 150.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.income : AppColors.primary,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
          UIHelpers.verticalSpace(12),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.income : AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  UIHelpers.horizontalSpace(6),
                  Text(
                    '₹3,600 settled',
                    style: context.appTexts.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFB0B0B0),
                      shape: BoxShape.circle,
                    ),
                  ),
                  UIHelpers.horizontalSpace(6),
                  Text(
                    '₹3,600 pending',
                    style: context.appTexts.bodySmall.copyWith(
                      color: isDark ? AppColors.expense : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
