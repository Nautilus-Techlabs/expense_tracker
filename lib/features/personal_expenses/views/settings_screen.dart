import 'package:expense_tracker/core/theme/theme_notifier.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/account_notifier.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/budget_notifier.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/export_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_router.dart';
import '../../../../core/theme/app_colors_extension.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).user;
    final themeMode = ref.watch(themeProvider);
    final budget = ref.watch(budgetProvider).budget;
    final accountsCount = ref.watch(accountProvider).accounts.length;
    final exportState = ref.watch(exportProvider);

    // Listen for export errors and completions
    ref.listen(exportProvider, (prev, next) {
      if (!context.mounted) return;
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(exportProvider.notifier).clearError();
      } else if (next.exportCompleted && !(prev?.exportCompleted ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export successful!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    String initials = '??';
    if (user != null && user.fullName.isNotEmpty) {
      final parts = user.fullName.trim().split(' ');
      if (parts.length > 1) {
        initials = (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
      } else if (parts[0].isNotEmpty) {
        initials = parts[0][0].toUpperCase();
      }
    }

    String themeLabel = 'System';
    if (themeMode == ThemeMode.light) themeLabel = 'Light';
    if (themeMode == ThemeMode.dark) themeLabel = 'Dark';

    return Scaffold(
      backgroundColor: context.colors.background,
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
                        color: context.colors.textPrimary,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Profile',
                        style: context.appTexts.displayMedium.copyWith(
                          color: context.colors.textPrimary,
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
                  color: context.colors.textPrimary,
                  fontSize: 20.sp,
                ),
              ),
              UIHelpers.verticalSpace(4),
              Text(
                user?.email ?? 'No email linked',
                style: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
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
                              color: context.colors.textSecondary,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          UIHelpers.verticalSpace(8),
                          Text(
                            accountsCount.toString(),
                            style: context.appTexts.displayMedium.copyWith(
                              color: context.colors.textPrimary,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40.h,
                      color: context.colors.border,
                    ),
                    // Expanded(
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         'CIRCLES',
                    //         style: context.appTexts.bodySmall.copyWith(
                    //           color: isDark
                    //               ? AppColors.textSecondaryDark
                    //               : AppColors.textSecondaryLight,
                    //           fontSize: 10.sp,
                    //           fontWeight: FontWeight.w700,
                    //           letterSpacing: 1.2,
                    //         ),
                    //       ),
                    //       UIHelpers.verticalSpace(8),
                    //       Text(
                    //         '3',
                    //         style: context.appTexts.displayMedium.copyWith(
                    //           color: isDark
                    //               ? AppColors.textPrimaryDark
                    //               : AppColors.textPrimaryLight,
                    //           fontSize: 18.sp,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),Expanded(
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         'CIRCLES',
                    //         style: context.appTexts.bodySmall.copyWith(
                    //           color: isDark
                    //               ? AppColors.textSecondaryDark
                    //               : AppColors.textSecondaryLight,
                    //           fontSize: 10.sp,
                    //           fontWeight: FontWeight.w700,
                    //           letterSpacing: 1.2,
                    //         ),
                    //       ),
                    //       UIHelpers.verticalSpace(8),
                    //       Text(
                    //         '3',
                    //         style: context.appTexts.displayMedium.copyWith(
                    //           color: isDark
                    //               ? AppColors.textPrimaryDark
                    //               : AppColors.textPrimaryLight,
                    //           fontSize: 18.sp,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              UIHelpers.verticalSpace(32),

              // ── List Sections ──
              _buildSectionHeader(context, 'PREFERENCES', isDark),
              // _buildListItem(
              //   context: context,
              //   icon: Icons.notifications_none_rounded,
              //   title: 'Notifications',
              //   isDark: isDark,
              // ),
              _buildListItem(
                context: context,
                icon: Icons.dark_mode_outlined,
                title: 'Appearance',
                trailingText: themeLabel,
                isDark: isDark,
                onTap: () => _showThemeDialog(context, ref),
              ),

              // _buildListItem(
              //   context: context,
              //   icon: Icons.lock_outline_rounded,
              //   title: 'Privacy & Security',
              //   isDark: isDark,
              // ),
              UIHelpers.verticalSpace(16),
              _buildSectionHeader(context, 'FINANCE', isDark),
              _buildListItem(
                context: context,
                icon: Icons.track_changes_rounded,
                title: 'Monthly budget',
                trailingText: '₹${budget?.amount.toStringAsFixed(0) ?? '0'}',
                isDark: isDark,
                onTap: () => _showBudgetDialog(context, ref),
              ),
              _buildListItem(
                context: context,
                icon: Icons.account_balance_wallet_outlined,
                title: 'Accounts',
                isDark: isDark,
                onTap: () => context.push(AppRouter.accountsSettings),
              ),
              _buildListItem(
                context: context,
                icon: Icons.local_offer_outlined,
                title: 'Categories',
                isDark: isDark,
                onTap: () => context.push(AppRouter.categoriesSettings),
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
                icon: exportState.isLoading
                    ? Icons.hourglass_top_rounded
                    : Icons.download_rounded,
                title: 'Export data',
                trailingText: exportState.isLoading ? 'Exporting…' : 'CSV',
                isDark: isDark,
                onTap: exportState.isLoading
                    ? null
                    : () => ref
                          .read(exportProvider.notifier)
                          .exportCsv(context),
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

  void _showBudgetDialog(BuildContext context, WidgetRef ref) {
    final budgetState = ref.read(budgetProvider);
    final controller = TextEditingController(
      text: budgetState.budget?.amount.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.card,
        title: Text('Monthly Budget', style: context.appTexts.heading),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set your spending limit for ${DateFormat('MMMM').format(DateTime.now())}. This helps you stay on track with your financial goals.',
              style: context.appTexts.bodySmall.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            UIHelpers.verticalSpace(16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: context.appTexts.bodyMedium.copyWith(
                color: context.colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Enter amount',
                prefixText: '₹ ',
                prefixStyle: context.appTexts.bodyMedium,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: context.appTexts.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(controller.text) ?? 0.0;
              if (amount > 0) {
                await ref
                    .read(budgetProvider.notifier)
                    .createOrUpdateBudget(
                      amount: amount,
                      month: DateTime.now(),
                    );
                if (context.mounted) Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(80, 40),
            ),
            child: Text('Update', style: context.appTexts.buttonPrimary),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.card,
        title: Text('Choose Appearance', style: context.appTexts.heading),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              label: 'Light',
              icon: Icons.light_mode_outlined,
              isSelected: currentTheme == ThemeMode.light,
              onTap: () {
                ref.read(themeProvider.notifier).setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
              isDark: isDark,
            ),
            _buildThemeOption(
              context,
              label: 'Dark',
              icon: Icons.dark_mode_outlined,
              isSelected: currentTheme == ThemeMode.dark,
              onTap: () {
                ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
              isDark: isDark,
            ),
            _buildThemeOption(
              context,
              label: 'System Default',
              icon: Icons.settings_brightness_outlined,
              isSelected: currentTheme == ThemeMode.system,
              onTap: () {
                ref.read(themeProvider.notifier).setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: context.colors.textPrimary,
      ),
      title: Text(
        label,
        style: context.appTexts.bodyMedium.copyWith(
          color: context.colors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
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
              color: context.colors.textSecondary,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          UIHelpers.horizontalSpace(16),
          Expanded(
            child: Container(
              height: 1,
              color: context.colors.border,
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: context.colors.textPrimary,
            ),
            UIHelpers.horizontalSpace(16),
            Expanded(
              child: Text(
                title,
                style: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: context.appTexts.bodySmall.copyWith(
                  color: context.colors.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
              UIHelpers.horizontalSpace(8),
            ],
            Icon(
              Icons.chevron_right_rounded,
              size: 16.sp,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
