import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../models/transaction_model.dart';
import '../viewmodels/transaction_notifier.dart';
import '../viewmodels/category_notifier.dart';
import '../viewmodels/account_notifier.dart';

class DetailedTransactionScreen extends ConsumerStatefulWidget {
  final TransactionModel transaction;
  final String? heroTag;

  const DetailedTransactionScreen({
    super.key,
    required this.transaction,
    this.heroTag,
  });

  @override
  ConsumerState<DetailedTransactionScreen> createState() =>
      _DetailedTransactionScreenState();
}

class _DetailedTransactionScreenState
    extends ConsumerState<DetailedTransactionScreen> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpense = widget.transaction.type == 'expense' || widget.transaction.type == 'withdrawal';
    final amountColor = isExpense ? AppColors.expense : AppColors.income;
    final bool isCircleTransaction = widget.transaction.isCircleTransaction;

    // Resolve category name
    final categories = ref.watch(categoryProvider).categories;
    final category = categories
        .where((c) => c.id == widget.transaction.categoryId)
        .firstOrNull;
    final categoryName = category?.name ?? 'Uncategorized';

    // Resolve account name
    final accounts = ref.watch(accountProvider).accounts;
    final account = accounts
        .where((a) => a.id == widget.transaction.accountId)
        .firstOrNull;
    final accountName = account?.name ?? 'Unknown Account';

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 20.sp,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Transaction detail',
          style: context.appTexts.heading.copyWith(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            UIHelpers.verticalSpace(32),

            // ── Hero Icon ──
            _buildHeroIcon(isCircleTransaction, amountColor),
            UIHelpers.verticalSpace(20),

            // ── Merchant Name ──
            Text(
              widget.transaction.note ?? 'Unknown',
              style: context.appTexts.displayMedium.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            UIHelpers.verticalSpace(8),

            // ── Amount ──
            Text(
              '₹${widget.transaction.amount}',
              style: context.appTexts.displayLarge.copyWith(
                color: amountColor,
                fontSize: 40.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            UIHelpers.verticalSpace(8),

            // ── Subtitle: Category · Type · Date ──
            Text(
              _buildSubtitle(categoryName),
              style: context.appTexts.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            UIHelpers.verticalSpace(32),

            // ── Details Card ──
            _buildDetailsCard(context, isCircleTransaction, isDark, accountName, categoryName),
            UIHelpers.verticalSpace(16),

            // ── Split Details Card (only for Circle transactions) ──
            if (isCircleTransaction) _buildSplitDetailsCard(context, isDark),
            UIHelpers.verticalSpace(32),

            // ── Action Buttons ──
            _buildActionButtons(context, isDark),
            UIHelpers.verticalSpace(40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroIcon(bool isCircleTransaction, Color amountColor) {
    final bgColor = isCircleTransaction ? AppColors.income : amountColor;
    final icon = isCircleTransaction ? Icons.group_rounded : _getCategoryIcon();

    return Hero(
      tag: widget.heroTag ?? 'tx_detail_${widget.transaction.id}',
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 36.sp),
      ),
    );
  }

  Widget _buildDetailsCard(
    BuildContext context,
    bool isCircleTransaction,
    bool isDark,
    String accountName,
    String categoryName,
  ) {
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: _formatDate(widget.transaction.txnDate),
            isDark: isDark,
            showDivider: true,
          ),
          _buildDetailRow(
            icon: Icons.account_balance_outlined,
            label: 'Account',
            value: accountName,
            isDark: isDark,
            showDivider: true,
          ),
          if (!isCircleTransaction) ...[
            _buildDetailRow(
              icon: Icons.label_outline_rounded,
              label: 'Category',
              value: categoryName,
              isDark: isDark,
              showDivider: true,
            ),
            _buildDetailRow(
              icon: Icons.edit_outlined,
              label: 'Note',
              value: widget.transaction.note ?? '—',
              isDark: isDark,
              showDivider: true,
            ),
          ],
          _buildDetailRow(
            icon: Icons.swap_vert_rounded,
            label: 'Type',
            value: widget.transaction.type[0].toUpperCase() + widget.transaction.type.substring(1),
            isDark: isDark,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    required bool showDivider,
    Color? valueColor,
    bool isItalic = false,
  }) {
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final labelColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final resolvedValueColor =
        valueColor ??
        (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              Icon(icon, size: 22.sp, color: labelColor),
              UIHelpers.horizontalSpace(14),
              Text(
                label,
                style: context.appTexts.bodyMedium.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: context.appTexts.bodyMedium.copyWith(
                    color: resolvedValueColor,
                    fontWeight: FontWeight.w600,
                    fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: borderColor,
            indent: 20.w,
            endIndent: 20.w,
          ),
      ],
    );
  }

  Widget _buildSplitDetailsCard(BuildContext context, bool isDark) {
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Text(
          'Circle split details coming soon.',
          style: context.appTexts.bodyMedium.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Row(
      children: [
        // Edit button
        Expanded(
          child: OutlinedButton(
            onPressed: () => _showEditSheet(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.primary,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: Text(
              'Edit transaction',
              style: context.appTexts.bodyMedium.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        UIHelpers.horizontalSpace(16),
        // Delete button
        Expanded(
          child: OutlinedButton(
            onPressed: _isDeleting ? null : () => _handleDelete(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.expense, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: _isDeleting
                ? SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.expense,
                    ),
                  )
                : Text(
                    'Delete',
                    style: context.appTexts.bodyMedium.copyWith(
                      color: AppColors.expense,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _EditTransactionSheet(
        transaction: widget.transaction,
        onSaved: (updatedTx) {
          // The state is already updated by the notifier,
          // but we need to pop back since the detail screen
          // was created with the old object.
          if (mounted) {
            context.pop(); // pop detail screen to go back to list
          }
        },
      ),
    );
  }

  String _buildSubtitle(String categoryName) {
    String typeLabel = 'Expense';
    if (widget.transaction.type == 'income') {
      typeLabel = 'Income';
    } else if (widget.transaction.type == 'withdrawal') {
      typeLabel = 'Withdrawal';
    }
    final when = _timeLabel(widget.transaction.txnDate);
    return '$categoryName · $typeLabel · $when';
  }

  String _timeLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return 'Today';
    if (d == yesterday) return 'Yesterday';
    return DateFormat('dd MMM').format(date);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final prefix = d == today ? 'Today, ' : '';
    return '$prefix${DateFormat('dd MMM yyyy').format(date)}';
  }

  IconData _getCategoryIcon() {
    return Icons.receipt_long_rounded;
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark
            : AppColors.cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text('Delete Transaction', style: context.appTexts.heading),
        content: Text(
          'Are you sure you want to delete this transaction? This cannot be undone.',
          style: context.appTexts.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: context.appTexts.bodyMedium.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textPrimaryDark
                    : AppColors.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.expense,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Delete',
              style: context.appTexts.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      setState(() => _isDeleting = true);
      final success = await ref
          .read(transactionProvider.notifier)
          .deleteTransaction(widget.transaction.id);

      if (mounted) {
        setState(() => _isDeleting = false);
        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Transaction deleted'),
              backgroundColor: AppColors.income,
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to delete transaction'),
              backgroundColor: AppColors.expense,
            ),
          );
        }
      }
    }
  }
}

// ─── Edit Transaction Bottom Sheet ───
class _EditTransactionSheet extends ConsumerStatefulWidget {
  final TransactionModel transaction;
  final Function(TransactionModel) onSaved;

  const _EditTransactionSheet({
    required this.transaction,
    required this.onSaved,
  });

  @override
  ConsumerState<_EditTransactionSheet> createState() => _EditTransactionSheetState();
}

class _EditTransactionSheetState extends ConsumerState<_EditTransactionSheet> {
  late TextEditingController _noteController;
  late TextEditingController _amountController;
  late String _selectedType;
  String? _selectedCategoryId;
  String? _selectedAccountId;
  late DateTime _selectedDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.transaction.note ?? '');
    _amountController = TextEditingController(text: widget.transaction.amount.toString());
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

    setState(() => _isSaving = true);

    final updates = <String, dynamic>{
      'amount': amount,
      'note': _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      'type': _selectedType,
      'category_id': _selectedCategoryId,
      'account_id': _selectedAccountId,
      'txn_date': _selectedDate.toIso8601String(),
    };

    final success = await ref.read(transactionProvider.notifier).updateTransaction(
          transactionId: widget.transaction.id,
          updates: updates,
        );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Transaction updated'),
            backgroundColor: AppColors.income,
          ),
        );
        context.pop(); // close sheet
        widget.onSaved(widget.transaction); // trigger callback
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
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.appTexts.bodyMedium.copyWith(
              color: isSelected
                  ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryState = ref.watch(categoryProvider);
    final accountState = ref.watch(accountProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
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
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              UIHelpers.verticalSpace(24),

              Text(
                'Edit Transaction',
                style: context.appTexts.displayMedium.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: context.appTexts.bodyMedium.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
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
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                decoration: _inputDecoration(isDark, 'e.g. Groceries at D-Mart'),
              ),
              UIHelpers.verticalSpace(20),

              // Date
              _buildLabel('Date', isDark),
              UIHelpers.verticalSpace(8),
              InkWell(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy').format(_selectedDate),
                        style: context.appTexts.bodyMedium.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      Icon(Icons.calendar_today_rounded, size: 18.sp,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
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
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedAccountId,
                    isExpanded: true,
                    dropdownColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    items: accountState.accounts.map((acc) {
                      return DropdownMenuItem(
                        value: acc.id,
                        child: Text(acc.name),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedAccountId = val),
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
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: _selectedCategoryId,
                    isExpanded: true,
                    dropdownColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    hint: Text(
                      'Select category',
                      style: context.appTexts.bodyMedium.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(
                          'None',
                          style: context.appTexts.bodyMedium.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      ...categoryState.categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat.id,
                          child: Text(cat.name),
                        );
                      }),
                    ],
                    onChanged: (val) => setState(() => _selectedCategoryId = val),
                  ),
                ),
              ),
              UIHelpers.verticalSpace(40),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
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
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: context.appTexts.bodyMedium.copyWith(
        color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
            .withValues(alpha: 0.5),
      ),
      filled: true,
      fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }
}
