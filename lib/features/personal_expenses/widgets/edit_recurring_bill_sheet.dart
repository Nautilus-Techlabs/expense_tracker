import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/primary_button.dart';
import '../models/recurring_bill_model.dart';
import '../viewmodels/recurring_bill_notifier.dart';

class EditRecurringBillBottomSheet extends ConsumerStatefulWidget {
  final RecurringBillModel bill;

  const EditRecurringBillBottomSheet({
    super.key,
    required this.bill,
  });

  @override
  ConsumerState<EditRecurringBillBottomSheet> createState() =>
      _EditRecurringBillBottomSheetState();
}

class _EditRecurringBillBottomSheetState
    extends ConsumerState<EditRecurringBillBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late int _dayOfMonth;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.bill.title);
    _amountController =
        TextEditingController(text: widget.bill.amount.toStringAsFixed(2));
    _dayOfMonth = widget.bill.dayOfMonth;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid title and amount.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final updatedBill = widget.bill.copyWith(
      title: title,
      amount: amount,
      dayOfMonth: _dayOfMonth,
    );

    await ref
        .read(recurringBillNotifierProvider.notifier)
        .updateBill(updatedBill);

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recurring bill updated successfully.'),
          backgroundColor: AppColors.income,
        ),
      );
    }
  }

  Future<void> _confirmDelete() async {
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
          'Are you sure you want to delete "${widget.bill.title}"? You will no longer receive monthly reminders for it.',
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
          .deleteBill(widget.bill.id);
      if (mounted) {
        Navigator.pop(context);
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
    return Container(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            UIHelpers.verticalSpace(16),

            // Header Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Recurring Bill',
                  style: context.appTexts.headingMedium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.expense),
                  onPressed: _confirmDelete,
                ),
              ],
            ),
            UIHelpers.verticalSpace(20),

            // Title Field
            Text(
              'Bill Title / Description',
              style: context.appTexts.bodySmall.copyWith(
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            UIHelpers.verticalSpace(8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: context.colors.border),
              ),
              child: TextField(
                controller: _titleController,
                style: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textPrimary,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            UIHelpers.verticalSpace(16),

            // Amount Field
            Text(
              'Monthly Amount',
              style: context.appTexts.bodySmall.copyWith(
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            UIHelpers.verticalSpace(8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: context.colors.border),
              ),
              child: TextField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textPrimary,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixText: '\$ ',
                ),
              ),
            ),
            UIHelpers.verticalSpace(16),

            // Day of Month Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Repeat Day of Month',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                DropdownButton<int>(
                  value: _dayOfMonth,
                  dropdownColor: context.colors.card,
                  underline: const SizedBox.shrink(),
                  items: List.generate(31, (i) => i + 1)
                      .map(
                        (day) => DropdownMenuItem<int>(
                          value: day,
                          child: Text(
                            'Day $day',
                            style: context.appTexts.bodyMedium.copyWith(
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _dayOfMonth = val);
                    }
                  },
                ),
              ],
            ),
            UIHelpers.verticalSpace(28),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Save Changes',
                isLoading: _isSaving,
                onPressed: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
