import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/theme/app_colors_extension.dart';

class CircleTransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;

  const CircleTransactionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.expense.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.expense, size: 20.sp),
          ),
          UIHelpers.horizontalSpace(16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.appTexts.bodyMedium.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                UIHelpers.verticalSpace(4),
                Text(
                  subtitle,
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            amount,
            style: context.appTexts.displayMedium.copyWith(
              color: AppColors.expense,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    );
  }
}
