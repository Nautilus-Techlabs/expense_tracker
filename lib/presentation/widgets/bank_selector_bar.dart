import 'package:expense_tracker/presentation/providers/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_theme.dart';
import '../providers/transaction_notifier.dart';
import 'transaction_ui_components.dart';

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
              color: AppTheme.getNeutralColor(context),
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
              BankCard(
                label: 'All',
                isSelected: state.selectedBank == null,
                onTap: () => controller.setBankFilter(null),
                icon: Icons.apps_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              ...banks.map(
                (bank) => BankCard(
                  label: bank,
                  isSelected: state.selectedBank == bank,
                  onTap: () => controller.setBankFilter(bank),
                  letter: bank.substring(0, 1).toUpperCase(),
                  color: _getBankColor(context, bank),
                ),
              ),
              if (hasUnsupported)
                BankCard(
                  label: 'Unknown',
                  isSelected: state.selectedBank == 'unsupported',
                  onTap: () => controller.setBankFilter('unsupported'),
                  icon: Icons.help_outline_rounded,
                  color: AppTheme.getNeutralColor(context),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getBankColor(BuildContext context, String bank) {
    return Theme.of(context).colorScheme.primary;
  }
}
