import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/ui_helpers.dart';

import '../models/circle_screen_model.dart';

class CircleSummaryBanner extends StatelessWidget {
  final Totals? totals;
  final bool isDark;

  const CircleSummaryBanner({
    super.key,
    this.totals,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final owe = totals?.totalYouOwe ?? 0;
    final owed = totals?.totalOwedToYou ?? 0;

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
                    'You are owed ₹$owed',
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
                  'You owe ₹$owe',
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
                  'YOU ARE OWED ₹$owed',
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
                  'YOU OWE ₹$owe',
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
