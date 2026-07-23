import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../models/circle_data.dart';
import '../models/circle_model.dart';
import 'circle_type_badge.dart';
import 'member_avatar_stack.dart';
import 'stat_column.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../core/constants/app_router.dart';
import 'package:go_router/go_router.dart';

class CircleCard extends StatelessWidget {
  final CircleData circle;
  final bool isDark;

  const CircleCard({super.key, required this.circle, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = context.colors.card;
    final borderColor = context.colors.border;
    final isOneTime = circle.type == CircleType.oneTime;

    return GestureDetector(
      onTap: () {
        context.push(AppRouter.circleDetails, extra: circle.name);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Type badge + member avatars ──
            Row(
              children: [
                CircleTypeBadge(
                  label: isOneTime ? 'ONE-TIME' : 'ONGOING',
                  isDark: isDark,
                ),
                const Spacer(),
                MemberAvatarStack(members: circle.members),
              ],
            ),
            UIHelpers.verticalSpace(12),

            // ── Name + chevron ──
            Row(
              children: [
                Expanded(
                  child: Text(
                    circle.name,
                    style: context.appTexts.displayMedium.copyWith(
                      color: context.colors.primary,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.sp,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
            UIHelpers.verticalSpace(4),

            // ── Member count ──
            Row(
              children: [
                Icon(
                  Icons.group_outlined,
                  size: 15.sp,
                  color: context.colors.textSecondary,
                ),
                UIHelpers.horizontalSpace(6),
                Text(
                  '${circle.members.length} members',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
            UIHelpers.verticalSpace(20),

            // ── Amount stats ──
            if (isOneTime) ...[
              Row(
                children: [
                  StatColumn(
                    label: 'You paid',
                    value: '₹${circle.totalAmount.toStringAsFixed(0)}',
                    isDark: isDark,
                    valueColor: context.colors.textPrimary,
                  ),
                  UIHelpers.horizontalSpace(32),
                  StatColumn(
                    label: 'Pending',
                    value: '₹${circle.pending!.toStringAsFixed(0)}',
                    isDark: isDark,
                    valueColor: AppColors.expense,
                  ),
                ],
              ),
              UIHelpers.verticalSpace(16),
              // Settlement progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settlement Progress',
                    style: context.appTexts.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(circle.settlementProgress * 100).toStringAsFixed(0)}%',
                    style: context.appTexts.bodySmall.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              UIHelpers.verticalSpace(8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: circle.settlementProgress,
                  minHeight: 6.h,
                  backgroundColor: isDark
                      ? AppColors.borderDark
                      : const Color(0xFFE5E5E0),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  StatColumn(
                    label: 'This month',
                    value: '₹${circle.totalAmount.toStringAsFixed(0)}',
                    isDark: isDark,
                    valueColor: context.colors.textPrimary,
                  ),
                  UIHelpers.horizontalSpace(32),
                  if (circle.yourShare != null)
                    StatColumn(
                      label: 'Your share',
                      value: '₹${circle.yourShare!.toStringAsFixed(0)}',
                      isDark: isDark,
                      valueColor: context.colors.textPrimary,
                    ),
                  if (circle.youOwe != null)
                    StatColumn(
                      label: 'You owe',
                      value: '₹${circle.youOwe!.toStringAsFixed(0)}',
                      isDark: isDark,
                      valueColor: AppColors.expense,
                    ),
                ],
              ),
              if (circle.lastActivity.isNotEmpty) ...[
                UIHelpers.verticalSpace(16),
                Divider(height: 1, color: context.colors.border),
                UIHelpers.verticalSpace(12),
                Row(
                  children: [
                    Icon(
                      circle.lastActivity == 'Today'
                          ? Icons.flash_on_rounded
                          : Icons.access_time_rounded,
                      size: 14.sp,
                      color: context.colors.textSecondary,
                    ),
                    UIHelpers.horizontalSpace(6),
                    Text(
                      'Last activity: ${circle.lastActivity}',
                      style: context.appTexts.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
