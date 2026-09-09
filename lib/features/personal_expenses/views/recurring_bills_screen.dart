import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../models/recurring_bill_model.dart';
import '../viewmodels/recurring_bill_notifier.dart';
import '../widgets/edit_recurring_bill_sheet.dart';

class RecurringBillsScreen extends ConsumerWidget {
  const RecurringBillsScreen({super.key});

  void _openEditSheet(BuildContext context, RecurringBillModel bill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EditRecurringBillBottomSheet(bill: bill),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(recurringBillNotifierProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 20.sp,
            color: context.colors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Recurring Bills',
          style: context.appTexts.heading.copyWith(
            color: context.colors.textPrimary,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: bills.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.update_rounded,
                    size: 64.sp,
                    color: context.colors.textSecondary.withValues(alpha: 0.4),
                  ),
                  UIHelpers.verticalSpace(16),
                  Text(
                    'No recurring bills added yet.',
                    style: context.appTexts.bodyLarge.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  UIHelpers.verticalSpace(8),
                  Text(
                    'Toggle "Repeat Monthly" when adding a new transaction.',
                    style: context.appTexts.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              itemCount: bills.length,
              separatorBuilder: (ctx, i) => UIHelpers.verticalSpace(12),
              itemBuilder: (context, index) {
                final bill = bills[index];
                final isDue = bill.isDueForMonth(DateTime.now());

                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDue
                          ? AppColors.primary
                          : context.colors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.update_rounded,
                          color: AppColors.primary,
                          size: 22.sp,
                        ),
                      ),
                      UIHelpers.horizontalSpace(14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bill.title,
                              style: context.appTexts.bodyLarge.copyWith(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            UIHelpers.verticalSpace(4),
                            Text(
                              'Repeats on day ${bill.dayOfMonth} of every month',
                              style: context.appTexts.bodySmall.copyWith(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            bill.amount.toStringAsFixed(2),
                            style: context.appTexts.bodyLarge.copyWith(
                              color: AppColors.expense,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (isDue)
                            Container(
                              margin: EdgeInsets.only(top: 4.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.expense.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'Due Now',
                                style: context.appTexts.bodySmall.copyWith(
                                  color: AppColors.expense,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                      UIHelpers.horizontalSpace(8),
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: context.colors.textSecondary,
                          size: 20.sp,
                        ),
                        onPressed: () => _openEditSheet(context, bill),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
