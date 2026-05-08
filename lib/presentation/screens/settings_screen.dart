import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../widgets/set_opening_balance_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppTheme.bgLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ),
            _buildSettingItem(
              context,
              icon: Icons.account_balance_rounded,
              title: 'Opening Balances',
              subtitle: 'Set initial balances for your accounts',
              onTap: () => _showOpeningBalanceSheet(context),
            ),
            _buildSettingItem(
              context,
              icon: Icons.person_outline_rounded,
              title: 'Profile',
              subtitle: 'Manage your profile and accounts',
            ),
            _buildSettingItem(
              context,
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Configure SMS sync alerts',
            ),
            _buildSettingItem(
              context,
              icon: Icons.security_rounded,
              title: 'Privacy & Security',
              subtitle: 'Biometric lock and data privacy',
            ),
            _buildSettingItem(
              context,
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              subtitle: 'FAQs and contact support',
            ),
          ],
        ),
      ),
    );
  }

  void _showOpeningBalanceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SetOpeningBalanceSheet(),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151B2B) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? Colors.white.withAlpha(10) : AppTheme.borderLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20.sp,
              ),
            ),
            UIHelpers.horizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.getNeutralColor(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.getNeutralColor(context),
            ),
          ],
        ),
      ),
    );
  }
}
