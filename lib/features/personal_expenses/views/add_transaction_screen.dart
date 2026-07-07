import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/transaction_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/common/app_choice_chip.dart';
import '../widgets/common/app_primary_button.dart';
import '../widgets/common/app_section_label.dart';
import '../widgets/common/app_text_field.dart';
import '../widgets/common/date_time_picker_row.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Keys for scrolling to error fields
  final _amountKey = GlobalKey();
  final _bankKey = GlobalKey();
  final _accountKey = GlobalKey();

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
    final state = ref.watch(transactionProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final accounts = state.getUniqueAccounts();

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
          final key = '${acc.accountNumber}|${acc.bankName}';
          final isSelected = _selectedAccountKey == key;
          return AppChoiceChip(
            label: '${acc.accountNumber} (${acc.bankName})',
            isSelected: isSelected,
            color: colorScheme.primary,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _selectedAccountKey = key;
                  _bankNameController.text = acc.bankName;
                  _accountController.text = acc.accountNumber;
                } else {
                  _selectedAccountKey = null;
                }
              });
            },
          );
        }),
        // "New" chip — always unselected visually when another account is active
        AppChoiceChip(
          label: '+ New',
          isSelected: _selectedAccountKey == null,
          color: colorScheme.primary,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedAccountKey = null;
                _bankNameController.clear();
                _accountController.clear();
              });
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _amountController.dispose();
    _merchantController.dispose();
    _descriptionController.dispose();
    _bankNameController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      _scrollToFirstError();
      return;
    }
    try {
      await ref
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
          );
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add transaction: $e'),
            backgroundColor: AppTheme.getExpenseColor(context),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _scrollToFirstError() {
    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null) {
      _scrollToKey(_amountKey);
    } else if (_bankNameController.text.trim().isEmpty) {
      _scrollToKey(_bankKey);
    } else if (_selectedAccountKey == null &&
        (_accountController.text.length != 4 ||
            int.tryParse(_accountController.text) == null)) {
      _scrollToKey(_accountKey);
    }
  }

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
        controller: _scrollController,
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Input
              KeyedSubtree(key: _amountKey, child: _buildAmountCard()),
              SizedBox(height: 32.h),

              // Transaction Type Toggle
              _buildTypeToggle(),
              SizedBox(height: 24.h),

              // Account Selection
              AppSectionLabel(
                text: 'Select Account',
                icon: Icons.account_balance_wallet_rounded,
              ),
              _buildAccountChips(),
              SizedBox(height: 24.h),

              // Merchant / Payee
              AppSectionLabel(
                text: 'Merchant / Payee',
                icon: Icons.storefront_rounded,
              ),
              AppTextField(
                controller: _merchantController,
                hint: 'Enter merchant name',
              ),
              SizedBox(height: 20.h),

              // Bank Name
              AppSectionLabel(
                text: 'Bank Name',
                icon: Icons.account_balance_rounded,
              ),
              AppTextField(
                controller: _bankNameController,
                hint: 'e.g. HDFC Bank, SBI',
                onChanged: (_) => setState(() => _selectedAccountKey = null),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Bank name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),

              // Payment Method + Account (last 4)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSectionLabel(
                          text: 'Payment Method',
                          icon: Icons.payments_rounded,
                        ),
                        DropdownButtonFormField<PaymentMethod>(
                          initialValue: _selectedMethod,
                          dropdownColor: Theme.of(context).cardColor,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: _dropdownDecoration(),
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
                        AppSectionLabel(
                          text: 'Account (Last 4)',
                          icon: Icons.credit_card_rounded,
                        ),
                        TextFormField(
                          key: _accountKey,
                          controller: _accountController,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: _dropdownDecoration().copyWith(
                            hintText: '8237',
                            counterText: '',
                          ),
                          onChanged: (_) =>
                              setState(() => _selectedAccountKey = null),
                          validator: (val) {
                            if (_selectedAccountKey == null) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Required';
                              }
                              if (val.length != 4 ||
                                  int.tryParse(val) == null) {
                                return 'Must be 4 digits';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Date & Time
              AppSectionLabel(
                text: 'Date & Time',
                icon: Icons.calendar_today_rounded,
              ),
              DateTimePickerRow(
                selectedDate: _selectedDate,
                onDateChanged: (d) => setState(() => _selectedDate = d),
                onTimeChanged: (d) => setState(() => _selectedDate = d),
              ),
              SizedBox(height: 24.h),

              // Category
              AppSectionLabel(text: 'Category', icon: Icons.category_rounded),
              _buildCategoryChips(),
              SizedBox(height: 24.h),

              // Description
              AppSectionLabel(
                text: 'Description',
                icon: Icons.description_rounded,
              ),
              AppTextField(
                controller: _descriptionController,
                hint: 'Add a note...',
                maxLines: 3,
              ),
              SizedBox(height: 40.h),

              // Submit Button
              AppPrimaryButton(label: 'Save Transaction', onPressed: _submit),
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

  /// Shared decoration for DropdownButtonFormField and plain TextFormField
  /// that need the same bordered fill style but aren't using AppTextField.
  InputDecoration _dropdownDecoration() {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
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
        AppChoiceChip(
          label: 'Uncategorized',
          isSelected: _selectedCategoryId == null,
          onSelected: (selected) {
            if (selected) setState(() => _selectedCategoryId = null);
          },
        ),
        ...state.categories.map((cat) {
          final isSelected = _selectedCategoryId == cat.id;
          final catColor = cat.color != null
              ? Color(cat.color!)
              : colorScheme.primary;
          return AppChoiceChip(
            label: cat.name,
            isSelected: isSelected,
            color: catColor,
            avatar: Icon(
              UIHelpers.getCategoryIcon(cat.icon),
              size: 14.sp,
              color: isSelected
                  ? catColor
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
            onSelected: (selected) {
              if (selected) setState(() => _selectedCategoryId = cat.id);
            },
          );
        }),
        AppChoiceChip(
          label: '+ Add',
          isSelected: false,
          onSelected: (_) => _showAddCategoryDialog(),
          color: colorScheme.primary,
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
        content: AppTextField(
          controller: controller,
          hint: 'Category Name',
          autofocus: true,
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
