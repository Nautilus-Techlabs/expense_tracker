import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/ui_helpers.dart';

class BankSummaryCard extends StatelessWidget {
  final String bankName;
  final String? accountNumber;
  final double balance;
  final double income;
  final double spends;

  const BankSummaryCard({
    super.key,
    required this.bankName,
    this.accountNumber,
    required this.balance,
    required this.income,
    required this.spends,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppTheme.surfaceElevatedDark, AppTheme.bgDark]
              : [primaryColor, primaryColor.withValues(alpha: 0.85)],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accountNumber != null ? 'Account XX$accountNumber' : 'Total Bank Balance',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  UIHelpers.verticalSpace(4),
                  Text(
                    '₹${balance.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          UIHelpers.verticalSpace(24),
          Row(
            children: [
              _buildMiniIndicator(
                context,
                'Credit',
                income,
                Icons.arrow_downward_rounded,
                AppTheme.getIncomeColor(context),
              ),
              UIHelpers.horizontalSpace(16),
              _buildMiniIndicator(
                context,
                'Debit',
                spends,
                Icons.arrow_upward_rounded,
                AppTheme.getExpenseColor(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniIndicator(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 14.sp),
            UIHelpers.horizontalSpace(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
