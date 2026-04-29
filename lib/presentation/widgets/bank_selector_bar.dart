import 'package:expense_tracker/presentation/providers/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/theme/app_theme.dart';
import '../providers/transaction_notifier.dart';

class BankSelectorBar extends StatelessWidget {
  final TransactionState state;
  final TransactionController controller;

  const BankSelectorBar({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final banks = state.getAvailableBanks();
    final hasUnsupported = state.hasUnsupportedTransactions();

    if (banks.isEmpty && !hasUnsupported) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
          child: Text(
            'Accounts',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withAlpha(102), // 0.4 * 255
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(
          height: 100.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            physics: const BouncingScrollPhysics(),
            children: [
              _BankCard(
                label: 'All',
                isSelected: state.selectedBank == null,
                onTap: () => controller.setBankFilter(null),
                icon: Icons.apps_rounded,
                color: AppTheme.primary,
              ),
              ...banks.map(
                (bank) => _BankCard(
                  label: bank,
                  isSelected: state.selectedBank == bank,
                  onTap: () => controller.setBankFilter(bank),
                  letter: bank.substring(0, 1).toUpperCase(),
                  color: _getBankColor(bank),
                ),
              ),
              if (hasUnsupported)
                _BankCard(
                  label: 'Unknown',
                  isSelected: state.selectedBank == 'unsupported',
                  onTap: () => controller.setBankFilter('unsupported'),
                  icon: Icons.help_outline_rounded,
                  color: AppTheme.slate500,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getBankColor(String bank) {
    final b = bank.toLowerCase();
    if (b.contains('hdfc')) return const Color(0xFF1E3A8A);
    if (b.contains('axis')) return const Color(0xFF991B1B);
    if (b.contains('icici')) return const Color(0xFFEA580C);
    if (b.contains('sbi')) return const Color(0xFF0369A1);
    return AppTheme.primary;
  }
}

class _BankCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? letter;
  final IconData? icon;
  final Color color;

  const _BankCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.letter,
    this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: GestureDetector(
        onTap: () {
          UIHelpers.lightImpact();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 80.w,
          decoration: BoxDecoration(
            color: isSelected
                ? color
                : (isDark ? AppTheme.slate800 : Colors.white),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? color
                  : (isDark ? AppTheme.slate700 : AppTheme.slate200),
              width: 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: color.withAlpha(77), // 0.3 * 255
                )
              else
                BoxShadow(
                  color: Colors.black.withAlpha(10), // 0.04 * 255
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withAlpha(51) // 0.2 * 255
                      : color.withAlpha(26), // 0.1 * 255
                  shape: BoxShape.circle,
                ),
                child: letter != null
                    ? Text(
                        letter!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : color,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.sp,
                        ),
                      )
                    : Icon(
                        icon,
                        color: isSelected ? Colors.white : color,
                        size: 20.sp,
                      ),
              ),
              UIHelpers.verticalSpace(8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppTheme.slate300 : AppTheme.slate700),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
