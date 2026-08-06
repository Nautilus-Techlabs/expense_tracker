import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/theme/app_colors_extension.dart';

class CircleMemberCard extends StatelessWidget {
  final String initials;
  final String name;
  final String subtext;
  final String badgeText;
  final Color avatarColor;
  final Color badgeColor;
  final bool isDark;
  final bool showRemind;
  final Color? subtextColor;
  final Color? avatarTextColor;

  const CircleMemberCard({
    super.key,
    required this.initials,
    required this.name,
    required this.subtext,
    required this.badgeText,
    required this.avatarColor,
    required this.badgeColor,
    required this.isDark,
    this.showRemind = false,
    this.subtextColor,
    this.avatarTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: context.appTexts.bodyMedium.copyWith(
                color: avatarTextColor ?? Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
          ),
          UIHelpers.horizontalSpace(16),

          // Name and Subtext
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: context.appTexts.bodyMedium.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UIHelpers.horizontalSpace(8),
                    // Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withAlpha(isDark ? 30 : 40),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        badgeText,
                        style: context.appTexts.bodySmall.copyWith(
                          color: badgeColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 9.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelpers.verticalSpace(4),
                Text(
                  subtext,
                  style: context.appTexts.bodySmall.copyWith(
                    color: subtextColor ?? context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Action (Remind button)
          if (showRemind)
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.colors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
                minimumSize: Size(0, 32.h),
              ),
              child: Text(
                'Remind',
                style: context.appTexts.bodySmall.copyWith(
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
