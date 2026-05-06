import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../providers/transaction_state.dart';
import 'set_opening_balance_sheet.dart';

class DashboardHeader extends StatelessWidget {
  final double balance;
  final double income;
  final double spends;
  final VoidCallback onSync;
  final Function(TransactionSort) onSort;
  final TransactionSort currentSort;
  final bool isLoading;

  const DashboardHeader({
    super.key,
    required this.balance,
    required this.income,
    required this.spends,
    required this.onSync,
    required this.onSort,
    required this.currentSort,
    required this.isLoading,
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
              ? [AppTheme.primaryLight, AppTheme.primaryLight.withValues(alpha: 230 / 255)]
              : [AppTheme.surfaceDark, AppTheme.bgDark],
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
                  _HeaderAction(
                    icon: Icons.account_balance_rounded,
                    onTap: () => _showOpeningBalanceSheet(context),
                  ),
                  UIHelpers.horizontalSpace(12),
                  _HeaderAction(
                    icon: Icons.sort_rounded,
                    onTap: () => _showSortMenu(context),
                  ),
                  UIHelpers.horizontalSpace(12),
                  _HeaderAction(
                    icon: Icons.sync_rounded,
                    onTap: onSync,
                    isLoading: isLoading,
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
          Text(
            '₹${balance.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
            ),
          ),
          UIHelpers.verticalSpace(28),
          Row(
            children: [
              Expanded(
                child: _SummaryIndicator(
                  label: 'Income',
                  amount: income,
                  icon: Icons.south_west_rounded,
                  color: AppTheme.getIncomeColor(context),
                ),
              ),
              UIHelpers.horizontalSpace(16),
              Expanded(
                child: _SummaryIndicator(
                  label: 'Expenses',
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

  void _showOpeningBalanceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SetOpeningBalanceSheet(),
    );
  }

  void _showSortMenu(BuildContext context) {
    final theme = Theme.of(context);
    showMenu<TransactionSort>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 100,
        100,
        24,
        0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: theme.colorScheme.surface,
      elevation: 8,
      items: [
        _buildSortItem(
          context,
          TransactionSort.dateDesc,
          'Newest First',
          Icons.calendar_today_rounded,
        ),
        _buildSortItem(
          context,
          TransactionSort.dateAsc,
          'Oldest First',
          Icons.history_rounded,
        ),
        _buildSortItem(
          context,
          TransactionSort.amountDesc,
          'High to Low',
          Icons.trending_down_rounded,
        ),
        _buildSortItem(
          context,
          TransactionSort.amountAsc,
          'Low to High',
          Icons.trending_up_rounded,
        ),
      ],
    ).then((value) {
      if (value != null) onSort(value);
    });
  }

  PopupMenuItem<TransactionSort> _buildSortItem(
    BuildContext context,
    TransactionSort value,
    String label,
    IconData icon,
  ) {
    final isSelected = currentSort == value;

    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : AppTheme.getNeutralColor(context),
          ),
          UIHelpers.horizontalSpace(12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
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
          border: Border.all(color: Colors.white.withValues(alpha: 26 / 255)), // 0.1 * 255
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
        color: Colors.white.withValues(alpha: 31 / 255), // 0.12 * 255
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 26 / 255)), // 0.1 * 255
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 51 / 255), // 0.2 * 255
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 14.sp),
          ),
          UIHelpers.horizontalSpace(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 179 / 255), // 0.7 * 255
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
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
