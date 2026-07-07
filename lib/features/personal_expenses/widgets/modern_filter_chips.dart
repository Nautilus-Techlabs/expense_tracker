import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../viewmodels/history_filter_provider.dart';
import '../viewmodels/transaction_state.dart';

class ModernFilterBar extends StatelessWidget {
  final TransactionState state;
  final HistoryFilterState filters;
  final HistoryFilterNotifier controller;

  const ModernFilterBar({
    super.key,
    required this.state,
    required this.filters,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AccountChips(state: state, filters: filters, controller: controller),
        _DateRangeSelector(filters: filters, controller: controller),
      ],
    );
  }
}

class _AccountChips extends StatelessWidget {
  final TransactionState state;
  final HistoryFilterState filters;
  final HistoryFilterNotifier controller;

  const _AccountChips({
    required this.state,
    required this.filters,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final accounts = state.getUniqueAccounts();
    final hasUnknown = state.hasUnsupportedTransactions();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _FilterChip(
            label: 'All Accounts',
            isSelected: filters.selectedBank == null,
            onTap: () => controller.setBankFilter(null),
            icon: Icons.account_balance_wallet_rounded,
          ),
          ...accounts.map((acc) {
            final logoUrl = state.bankLogos[acc.bankName];
            return Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: _FilterChip(
                label: acc.bankName,
                sublabel: acc.accountNumber,
                isSelected: filters.selectedBank == acc.accountNumber,
                onTap: () => controller.setBankFilter(acc.accountNumber),
                logo: logoUrl,
              ),
            );
          }),
          if (hasUnknown)
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: _FilterChip(
                label: 'Unknown',
                isSelected: filters.selectedBank == 'unsupported',
                onTap: () => controller.setBankFilter('unsupported'),
                icon: Icons.help_outline_rounded,
              ),
            ),
        ],
      ),
    );
  }
}

class _DateRangeSelector extends StatelessWidget {
  final HistoryFilterState filters;
  final HistoryFilterNotifier controller;

  const _DateRangeSelector({required this.filters, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String rangeText = 'Select Date Range';
    if (filters.startDate != null && filters.endDate != null) {
      rangeText =
          '${DateFormat('MMM dd, yyyy').format(filters.startDate!)} - ${DateFormat('MMM dd, yyyy').format(filters.endDate!)}';
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: InkWell(
        onTap: () => _showDateRangePicker(context),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isDark ? Colors.white.withAlpha(10) : AppTheme.borderLight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  size: 20.sp,
                  color: theme.colorScheme.primary,
                ),
              ),
              UIHelpers.horizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DATE RANGE',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.getNeutralColor(context),
                        letterSpacing: 1,
                      ),
                    ),
                    UIHelpers.verticalSpace(4),
                    Text(
                      rangeText,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              if (filters.startDate != null)
                IconButton(
                  onPressed: () {
                    UIHelpers.mediumImpact();
                    controller.setDateRange(null, null);
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppTheme.getNeutralColor(context),
                    size: 20.sp,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                )
              else
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.getNeutralColor(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: filters.startDate != null && filters.endDate != null
          ? DateTimeRange(start: filters.startDate!, end: filters.endDate!)
          : null,
    );

    if (picked != null) {
      controller.setDateRange(picked.start, picked.end);
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String? sublabel;
  final bool isSelected;
  final VoidCallback onTap;
  final String? logo;
  final IconData? icon;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.sublabel,
    this.logo,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = theme.colorScheme.primary;
    final inactiveTextColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.45 : 0.55,
    );

    return GestureDetector(
      onTap: () {
        UIHelpers.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: BoxConstraints(minHeight: 44.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : AppTheme.getSurfaceSecondaryColor(context),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? activeColor : AppTheme.getBorderColor(context),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (logo != null) ...[
              SvgPicture.asset(
                logo!,
                width: 18.sp,
                height: 18.sp,
                placeholderBuilder: (_) => Icon(
                  Icons.account_balance_rounded,
                  size: 16.sp,
                  color: isSelected ? Colors.white : inactiveTextColor,
                ),
              ),
              UIHelpers.horizontalSpace(8),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: 16.sp,
                color: isSelected ? Colors.white : inactiveTextColor,
              ),
              UIHelpers.horizontalSpace(8),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : inactiveTextColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                if (sublabel != null) ...[
                  SizedBox(height: 1.h),
                  Text(
                    sublabel!,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.75)
                          : inactiveTextColor.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
