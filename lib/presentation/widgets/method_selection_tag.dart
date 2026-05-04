import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';
import 'transaction_ui_components.dart';

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
              color: AppTheme.getNeutralColor(context),
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
                color: Theme.of(context).colorScheme.primary,
              ),
              ...methods.map(
                (method) => _MethodPill(
                  label: method.name.toUpperCase(),
                  isSelected: state.selectedMethod == method,
                  onTap: () => controller.setMethodFilter(method),
                  icon: TransactionIcon.getIconData(method),
                  color: _getMethodColor(context, method),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getMethodColor(BuildContext context, PaymentMethod method) {
    return Theme.of(context).colorScheme.primary;
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
                : AppTheme.getSurfaceSecondaryColor(context),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected ? color : AppTheme.getBorderColor(context),
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
                      : Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
