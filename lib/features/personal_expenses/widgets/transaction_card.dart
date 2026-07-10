import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_router.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../models/transaction_model.dart';
import '../viewmodels/account_notifier.dart';

class TransactionCard extends ConsumerWidget {
  final TransactionModel transaction;
  final String? heroTag;
  final bool showDate;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.heroTag,
    this.showDate = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpense =
        transaction.type == 'expense' || transaction.type == 'withdrawal';
    final color = isExpense ? AppColors.expense : AppColors.income;

    // Resolve Account Name
    final accounts = ref.watch(accountProvider).accounts;
    final account = accounts
        .where((a) => a.id == transaction.accountId)
        .firstOrNull;
    final accountName = account?.name ?? 'Unknown Account';

    return InkWell(
      onTap: () {
        UIHelpers.lightImpact();
        context.push(
          AppRouter.transactionDetail,
          extra: {'transaction': transaction, 'heroTag': heroTag},
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            // Icon
            Hero(
              tag: heroTag ?? 'tx_${transaction.id}',
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(
                  child: Icon(
                    _getIconForTransaction(),
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
            UIHelpers.horizontalSpace(16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTitle(),
                    style: context.appTexts.bodyLarge.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  UIHelpers.verticalSpace(4),
                  Text(
                    _getSubtitle(),
                    style: context.appTexts.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),

            // Amount & Bank
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${transaction.amount.toStringAsFixed(0)}',
                  style: isExpense
                      ? context.appTexts.amountExpense
                      : context.appTexts.amountIncome,
                ),
                UIHelpers.verticalSpace(4),
                Text(
                  accountName,
                  style: context.appTexts.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    if (transaction.note != null && transaction.note!.isNotEmpty) {
      return transaction.note!;
    }
    if (transaction.type == 'income') return 'Income';
    if (transaction.type == 'withdrawal') return 'Withdrawal';
    return 'Expense';
  }

  String _getSubtitle() {
    // Ideally map categoryId to Category Name here if we had categoryProvider
    if (transaction.type == 'income') return 'Credit';
    return 'Debit';
  }

  IconData _getIconForTransaction() {
    // For now, we return a generic icon based on type.
    if (transaction.type == 'income') {
      return Icons.account_balance_wallet_outlined;
    }
    return Icons.shopping_bag_outlined;
  }
}
