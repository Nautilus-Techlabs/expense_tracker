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

class RecurringBillsScreen extends ConsumerStatefulWidget {
  const RecurringBillsScreen({super.key});

  @override
  ConsumerState<RecurringBillsScreen> createState() =>
      _RecurringBillsScreenState();
}

class _RecurringBillsScreenState extends ConsumerState<RecurringBillsScreen> {
  void _openEditSheet(RecurringBillModel bill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EditRecurringBillBottomSheet(bill: bill),
    );
  }

  Future<void> _confirmDelete(RecurringBillModel bill) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Delete Recurring Bill',
          style: ctx.appTexts.headingSmall.copyWith(
            color: ctx.colors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${bill.title}"? You will no longer receive monthly reminders for it.',
          style: ctx.appTexts.bodyMedium.copyWith(
            color: ctx.colors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: ctx.colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.expense),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      await ref
          .read(recurringBillNotifierProvider.notifier)
          .deleteBill(bill.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recurring bill deleted.'),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.07),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.update_rounded,
                      size: 52.sp,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  UIHelpers.verticalSpace(20),
                  Text(
                    'No recurring bills yet',
                    style: context.appTexts.bodyLarge.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  UIHelpers.verticalSpace(8),
                  Text(
                    'Toggle "Repeat Monthly" when adding\na new transaction.',
                    textAlign: TextAlign.center,
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
              separatorBuilder: (context, index) => UIHelpers.verticalSpace(14),
              itemBuilder: (context, index) {
                final bill = bills[index];
                return _RecurringBillTile(
                  bill: bill,
                  onEdit: () => _openEditSheet(bill),
                  onDelete: () => _confirmDelete(bill),
                );
              },
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Extracted tile widget
// ─────────────────────────────────────────────────────────────

class _RecurringBillTile extends StatelessWidget {
  final RecurringBillModel bill;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RecurringBillTile({
    required this.bill,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDue = bill.isDueForMonth(DateTime.now());
    final Color accentColor = isDue ? AppColors.warning : AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDue
              ? AppColors.warning.withValues(alpha: 0.5)
              : context.colors.border,
          width: isDue ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Main content row ──────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gradient icon container
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withValues(alpha: 0.18),
                        accentColor.withValues(alpha: 0.06),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.autorenew_rounded,
                    color: accentColor,
                    size: 24.sp,
                  ),
                ),

                UIHelpers.horizontalSpace(14),

                // Title + schedule row
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              bill.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.appTexts.bodyLarge.copyWith(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (isDue) ...[
                            UIHelpers.horizontalSpace(8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.warning.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                'Due Now',
                                style: context.appTexts.bodySmall.copyWith(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      UIHelpers.verticalSpace(4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 11.sp,
                            color: context.colors.textSecondary,
                          ),
                          UIHelpers.horizontalSpace(4),
                          Text(
                            'Every month on day ${bill.dayOfMonth}',
                            style: context.appTexts.bodySmall.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                UIHelpers.horizontalSpace(12),

                // Amount
                Text(
                  bill.amount.toStringAsFixed(2),
                  style: context.appTexts.bodyLarge.copyWith(
                    color: AppColors.expense,
                    fontWeight: FontWeight.w800,
                    fontSize: 17.sp,
                  ),
                ),
              ],
            ),
          ),

          // ── Divider ──────────────────────────────────────
          Divider(height: 1, thickness: 1, color: context.colors.border),

          // ── Action row ───────────────────────────────────
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit_outlined,
                      size: 16.sp, color: AppColors.primary),
                  label: Text(
                    'Edit',
                    style: context.appTexts.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 20.h,
                color: context.colors.border,
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline_rounded,
                      size: 16.sp, color: AppColors.expense),
                  label: Text(
                    'Delete',
                    style: context.appTexts.bodySmall.copyWith(
                      color: AppColors.expense,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
