import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';

class MethodSelectionTag extends StatelessWidget {
  final TransactionState state;
  final TransactionController controller;

  const MethodSelectionTag({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final methods = state.getAvailableMethods();
    if (methods.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 12.h),
          child: Text(
            'Payment Methods',
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
        Container(
          height: 44.h,
          margin: EdgeInsets.symmetric(vertical: 4.h),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            physics: const BouncingScrollPhysics(),
            children: [
              _MethodPill(
                label: 'All',
                isSelected: state.selectedMethod == null,
                onTap: () => controller.setMethodFilter(null),
                icon: Icons.all_inbox_rounded,
                color: AppTheme.primary,
              ),
              ...methods.map(
                (method) => _MethodPill(
                  label: method.name.toUpperCase(),
                  isSelected: state.selectedMethod == method,
                  onTap: () => controller.setMethodFilter(method),
                  icon: _getIcon(method),
                  color: _getMethodColor(method),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getMethodColor(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.upi:
        return const Color(0xFF10B981); // Emerald
      case PaymentMethod.card:
        return const Color(0xFF6366F1); // Indigo
      case PaymentMethod.atm:
        return const Color(0xFFF59E0B); // Amber
      case PaymentMethod.imps:
      case PaymentMethod.neft:
      case PaymentMethod.rtgs:
        return const Color(0xFFEC4899); // Pink
      default:
        return AppTheme.primary;
    }
  }

  IconData _getIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.upi:
        return Icons.qr_code_2_rounded;
      case PaymentMethod.card:
        return Icons.credit_card_rounded;
      case PaymentMethod.atm:
        return Icons.account_balance_wallet_rounded;
      case PaymentMethod.imps:
        return Icons.bolt_rounded;
      case PaymentMethod.neft:
      case PaymentMethod.rtgs:
        return Icons.account_balance_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }
}

class _MethodPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  const _MethodPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: GestureDetector(
        onTap: () {
          UIHelpers.lightImpact();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isSelected
                ? color
                : (isDark ? AppTheme.slate800 : AppTheme.slate100),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? color
                  : AppTheme.slate200.withAlpha(128), // 0.5 * 255
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14.sp, color: isSelected ? Colors.white : color),
              UIHelpers.horizontalSpace(8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppTheme.slate300 : AppTheme.slate700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
