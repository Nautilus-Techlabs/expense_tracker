import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/primary_button.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import '../../../../core/theme/app_colors_extension.dart';

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
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 20.sp,
            color: context.colors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          circleName,
          style: context.appTexts.heading.copyWith(
            color: context.colors.primary,
            fontSize: 24.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              size: 24.sp,
              color: context.colors.textSecondary,
            ),
            onPressed: () {},
          ),
          UIHelpers.horizontalSpace(8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Subtitle ──
                Center(
                  child: Text(
                    'One-time • 3 members • Created 20 Jun',
                    style: context.appTexts.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                UIHelpers.verticalSpace(24),

                // ── Summary Card ──
                _SummaryCard(isDark: isDark),
                UIHelpers.verticalSpace(32),

                // ── Members Section ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MEMBERS',
                      style: context.appTexts.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        '+ Invite',
                        style: context.appTexts.bodySmall.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelpers.verticalSpace(16),
                _MemberCard(
                  initials: 'RK',
                  name: 'Rajesh Kumar',
                  subtext: 'Paid ₹3,600',
                  badgeText: 'OWNER',
                  avatarColor: AppColors.primary,
                  badgeColor: AppColors.income,
                  isDark: isDark,
                  showRemind: false,
                ),
                _MemberCard(
                  initials: 'AK',
                  name: 'Amit Khanna',
                  subtext: 'Owes ₹1,200',
                  subtextColor: AppColors.expense,
                  badgeText: 'PENDING',
                  avatarColor: const Color(0xFF7B3B1D), // Brown
                  badgeColor: AppColors.expense,
                  isDark: isDark,
                  showRemind: true,
                ),
                _MemberCard(
                  initials: 'PS',
                  name: 'Priya Sharma',
                  subtext: 'Settled ₹1,200',
                  badgeText: 'SETTLED',
                  avatarColor: isDark ? const Color(0xFF3B3B4F) : const Color(0xFFE8ECE9),
                  badgeColor: AppColors.income,
                  isDark: isDark,
                  showRemind: false,
                  avatarTextColor: isDark ? Colors.white : AppColors.primary,
                ),
                UIHelpers.verticalSpace(32),

                // ── Transactions Section ──
                Text(
                  'TRANSACTIONS',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                UIHelpers.verticalSpace(16),
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: context.colors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      _TransactionTile(
                        icon: Icons.restaurant,
                        title: 'Goa Trip Dinner',
                        subtitle: '28 Jun${isDark ? ' · Paid by Rajiv' : ''}',
                        amount: '₹3,600',
                        isDark: isDark,
                      ),
                      Divider(height: 1, color: context.colors.border),
                      _TransactionTile(
                        icon: Icons.directions_car_rounded,
                        title: 'Cab to Airport',
                        subtitle: '27 Jun${isDark ? ' · Paid by Rajiv' : ''}',
                        amount: '₹1,800',
                        isDark: isDark,
                      ),
                      Divider(height: 1, color: context.colors.border),
                      _TransactionTile(
                        icon: Icons.beach_access_rounded,
                        title: 'Beach Shack Lunch',
                        subtitle: '26 Jun${isDark ? ' · Paid by Rajiv' : ''}',
                        amount: '₹1,800',
                        isDark: isDark,
                      ),
                      Divider(height: 1, color: context.colors.border),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'See all transactions',
                                style: context.appTexts.bodySmall.copyWith(
                                  color: context.colors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              UIHelpers.horizontalSpace(4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 16.sp,
                                color: context.colors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                UIHelpers.verticalSpace(120), // Padding for bottom button
              ],
            ),
          ),

          // ── Bottom Settle Up Button ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: true,
              top: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                decoration: BoxDecoration(
                  color: context.colors.background,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      (context.colors.background).withAlpha(0),
                      context.colors.background,
                    ],
                    stops: const [0.0, 0.3],
                  ),
                ),
                child: PrimaryButton(
                  text: 'Settle up',
                  icon: Icons.account_balance_wallet_outlined,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final bool isDark;

  const _SummaryCard({required this.isDark});

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
                width: 150.w, // Approximate 50%
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

class _MemberCard extends StatelessWidget {
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

  const _MemberCard({
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
        border: Border.all(
          color: context.colors.border,
        ),
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
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                    color: subtextColor ?? (context.colors.textSecondary),
                  ),
                ),
              ],
            ),
          ),

          // Action (Remind button or bell)
          if (showRemind) ...[
            if (isDark)
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
              )
            else
              IconButton(
                icon: Icon(Icons.notifications_none_rounded, color: context.colors.primary, size: 24.sp),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isDark;

  const _TransactionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isDark,
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
            child: Icon(
              icon,
              color: AppColors.expense,
              size: 20.sp,
            ),
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
