import 'package:expense_tracker/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/circle_screen_model.dart';

class CircleSummaryBanner extends StatelessWidget {
  final Totals? totals;
  final bool isDark;

  const CircleSummaryBanner({super.key, this.totals, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final owe = totals?.totalYouOwe ?? 0;
    final owed = totals?.totalOwedToYou ?? 0;

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
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1.w, height: 28.h, color: context.colors.border),
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
}
