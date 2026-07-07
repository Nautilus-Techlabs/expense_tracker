import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/ui_helpers.dart';
import 'package:showcaseview/showcaseview.dart';

class DashboardHeader extends StatelessWidget {
  final double balance;
  final double income;
  final double spends;
  final VoidCallback onSync;
  final VoidCallback onSupport;
  final bool isLoading;
  final GlobalKey? balanceKey;
  final GlobalKey? syncKey;
  final GlobalKey? supportKey;

  const DashboardHeader({
    super.key,
    required this.balance,
    required this.income,
    required this.spends,
    required this.onSync,
    required this.onSupport,
    required this.isLoading,
    this.balanceKey,
    this.syncKey,
    this.supportKey,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, topPadding + 12.h, 24.w, 32.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.light
              ? [
                  AppTheme.primaryLight,
                  const Color(
                    0xFF0D9488,
                  ), // Darker teal for better contrast and depth
                ]
              : [const Color(0xFF1E293B), AppTheme.bgDark],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 20 / 255),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 31.sp,
                  ),
                  UIHelpers.horizontalSpace(12),
                  Text(
                    'Expense Lite',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Showcase(
                    key: syncKey ?? GlobalKey(),
                    title: 'Sync Transactions',
                    description: 'Tap here to refresh your transactions from SMS.',
                    child: _HeaderAction(
                      icon: Icons.sync_rounded,
                      onTap: onSync,
                      isLoading: isLoading,
                    ),
                  ),
                  UIHelpers.horizontalSpace(8),
                  Showcase(
                    key: supportKey ?? GlobalKey(),
                    title: 'Support & Feedback',
                    description: 'Have a suggestion? Send us a message here!',
                    child: _HeaderAction(
                      icon: Icons.support_agent_rounded,
                      onTap: onSupport,
                    ),
                  ),
                ],
              ),
            ],
          ),
          UIHelpers.verticalSpace(36),
          Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 204 / 255),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          UIHelpers.verticalSpace(4),
          Showcase(
            key: balanceKey ?? GlobalKey(),
            title: 'Total Balance',
            description: 'Your combined balance across all verified accounts.',
            child: Text(
              '₹${balance.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
              ),
            ),
          ),
          UIHelpers.verticalSpace(28),
          Row(
            children: [
              Expanded(
                child: _SummaryIndicator(
                  label: 'Credit',
                  amount: income,
                  icon: Icons.south_west_rounded,
                  color: AppTheme.getIncomeColor(context),
                ),
              ),
              UIHelpers.horizontalSpace(16),
              Expanded(
                child: _SummaryIndicator(
                  label: 'Debit',
                  amount: spends,
                  icon: Icons.north_east_rounded,
                  color: AppTheme.getExpenseColor(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  const _HeaderAction({
    required this.icon,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              UIHelpers.lightImpact();
              onTap();
            },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 31 / 255), // 0.12 * 255
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 26 / 255),
          ), // 0.1 * 255
        ),
        child: isLoading
            ? SizedBox(
                width: 20.sp,
                height: 20.sp,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }
}

class _SummaryIndicator extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;

  const _SummaryIndicator({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 40 / 255,
        ), // Increased opacity (0.16)
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 40 / 255)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color, // Solid Green or Red
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 100 / 255),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 40 / 255),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
          UIHelpers.horizontalSpace(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(
                    alpha: 220 / 255,
                  ), // Lighter, more visible
                  fontSize: 12.sp, // Slightly larger
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
