import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../services/connectivity_provider.dart';
import '../../auth/viewmodels/auth_notifier.dart';
import '../models/transaction_payload.dart';
import '../viewmodels/account_notifier.dart';
import '../viewmodels/category_notifier.dart';
import '../viewmodels/transaction_notifier.dart';

class AddTransactionBottomSheet extends ConsumerStatefulWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  ConsumerState<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState
    extends ConsumerState<AddTransactionBottomSheet> {
  // Transaction type: 'expense', 'income'
  String _selectedType = 'expense';
  int? _selectedCategoryId;
  int? _selectedAccountId;
  DateTime _selectedDate = DateTime.now();
  bool _accountError = false; // shows inline error when no account selected
  bool _amountError = false; // shows inline error when no amount entered

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
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

  Future<void> _submit() async {
    final isOnline = ref.read(connectivityStreamProvider).value ?? false;
    if (!isOnline) {
      _showError('You are currently offline. Operations are disabled.');
      return;
    }

    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText);

    // Run all validations first
    final bool hasAmountError =
        amountText.isEmpty || amount == null || amount <= 0;
    final bool hasAccountError = _selectedAccountId == null;

    if (hasAmountError || hasAccountError) {
      setState(() {
        _amountError = hasAmountError;
        _accountError = hasAccountError;
      });
      if (hasAmountError) {
        _showError('Please enter a valid amount.');
      } else if (hasAccountError) {
        _showError('Please select an account to continue.');
      }
      return;
    }

    // Clear errors
    setState(() {
      _amountError = false;
      _accountError = false;
    });

    final user = ref.read(authProvider).user;
    if (user == null) return;

    final payload = TransactionPayload(
      userId: user.id,
      accountId: _selectedAccountId!,
      categoryId: _selectedCategoryId,
      type: _selectedType,
      amount: amount,
      note: _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : null,
      txnDate: _selectedDate,
      isCircleTransaction: false,
      isReimbursement: false,
      isDeleted: false,
    );

    final success = await ref
        .read(transactionProvider.notifier)
        .addTransaction(payload);

    if (success && mounted) {
      Navigator.pop(context);
    } else if (!success && mounted) {
      final error = ref.read(transactionProvider).errorMessage;
      _showError(error ?? 'Failed to save transaction. Try again.');
    }
  }

  void _showError(String message) {
    // Use rootScaffoldMessenger so the SnackBar appears above the bottom sheet
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.expense,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpense = _selectedType == 'expense';
    final accentColor = isExpense ? AppColors.expense : AppColors.income;

    final accountState = ref.watch(accountProvider);
    final categoryState = ref.watch(categoryProvider);
    final txState = ref.watch(transactionProvider);

    // Filter categories by type using provider
    final filteredCategories = ref.watch(
      categoriesByTypeProvider(_selectedType),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UIHelpers.verticalSpace(12),

          // Drag Handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          UIHelpers.verticalSpace(24),

          // Title & Close
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add transaction',
                style: context.appTexts.displayMedium.copyWith(
                  color: context.colors.primary,
                  fontSize: 26.sp,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: 24.sp,
                  color: context.colors.textSecondary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          UIHelpers.verticalSpace(16),

          // Expense / Income Segmented Control
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Row(
              children: [
                _buildSegment('Expense', 'expense', isDark),
                _buildSegment('Income', 'income', isDark),
              ],
            ),
          ),
          UIHelpers.verticalSpace(4),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIHelpers.verticalSpace(32),

                  // ── Amount Input ──
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '₹ ',
                          style: context.appTexts.displayLarge.copyWith(
                            color: _amountError
                                ? AppColors.expense
                                : accentColor,
                            fontSize: 48.sp,
                          ),
                        ),
                        IntrinsicWidth(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            autofocus: false,
                            style: context.appTexts.displayLarge.copyWith(
                              color: _amountError
                                  ? AppColors.expense
                                  : accentColor,
                              fontSize: 48.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: context.appTexts.displayLarge.copyWith(
                                color: _amountError
                                    ? AppColors.expense.withValues(alpha: 0.5)
                                    : accentColor.withValues(alpha: 0.4),
                                fontSize: 48.sp,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  UIHelpers.verticalSpace(40),

                  // ── Category Section ──
                  _buildSectionLabel('Category', isDark),
                  UIHelpers.verticalSpace(12),
                  if (categoryState.isLoading)
                    _buildLoadingChips()
                  else if (filteredCategories.isEmpty)
                    Text(
                      'No categories available.',
                      style: context.appTexts.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 10.h,
                      children: filteredCategories
                          .map(
                            (cat) => _buildChip(
                              label: cat.name,
                              isSelected: _selectedCategoryId == cat.id,
                              onTap: () =>
                                  setState(() => _selectedCategoryId = cat.id),
                              isDark: isDark,
                            ),
                          )
                          .toList(),
                    ),
                  UIHelpers.verticalSpace(32),

                  // ── Account Section ──
                  _buildSectionLabel(
                    'Account',
                    isDark,
                    hasError: _accountError,
                  ),
                  UIHelpers.verticalSpace(12),
                  if (accountState.isLoading)
                    _buildLoadingChips()
                  else if (accountState.accounts.isEmpty)
                    Text(
                      'No accounts found. Please add an account first.',
                      style: context.appTexts.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 10.h,
                      children: accountState.accounts
                          .map(
                            (acc) => _buildChip(
                              label: acc.name,
                              isSelected: _selectedAccountId == acc.id,
                              onTap: () =>
                                  setState(() => _selectedAccountId = acc.id),
                              isDark: isDark,
                            ),
                          )
                          .toList(),
                    ),
                  UIHelpers.verticalSpace(32),

                  // ── Date Row ──
                  _buildInputRow(
                    icon: Icons.calendar_today_outlined,
                    isDark: isDark,
                    onTap: _pickDate,
                    child: Text(
                      _formatDate(_selectedDate),
                      style: context.appTexts.bodyLarge.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ),

                  // ── Note Row ──
                  _buildInputRow(
                    icon: Icons.edit_outlined,
                    isDark: isDark,
                    child: TextField(
                      controller: _noteController,
                      style: context.appTexts.bodyLarge.copyWith(
                        color: context.colors.primary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add a note (optional)',
                        hintStyle: context.appTexts.bodyLarge.copyWith(
                          color: context.colors.textSecondary,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  // ── Add to Circle Toggle (HIDDEN for now) ──
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 24.h),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         'Add to a Circle?',
                  //         style: context.appTexts.bodyLarge.copyWith(
                  //           color: context.colors.primary,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //       Switch(
                  //         value: _addToCircle,
                  //         onChanged: (val) => setState(() => _addToCircle = val),
                  //         activeThumbColor: AppColors.primary,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  UIHelpers.verticalSpace(32),
                ],
              ),
            ),
          ),

          // ── Submit Button ──
          Center(
            child: SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Save transaction',
                isLoading: txState.isLoading,
                onPressed: _submit,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 24.h),
        ],
      ),
    );
  }

  // ── Helpers ──

  Widget _buildSegment(String label, String type, bool isDark) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedType = type;
          _selectedCategoryId = null; // reset category on type change
        }),
        child: Container(
          margin: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.appTexts.bodyMedium.copyWith(
              color: isSelected ? Colors.white : (context.colors.textSecondary),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : (context.colors.border),
          ),
        ),
        child: Text(
          label,
          style: context.appTexts.bodyMedium.copyWith(
            color: isSelected ? Colors.white : (context.colors.textPrimary),
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(
    String label,
    bool isDark, {
    bool hasError = false,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: context.appTexts.bodySmall.copyWith(
            color: hasError
                ? AppColors.expense
                : (context.colors.textSecondary),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        if (hasError) ...[
          UIHelpers.horizontalSpace(8),
          Icon(
            Icons.error_outline_rounded,
            size: 14.sp,
            color: AppColors.expense,
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingChips() {
    return Wrap(
      spacing: 8.w,
      children: List.generate(
        4,
        (i) => Container(
          width: 72.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow({
    required IconData icon,
    required Widget child,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    final row = Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.colors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24.sp, color: context.colors.textSecondary),
          UIHelpers.horizontalSpace(16),
          Expanded(child: child),
        ],
      ),
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: row);
    }
    return row;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today, ${DateFormat('dd MMM').format(date)}';
    final yesterday = today.subtract(const Duration(days: 1));
    if (d == yesterday) {
      return 'Yesterday, ${DateFormat('dd MMM').format(date)}';
    }
    return DateFormat('EEE, dd MMM yyyy').format(date);
  }
}
