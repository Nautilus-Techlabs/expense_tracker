import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../domain/entities/transaction.dart';
import '../viewmodels/transaction_notifier.dart';

class AddTransactionBottomSheet extends ConsumerStatefulWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  ConsumerState<AddTransactionBottomSheet> createState() => _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends ConsumerState<AddTransactionBottomSheet> {
  TransactionType _selectedType = TransactionType.debit; // 'debit' = Expense, 'credit' = Income, null = Withdrawal (mock)
  String _selectedCategory = 'Food';
  String _selectedAccount = 'HDFC Savings';
  final DateTime _selectedDate = DateTime.now();
  bool _addToCircle = false;
  
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final List<String> _categories = [
    'Food', 'Grocery', 'Rent', 'Utilities', 'Transport', 'Entertainment'
  ];

  final List<String> _accounts = [
    'HDFC Savings', 'ICICI Bank', 'Wallet', 'Credit Card'
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) return;

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;

    await ref.read(transactionProvider.notifier).addManualTransaction(
      amount: amount,
      type: _selectedType,
      date: _selectedDate,
      method: PaymentMethod.upi, // Default for now
      merchant: _selectedCategory, // Using category as merchant title for simplicity in UI
      description: _noteController.text.isNotEmpty ? _noteController.text : null,
      account: _selectedAccount,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _selectedType == TransactionType.debit ? AppColors.expense : AppColors.income;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          // Drag Handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          
          // Title & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add transaction',
                style: AppTexts.displayMedium.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                  fontSize: 28.sp,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, size: 24.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Segmented Control (Expense / Income / Withdrawal)
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Row(
              children: [
                _buildSegmentItem('Expense', TransactionType.debit, isDark),
                _buildSegmentItem('Income', TransactionType.credit, isDark),
                _buildSegmentItem('Withdrawal', null, isDark), // Mock third type
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  
                  // Amount Input
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('₹ ', style: AppTexts.displayLarge.copyWith(color: color, fontSize: 48.sp)),
                        IntrinsicWidth(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: AppTexts.displayLarge.copyWith(color: color, fontSize: 48.sp),
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: AppTexts.displayLarge.copyWith(color: color, fontSize: 48.sp),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // Categories
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 12.h,
                    children: _categories.map((c) => _buildChip(c, _selectedCategory == c, (val) {
                      setState(() => _selectedCategory = c);
                    }, isDark)).toList(),
                  ),
                  SizedBox(height: 32.h),

                  // Accounts
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 12.h,
                    children: _accounts.map((a) => _buildChip(a, _selectedAccount == a, (val) {
                      setState(() => _selectedAccount = a);
                    }, isDark)).toList(),
                  ),
                  SizedBox(height: 32.h),

                  // Date Row
                  _buildInputRow(
                    icon: Icons.calendar_today_outlined,
                    child: Text(
                      'Today, ${DateFormat('dd MMM').format(_selectedDate)}',
                      style: AppTexts.bodyLarge.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.primary),
                    ),
                    isDark: isDark,
                  ),

                  // Note Row
                  _buildInputRow(
                    icon: Icons.edit_outlined,
                    child: TextField(
                      controller: _noteController,
                      style: AppTexts.bodyLarge.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.primary),
                      decoration: InputDecoration(
                        hintText: 'Add a note (optional)',
                        hintStyle: AppTexts.bodyLarge.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    isDark: isDark,
                  ),
                  
                  // Add to Circle Toggle
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add to a Circle?',
                          style: AppTexts.bodyLarge.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          value: _addToCircle,
                          onChanged: (val) => setState(() => _addToCircle = val),
                          activeThumbColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h), // Bottom padding before button
                ],
              ),
            ),
          ),
          
          // Submit Button
          PrimaryButton(
            text: 'Save transaction',
            onPressed: _submit,
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildSegmentItem(String title, TransactionType? type, bool isDark) {
    final isSelected = _selectedType == type && type != null;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (type != null) {
            setState(() => _selectedType = type);
          }
        },
        child: Container(
          margin: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTexts.bodyMedium.copyWith(
              color: isSelected 
                  ? Colors.white 
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, ValueChanged<bool> onSelected, bool isDark) {
    return GestureDetector(
      onTap: () => onSelected(true),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: AppTexts.bodyMedium.copyWith(
            color: isSelected 
                ? Colors.white 
                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow({required IconData icon, required Widget child, required bool isDark}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          SizedBox(width: 16.w),
          Expanded(child: child),
        ],
      ),
    );
  }
}
