import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../models/transaction_model.dart';
import '../models/transaction_payload.dart';
import '../viewmodels/account_notifier.dart';
import '../viewmodels/category_notifier.dart';
import '../viewmodels/transaction_notifier.dart';

class EditTransactionSheet extends ConsumerStatefulWidget {
  final TransactionModel transaction;
  final Function(TransactionModel) onSaved;

  const EditTransactionSheet({
    super.key,
    required this.transaction,
    required this.onSaved,
  });

  @override
  ConsumerState<EditTransactionSheet> createState() => _EditTransactionSheetState();
}

class _EditTransactionSheetState extends ConsumerState<EditTransactionSheet> {
  late TextEditingController _noteController;
  late TextEditingController _amountController;
  late String _selectedType;
  int? _selectedCategoryId;
  int? _selectedAccountId;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(
      text: widget.transaction.note ?? '',
    );
    _amountController = TextEditingController(
      text: widget.transaction.amount.toString(),
    );
    _selectedType = widget.transaction.type;
    _selectedCategoryId = widget.transaction.categoryId;
    _selectedAccountId = widget.transaction.accountId;
    _selectedDate = widget.transaction.txnDate;
  }

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Enter a valid amount'),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }

    final updates = TransactionPayload(
      userId: widget.transaction.userId,
      amount: amount,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      type: _selectedType,
      categoryId: _selectedCategoryId,
      accountId: _selectedAccountId!,
      txnDate: _selectedDate,
      isCircleTransaction: widget.transaction.isCircleTransaction,
      isReimbursement: widget.transaction.isReimbursement,
      isDeleted: widget.transaction.isDeleted,
      paidByUserId: widget.transaction.userId,
    );

    final success = await ref
        .read(transactionProvider.notifier)
        .updateTransaction(
          transactionId: widget.transaction.id,
          updates: updates,
        );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Transaction updated'),
            backgroundColor: AppColors.income,
          ),
        );
        context.pop();
        widget.onSaved(widget.transaction);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to update transaction'),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    }
  }

  Widget _buildTypeSegment(String label, String value, bool isDark) {
    final isSelected = _selectedType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = value),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF333333) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: isSelected && !isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.appTexts.bodyMedium.copyWith(
              color: isSelected
                  ? context.colors.textPrimary
                  : context.colors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);
    final accountState = ref.watch(accountProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grabber
              Center(
                child: Container(
                  width: 48.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              UIHelpers.verticalSpace(24),

              Text(
                'Edit Transaction',
                style: context.appTexts.displayMedium.copyWith(
                  color: context.colors.textPrimary,
                  fontSize: 24.sp,
                ),
              ),
              UIHelpers.verticalSpace(24),

              // Type Selector
              Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : const Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  children: [
                    _buildTypeSegment('Expense', 'expense', isDark),
                    _buildTypeSegment('Income', 'income', isDark),
                    _buildTypeSegment('Withdrawal', 'withdrawal', isDark),
                  ],
                ),
              ),
              UIHelpers.verticalSpace(24),

              // Amount
              _buildLabel('Amount', isDark),
              UIHelpers.verticalSpace(8),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textPrimary,
                ),
                decoration: _inputDecoration(isDark, 'e.g. 500'),
              ),
              UIHelpers.verticalSpace(20),

              // Note
              _buildLabel('Note', isDark),
              UIHelpers.verticalSpace(8),
              TextField(
                controller: _noteController,
                style: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textPrimary,
                ),
                decoration: _inputDecoration(
                  isDark,
                  'e.g. Groceries at D-Mart',
                ),
              ),
              UIHelpers.verticalSpace(20),

              // Date
              _buildLabel('Date', isDark),
              UIHelpers.verticalSpace(8),
              InkWell(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy').format(_selectedDate),
                        style: context.appTexts.bodyMedium.copyWith(
                          color: context.colors.textPrimary,
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 18.sp,
                        color: context.colors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              UIHelpers.verticalSpace(20),

              // Account dropdown
              _buildLabel('Account', isDark),
              UIHelpers.verticalSpace(8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: context.colors.card,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: context.colors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedAccountId,
                    isExpanded: true,
                    dropdownColor: context.colors.card,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                    items: accountState.accounts.map((acc) {
                      return DropdownMenuItem<int>(
                        value: acc.id,
                        child: Text(acc.name),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedAccountId = val),
                  ),
                ),
              ),
              UIHelpers.verticalSpace(20),

              // Category dropdown
              _buildLabel('Category', isDark),
              UIHelpers.verticalSpace(8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: context.colors.card,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: context.colors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int?>(
                    value: _selectedCategoryId,
                    isExpanded: true,
                    dropdownColor: context.colors.card,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                    hint: Text(
                      'Select category',
                      style: context.appTexts.bodyMedium.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(
                          'None',
                          style: context.appTexts.bodyMedium.copyWith(
                            color: context.colors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      ...categoryState.categories.map((cat) {
                        return DropdownMenuItem<int?>(
                          value: cat.id,
                          child: Text(cat.name),
                        );
                      }),
                    ],
                    onChanged: (val) =>
                        setState(() => _selectedCategoryId = val),
                  ),
                ),
              ),
              UIHelpers.verticalSpace(40),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ref.watch(transactionProvider).isLoading
                      ? null
                      : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    elevation: 0,
                  ),
                  child: ref.watch(transactionProvider).isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Save Changes',
                          style: context.appTexts.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: context.appTexts.bodySmall.copyWith(
        color: context.colors.textSecondary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: context.appTexts.bodyMedium.copyWith(
        color: context.colors.textSecondary.withValues(alpha: 0.5),
      ),
      filled: true,
      fillColor: context.colors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: context.colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: context.colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }
}
