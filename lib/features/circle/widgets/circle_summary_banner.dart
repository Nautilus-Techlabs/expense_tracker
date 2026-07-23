import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/theme/app_colors_extension.dart';

class CircleSummaryBanner extends StatelessWidget {
  final bool isDark;

  const CircleSummaryBanner({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (isDark) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You are owed ₹2,400',
                    style: context.appTexts.bodyMedium.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
            Container(width: 1.w, height: 28.h, color: AppColors.borderDark),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Text(
                  'You owe ₹800',
                  style: context.appTexts.bodyMedium.copyWith(
                    color: AppColors.expense,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Light mode pill
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : const Color(0xFFF0F0E9),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_downward_rounded,
                  size: 16.sp,
                  color: AppColors.income,
                ),
                UIHelpers.horizontalSpace(6),
                Text(
                  'YOU ARE OWED ₹2,400',
                  style: context.appTexts.bodySmall.copyWith(
                    color: AppColors.income,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            UIHelpers.verticalSpace(4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_upward_rounded,
                  size: 16.sp,
                  color: AppColors.expense,
                ),
                UIHelpers.horizontalSpace(6),
                Text(
                  'YOU OWE ₹800',
                  style: context.appTexts.bodySmall.copyWith(
                    color: AppColors.expense,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
