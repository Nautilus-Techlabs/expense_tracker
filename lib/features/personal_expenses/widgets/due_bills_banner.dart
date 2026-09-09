import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../auth/viewmodels/auth_notifier.dart';
import '../models/recurring_bill_model.dart';
import '../models/transaction_payload.dart';
import '../viewmodels/account_notifier.dart';
import '../viewmodels/recurring_bill_notifier.dart';
import '../viewmodels/transaction_notifier.dart';
import 'edit_recurring_bill_sheet.dart';

class DueBillsBanner extends ConsumerWidget {
  const DueBillsBanner({super.key});

  void _openEditSheet(BuildContext context, RecurringBillModel bill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EditRecurringBillBottomSheet(bill: bill),
    );
  }

  Future<void> _logBillTransaction(
    BuildContext context,
    WidgetRef ref,
    RecurringBillModel bill,
  ) async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    // Validate the stored account still exists in Supabase
    final account = ref.read(accountProvider.notifier).getAccountById(bill.accountId);
    if (account == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Account not found. Please edit this bill and re-select an account.',
            ),
            backgroundColor: AppColors.expense,
            action: SnackBarAction(
              label: 'Edit',
              textColor: Colors.white,
              onPressed: () => _openEditSheet(context, bill),
            ),
          ),
        );
      }
      return;
    }

    final payload = TransactionPayload(
      userId: user.id,
      accountId: bill.accountId,
      categoryId: bill.categoryId,
      type: 'expense',
      amount: bill.amount,
      note: '${bill.title} (Recurring Bill)',
      txnDate: DateTime.now(),
      isCircleTransaction: false,
      isReimbursement: false,
      isDeleted: false,
    );

    final success = await ref
        .read(transactionProvider.notifier)
        .addTransaction(payload);

    if (success) {
      await ref
          .read(recurringBillNotifierProvider.notifier)
          .markAsLogged(bill.id, DateTime.now());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Logged payment of ${bill.amount.toStringAsFixed(2)} for ${bill.title}',
            ),
            backgroundColor: AppColors.income,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final bills = ref.watch(recurringBillNotifierProvider);
    final dueBills = bills.where((bill) => bill.isDueForMonth(now)).toList();

    if (dueBills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active_rounded,
                color: AppColors.primary,
                size: 22.sp,
              ),
              UIHelpers.horizontalSpace(10),
              Text(
                'Recurring Bills Due (${dueBills.length})',
                style: context.appTexts.bodyLarge.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          UIHelpers.verticalSpace(12),
          ...dueBills.map((bill) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bill.title,
                          style: context.appTexts.bodyMedium.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Due on day ${bill.dayOfMonth} of month',
                          style: context.appTexts.bodySmall.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    bill.amount.toStringAsFixed(2),
                    style: context.appTexts.bodyLarge.copyWith(
                      color: AppColors.expense,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  UIHelpers.horizontalSpace(12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => _logBillTransaction(context, ref, bill),
                    child: Text(
                      'Pay Now',
                      style: context.appTexts.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20.sp,
                      color: context.colors.textSecondary,
                    ),
                    onPressed: () => _openEditSheet(context, bill),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
