import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../core/utils/ui_helpers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_notifier.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TransactionType _selectedType = TransactionType.debit;
  PaymentMethod _selectedMethod = PaymentMethod.upi;
  String? _selectedAccountKey;
  int? _selectedCategoryId;

  Widget _buildAccountChips() {
    final transactions = ref.watch(transactionProvider).allTransactions;
    final colorScheme = Theme.of(context).colorScheme;

    // Extract unique accounts
    final seen = <String>{};
    final accounts = <({String account, String bank})>[];

    for (final t in transactions) {
      if (t.account != null && t.account!.isNotEmpty) {
        final key = '${t.account}|${t.bankName}';
        if (!seen.contains(key)) {
          seen.add(key);
          accounts.add((account: t.account!, bank: t.bankName));
        }
      }
    }

    if (accounts.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(
          'No existing accounts found. Add manually below.',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
            fontSize: 12.sp,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        ...accounts.map((acc) {
          final key = '${acc.account}|${acc.bank}';
          final isSelected = _selectedAccountKey == key;

          return ChoiceChip(
            label: Text('${acc.account} (${acc.bank})'),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _selectedAccountKey = key;
                  _bankNameController.text = acc.bank;
                  // Remove 'XX' prefix if present for editing,
                  // but keep it if it's the standard format.
                  // Actually, the user should see what's in the DB.
                  _accountController.text = acc.account;
                } else {
                  _selectedAccountKey = null;
                }
              });
            },
            selectedColor: colorScheme.primary.withValues(alpha: 0.12),
            backgroundColor: AppTheme.getSurfaceSecondaryColor(context),
            labelStyle: TextStyle(
              color: isSelected
                  ? colorScheme.primary
                  : Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide(
                color: isSelected
                    ? colorScheme.primary
                    : AppTheme.getBorderColor(context),
              ),
            ),
          );
        }),
        // "New" chip
        ChoiceChip(
          label: const Text('+ New'),
          selected: _selectedAccountKey == null,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedAccountKey = null;
                _bankNameController.clear();
                _accountController.clear();
              });
            }
          },
          selectedColor: colorScheme.primary.withValues(alpha: 0.12),
          backgroundColor: AppTheme.getSurfaceSecondaryColor(context),
          labelStyle: TextStyle(
            color: _selectedAccountKey == null
                ? colorScheme.primary
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 12.sp,
            fontWeight: _selectedAccountKey == null
                ? FontWeight.bold
                : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(
              color: _selectedAccountKey == null
                  ? colorScheme.primary
                  : AppTheme.getBorderColor(context),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _descriptionController.dispose();
    _bankNameController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: isDark ? Colors.black : Colors.white,
              surface: isDark ? const Color(0xFF1A1C1E) : Colors.white,
              onSurface: isDark ? Colors.white : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDate.hour,
          _selectedDate.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(transactionProvider.notifier)
          .addManualTransaction(
            amount: double.parse(_amountController.text),
            type: _selectedType,
            date: _selectedDate,
            method: _selectedMethod,
            bankName: _bankNameController.text.isEmpty
                ? null
                : _bankNameController.text,
            merchant: _merchantController.text.isEmpty
                ? null
                : _merchantController.text,
            account: _accountController.text.isEmpty
                ? null
                : (_accountController.text.length == 4 &&
                        RegExp(r'^\d+$').hasMatch(_accountController.text))
                    ? 'XX${_accountController.text}'
                    : _accountController.text,
            description: _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
            categoryId: _selectedCategoryId,
          )
          .then((_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Transaction added successfully!'),
                  backgroundColor: AppTheme.getIncomeColor(context),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pop(context);
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Add Transaction',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Input
              _buildAmountCard(),
              SizedBox(height: 32.h),

              // Transaction Type Toggle
              _buildTypeToggle(),
              SizedBox(height: 24.h),

              // Account Selection
              _buildInputLabel(
                'Select Account',
                Icons.account_balance_wallet_rounded,
              ),
              _buildAccountChips(),
              SizedBox(height: 24.h),

              // Main Fields
              _buildInputLabel('Merchant / Payee', Icons.storefront_rounded),
              TextFormField(
                controller: _merchantController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: _inputDecoration('Enter merchant name'),
              ),
              SizedBox(height: 20.h),

              _buildInputLabel('Bank Name', Icons.account_balance_rounded),
              TextFormField(
                controller: _bankNameController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: _inputDecoration('e.g. HDFC Bank, SBI'),
                onChanged: (_) => setState(() => _selectedAccountKey = null),
              ),
              SizedBox(height: 20.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel(
                          'Payment Method',
                          Icons.payments_rounded,
                        ),
                        DropdownButtonFormField<PaymentMethod>(
                          initialValue: _selectedMethod,
                          dropdownColor: Theme.of(context).cardColor,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: _inputDecoration(''),
                          items: PaymentMethod.values.map((m) {
                            return DropdownMenuItem(
                              value: m,
                              child: Text(m.name.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _selectedMethod = val!),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel(
                          'Account (Last 4)',
                          Icons.credit_card_rounded,
                        ),
                        TextFormField(
                          controller: _accountController,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: _inputDecoration(
                            '8237',
                          ).copyWith(counterText: ""),
                          onChanged: (_) =>
                              setState(() => _selectedAccountKey = null),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              _buildInputLabel('Date & Time', Icons.calendar_today_rounded),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.getSurfaceSecondaryColor(context),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppTheme.getBorderColor(context),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              size: 18.sp,
                              color: colorScheme.primary,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              DateFormat('dd MMM, yyyy').format(_selectedDate),
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.getSurfaceSecondaryColor(context),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppTheme.getBorderColor(context),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 18.sp,
                              color: colorScheme.primary,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              DateFormat('hh:mm a').format(_selectedDate),
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              _buildInputLabel('Category', Icons.category_rounded),
              _buildCategoryChips(),
              SizedBox(height: 24.h),

              _buildInputLabel('Description', Icons.description_rounded),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: _inputDecoration('Add a note...'),
              ),
              SizedBox(height: 40.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save Transaction',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            'Amount',
            style: TextStyle(
              color: colorScheme.primary.withValues(alpha: 0.7),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₹',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4.w),
              IntrinsicWidth(
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.24),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (double.tryParse(val) == null) return 'Invalid';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Row(
      children: [
        _TypeButton(
          label: 'Expense',
          icon: Icons.arrow_outward_rounded,
          isSelected: _selectedType == TransactionType.debit,
          color: AppTheme.getExpenseColor(context),
          onTap: () => setState(() => _selectedType = TransactionType.debit),
        ),
        SizedBox(width: 12.w),
        _TypeButton(
          label: 'Income',
          icon: Icons.south_west_rounded,
          isSelected: _selectedType == TransactionType.credit,
          color: AppTheme.getIncomeColor(context),
          onTap: () => setState(() => _selectedType = TransactionType.credit),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: colorScheme.onSurface.withValues(alpha: 0.24),
      ),
      filled: true,
      fillColor: AppTheme.getSurfaceSecondaryColor(context),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppTheme.getBorderColor(context)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppTheme.getBorderColor(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.5),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    );
  }

  Widget _buildCategoryChips() {
    final state = ref.watch(transactionProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        ChoiceChip(
          label: const Text('Uncategorized'),
          selected: _selectedCategoryId == null,
          onSelected: (selected) {
            if (selected) setState(() => _selectedCategoryId = null);
          },
          showCheckmark: false,
          selectedColor: colorScheme.primary.withValues(alpha: 0.12),
          backgroundColor: AppTheme.getSurfaceSecondaryColor(context),
          labelStyle: TextStyle(
            color: _selectedCategoryId == null
                ? colorScheme.primary
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 12.sp,
            fontWeight: _selectedCategoryId == null
                ? FontWeight.bold
                : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(
              color: _selectedCategoryId == null
                  ? colorScheme.primary
                  : AppTheme.getBorderColor(context),
            ),
          ),
        ),
        ...state.categories.map((cat) {
          final isSelected = _selectedCategoryId == cat.id;
          final catColor = cat.color != null
              ? Color(cat.color!)
              : colorScheme.primary;

          return ChoiceChip(
            label: Text(cat.name),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) setState(() => _selectedCategoryId = cat.id);
            },
            showCheckmark: false,
            selectedColor: colorScheme.primary.withValues(alpha: 0.12),
            backgroundColor: AppTheme.getSurfaceSecondaryColor(context),
            avatar: Icon(
              UIHelpers.getCategoryIcon(cat.icon),
              size: 14.sp,
              color: isSelected
                  ? catColor
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
            labelStyle: TextStyle(
              color: isSelected
                  ? catColor
                  : Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide(
                color: isSelected ? catColor : AppTheme.getBorderColor(context),
              ),
            ),
          );
        }),
        ChoiceChip(
          label: const Text('+ Add'),
          selected: false,
          onSelected: (_) => _showAddCategoryDialog(),
          backgroundColor: AppTheme.getSurfaceSecondaryColor(context),
          labelStyle: TextStyle(
            color: colorScheme.primary,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Future<void> _showAddCategoryDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'New Category',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: _inputDecoration('Category Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final id = await ref
          .read(transactionProvider.notifier)
          .addCategory(result);
      if (id != null) {
        setState(() => _selectedCategoryId = id);
      }
    }
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.1)
                : AppTheme.getSurfaceSecondaryColor(context),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? color.withValues(alpha: 0.4)
                  : AppTheme.getBorderColor(context),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: isSelected
                    ? color
                    : Theme.of(context).textTheme.bodySmall?.color,
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
