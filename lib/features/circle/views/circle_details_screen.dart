import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_router.dart';
import '../../../core/widgets/primary_button.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../widgets/circle_summary_card.dart';
import '../widgets/circle_member_card.dart';
import '../widgets/circle_transaction_tile.dart';
import '../widgets/settle_up_bottom_sheet.dart';

class CircleDetailsScreen extends StatelessWidget {
  final String circleName;

  const CircleDetailsScreen({
    super.key,
    required this.circleName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: context.colors.textPrimary,
            size: 20.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          circleName,
          style: context.appTexts.displayMedium.copyWith(
            color: context.colors.textPrimary,
            fontSize: 22.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: context.colors.textPrimary,
              size: 24.sp,
            ),
            onPressed: () {
              context.push(AppRouter.circleSettings, extra: circleName);
            },
          ),
        ],
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIHelpers.verticalSpace(12),
                    // ── Summary Card ──
                    CircleSummaryCard(isDark: isDark),
                    UIHelpers.verticalSpace(28),

                    // ── Members Section Header ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'MEMBERS (3)',
                          style: context.appTexts.bodySmall.copyWith(
                            color: context.colors.textSecondary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.person_add_outlined,
                            size: 16.sp,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            'Add member',
                            style: context.appTexts.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                    UIHelpers.verticalSpace(12),

                    // ── Member List ──
                    CircleMemberCard(
                      initials: 'RK',
                      name: 'Rajesh Kumar (You)',
                      subtext: 'Is owed ₹3,600 overall',
                      badgeText: 'OWNER',
                      avatarColor: AppColors.primary,
                      badgeColor: AppColors.primary,
                      isDark: isDark,
                      showRemind: false,
                    ),
                    CircleMemberCard(
                      initials: 'AK',
                      name: 'Amit Khanna',
                      subtext: 'Owes ₹1,200 to you',
                      badgeText: 'OWES YOU',
                      avatarColor: const Color(0xFF7B3B1D), // Warm Brown
                      badgeColor: AppColors.expense,
                      isDark: isDark,
                      showRemind: true,
                      subtextColor: AppColors.expense,
                    ),
                    CircleMemberCard(
                      initials: 'PS',
                      name: 'Priya Sharma',
                      subtext: 'Settled up',
                      badgeText: 'SETTLED',
                      avatarColor: const Color(0xFF7C3AED), // Purple
                      badgeColor: isDark ? AppColors.income : AppColors.textSecondaryLight,
                      isDark: isDark,
                      showRemind: false,
                      subtextColor: isDark ? AppColors.income : AppColors.textSecondaryLight,
                    ),

                    UIHelpers.verticalSpace(28),

                    // ── Activity Section Header ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'RECENT ACTIVITY',
                          style: context.appTexts.bodySmall.copyWith(
                            color: context.colors.textSecondary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'View all',
                            style: context.appTexts.bodySmall.copyWith(
                              color: context.colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    UIHelpers.verticalSpace(12),

                    // ── Recent Activity Container ──
                    Container(
                      decoration: BoxDecoration(
                        color: context.colors.card,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: context.colors.border,
                        ),
                      ),
                      child: Column(
                        children: [
                          const CircleTransactionTile(
                            icon: Icons.restaurant_rounded,
                            title: 'Dinner at Punjab Grill',
                            subtitle: 'Paid by Rajesh • Yesterday',
                            amount: '₹3,600',
                          ),
                          Divider(
                            height: 1,
                            indent: 76.w,
                            color: context.colors.border,
                          ),
                          const CircleTransactionTile(
                            icon: Icons.local_taxi_rounded,
                            title: 'Uber to Airport',
                            subtitle: 'Paid by Amit • 3 days ago',
                            amount: '₹1,200',
                          ),
                          Divider(
                            height: 1,
                            indent: 76.w,
                            color: context.colors.border,
                          ),
                          const CircleTransactionTile(
                            icon: Icons.shopping_bag_outlined,
                            title: 'Groceries & Supplies',
                            subtitle: 'Paid by Rajesh • 5 days ago',
                            amount: '₹2,400',
                          ),
                        ],
                      ),
                    ),
                    UIHelpers.verticalSpace(24),
                  ],
                ),
              ),
            ),

            // ── Fixed Bottom Actions ──
            Container(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
              decoration: BoxDecoration(
                color: context.colors.background,
                border: Border(
                  top: BorderSide(
                    color: context.colors.border,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => showSettleUpBottomSheet(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark ? AppColors.borderDark : AppColors.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        minimumSize: Size(0, 52.h),
                      ),
                      child: Text(
                        'Settle up',
                        style: context.appTexts.bodyLarge.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  UIHelpers.horizontalSpace(12),
                  Expanded(
                    child: PrimaryButton(
                      text: '+ Add expense',
                      onPressed: () {},
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
