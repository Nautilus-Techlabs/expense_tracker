
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../domain/entities/transaction.dart';

class TransactionCard extends ConsumerWidget {
  final Transaction transaction;
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
    final isDebit = transaction.type == TransactionType.debit;
    final color = isDebit ? AppColors.expense : AppColors.income;

    return InkWell(
      onTap: () {
        UIHelpers.lightImpact();
        context.push(
          AppRouter.transactionDetail,
          extra: {
            'transaction': transaction,
            'heroTag': heroTag,
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            // Icon
            Hero(
              tag: heroTag ?? 'tx_${transaction.id ?? transaction.rawSms}',
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
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
                    style: AppTexts.bodyLarge.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  UIHelpers.verticalSpace(4),
                  Text(
                    _getSubtitle(),
                    style: AppTexts.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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
                  style: isDebit ? AppTexts.amountExpense : AppTexts.amountIncome,
                ),
                if (transaction.bankName.isNotEmpty) ...[
                  UIHelpers.verticalSpace(4),
                  Text(
                    transaction.bankName,
                    style: AppTexts.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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

  String _getTitle() {
    if (transaction.merchant != null && transaction.merchant!.isNotEmpty) {
      return transaction.merchant!;
    }
    return transaction.type == TransactionType.debit ? 'Debit' : 'Credit';
  }

  String _getSubtitle() {
    if (transaction.category != null) {
      return transaction.category!.name;
    }
    return transaction.type == TransactionType.debit ? 'Expense' : 'Income';
  }

  IconData _getIconForTransaction() {
    // For now, we return a generic icon based on type.
    // Ideally this maps to category or merchant.
    if (transaction.type == TransactionType.debit) {
      return Icons.shopping_bag_outlined;
    } else {
      return Icons.account_balance_wallet_outlined;
    }
  }
}
