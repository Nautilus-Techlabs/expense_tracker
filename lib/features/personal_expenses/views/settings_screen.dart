import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).user;

    String initials = '??';
    if (user != null && user.fullName.isNotEmpty) {
      final parts = user.fullName.trim().split(' ');
      if (parts.length > 1) {
        initials = (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
      } else if (parts[0].isNotEmpty) {
        initials = parts[0][0].toUpperCase();
      }
    }

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Header ──
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 24.w, 16.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20.sp,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Profile',
                        style: context.appTexts.displayMedium.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontSize: 28.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Profile Avatar & Info ──
              UIHelpers.verticalSpace(16),
              Container(
                width: 72.w,
                height: 72.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: context.appTexts.displayMedium.copyWith(
                    color: Colors.white,
                    fontSize: 24.sp,
                  ),
                ),
              ),
              UIHelpers.verticalSpace(16),
              Text(
                user?.fullName ?? 'Guest User',
                style: context.appTexts.displayMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontSize: 20.sp,
                ),
              ),
              UIHelpers.verticalSpace(4),
              Text(
                user?.email ?? 'No email linked',
                style: context.appTexts.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              UIHelpers.verticalSpace(12),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Edit profile',
                  style: context.appTexts.bodySmall.copyWith(
                    color: isDark ? const Color(0xFFA3C2A4) : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              UIHelpers.verticalSpace(32),

              // ── Stats Section (Accounts / Circles) ──
              Container(
                color: isDark
                    ? const Color(0xFF1E1E1E)
                    : const Color(0xFFF6F6F0),
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'ACCOUNTS',
                            style: context.appTexts.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          UIHelpers.verticalSpace(8),
                          Text(
                            '4',
                            style: context.appTexts.displayMedium.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40.h,
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'CIRCLES',
                            style: context.appTexts.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          UIHelpers.verticalSpace(8),
                          Text(
                            '3',
                            style: context.appTexts.displayMedium.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              UIHelpers.verticalSpace(32),

              // ── List Sections ──
              _buildSectionHeader(context, 'PREFERENCES', isDark),
              _buildListItem(
                context: context,
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                isDark: isDark,
              ),
              _buildListItem(
                context: context,
                icon: Icons.dark_mode_outlined,
                title: 'Appearance',
                trailingText: isDark ? 'Dark' : 'Light',
                isDark: isDark,
              ),
              _buildListItem(
                context: context,
                icon: Icons.lock_outline_rounded,
                title: 'Privacy & Security',
                isDark: isDark,
              ),

              UIHelpers.verticalSpace(16),
              _buildSectionHeader(context, 'FINANCE', isDark),
              _buildListItem(
                context: context,
                icon: Icons.track_changes_rounded,
                title: 'Monthly budget',
                trailingText: '₹40,000',
                isDark: isDark,
              ),
              _buildListItem(
                context: context,
                icon: Icons.account_balance_wallet_outlined,
                title: 'Accounts',
                isDark: isDark,
              ),
              _buildListItem(
                context: context,
                icon: Icons.local_offer_outlined,
                title: 'Categories',
                isDark: isDark,
              ),

              // UIHelpers.verticalSpace(16),
              // _buildSectionHeader(context, 'CIRCLES', isDark),
              // _buildListItem(
              //   context: context,
              //   icon: Icons.group_outlined,
              //   title: 'My circles',
              //   isDark: isDark,
              // ),
              // _buildListItem(
              //   context: context,
              //   icon: Icons.notifications_active_outlined,
              //   title: 'Circle notifications',
              //   isDark: isDark,
              // ),
              UIHelpers.verticalSpace(16),
              _buildSectionHeader(context, 'DATA', isDark),
              _buildListItem(
                context: context,
                icon: Icons.download_rounded,
                title: 'Export data',
                trailingText: 'CSV / PDF',
                isDark: isDark,
              ),
              _buildListItem(
                context: context,
                icon: Icons.sync_rounded,
                title: 'Sync status',
                trailingText: 'Last synced: 2 min ago',
                isDark: isDark,
              ),

              UIHelpers.verticalSpace(16),
              _buildSectionHeader(context, 'SUPPORT', isDark),
              _buildListItem(
                context: context,
                icon: Icons.help_outline_rounded,
                title: 'Help & FAQ',
                isDark: isDark,
              ),
              _buildListItem(
                context: context,
                icon: Icons.star_border_rounded,
                title: 'Rate Finia',
                isDark: isDark,
              ),
              _buildListItem(
                context: context,
                icon: Icons.info_outline_rounded,
                title: 'About',
                trailingText: 'v1.0.0',
                isDark: isDark,
              ),

              UIHelpers.verticalSpace(48),

              // ── Log Out Button ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).signOut();
                    context.go(AppRouter.welcome);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark
                          ? const Color(0xFF333333)
                          : const Color(0xFFE5E5E5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    minimumSize: Size(double.infinity, 56.h),
                  ),
                  child: Text(
                    'Log out',
                    style: context.appTexts.bodyMedium.copyWith(
                      color: AppColors.expense,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              UIHelpers.verticalSpace(64),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          Text(
            title,
            style: context.appTexts.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          UIHelpers.horizontalSpace(16),
          Expanded(
            child: Container(
              height: 1,
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? trailingText,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
            UIHelpers.horizontalSpace(16),
            Expanded(
              child: Text(
                title,
                style: context.appTexts.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: context.appTexts.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontSize: 11.sp,
                ),
              ),
              UIHelpers.horizontalSpace(8),
            ],
            Icon(
              Icons.chevron_right_rounded,
              size: 16.sp,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ],
        ),
      ),
    );
  }
}
