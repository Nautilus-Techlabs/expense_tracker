import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';

class ModernFilterBar extends StatelessWidget {
  final TransactionState state;
  final TransactionController controller;

  const ModernFilterBar({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AccountChips(state: state, controller: controller),
        _DateRangeSelector(state: state, controller: controller),
      ],
    );
  }
}

class _AccountChips extends StatelessWidget {
  final TransactionState state;
  final TransactionController controller;

  const _AccountChips({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    final banks = state.getAvailableBanks();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _FilterChip(
            label: 'All Accounts',
            isSelected: state.selectedBank == null,
            onTap: () => controller.setBankFilter(null),
            icon: Icons.account_balance_wallet_rounded,
          ),
          ...banks.map((bank) {
            final logoUrl = state.bankLogos[bank];
            return Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: _FilterChip(
                label: bank,
                isSelected: state.selectedBank == bank,
                onTap: () => controller.setBankFilter(bank),
                logo: logoUrl,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DateRangeSelector extends StatelessWidget {
  final TransactionState state;
  final TransactionController controller;

  const _DateRangeSelector({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String rangeText = 'Select Date Range';
    if (state.startDate != null && state.endDate != null) {
      rangeText =
          '${DateFormat('MMM dd, yyyy').format(state.startDate!)} - ${DateFormat('MMM dd, yyyy').format(state.endDate!)}';
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: InkWell(
        onTap: () => _showDateRangePicker(context),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151B2B) : Colors.white,
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
              if (state.startDate != null)
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
      initialDateRange: state.startDate != null && state.endDate != null
          ? DateTimeRange(start: state.startDate!, end: state.endDate!)
          : null,
    );

    if (picked != null) {
      controller.setDateRange(picked.start, picked.end);
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? logo;
  final IconData? icon;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.logo,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = const Color(0xFF2563EB);
    final inactiveTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF475569);

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
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? Colors.white.withAlpha(20) : AppTheme.borderLight),
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
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : inactiveTextColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
