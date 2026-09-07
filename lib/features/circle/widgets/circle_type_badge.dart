import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';

class CircleTypeBadge extends StatelessWidget {
  final String label;
  final bool isDark;

  const CircleTypeBadge({super.key, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isOngoing = label == 'ONGOING';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isOngoing
            ? AppColors.income.withAlpha(isDark ? 60 : 30)
            : (isDark ? AppColors.cardDark : const Color(0xFFF0F0E9)),
        borderRadius: BorderRadius.circular(20.r),
        border: isOngoing ? null : Border.all(color: context.colors.border),
      ),
      child: Text(
        label,
        style: context.appTexts.bodySmall.copyWith(
          color: isOngoing ? AppColors.income : context.colors.textSecondary,
          fontWeight: FontWeight.w700,
          fontSize: 10.sp,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
