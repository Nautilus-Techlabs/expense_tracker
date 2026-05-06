import 'package:expense_tracker/domain/entities/opening_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';

class SetOpeningBalanceSheet extends ConsumerStatefulWidget {
  const SetOpeningBalanceSheet({super.key});

  @override
  ConsumerState<SetOpeningBalanceSheet> createState() =>
      _SetOpeningBalanceSheetState();
}

class _SetOpeningBalanceSheetState
    extends ConsumerState<SetOpeningBalanceSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _accountController = TextEditingController();
  final _bankNameController = TextEditingController();
  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  BankAccount? _selectedExistingAccount;

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _bankNameController.dispose();
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
        // Default to start of day (00:00:00) so today's transactions are visible
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final bank =
          _selectedExistingAccount?.bankName ?? _bankNameController.text;
      final acc =
          _selectedExistingAccount?.accountNumber ?? _accountController.text;

      ref
          .read(transactionProvider.notifier)
          .setOpeningBalance(
            OpeningBalance(
              bankName: bank,
              accountNumber: acc,
              amount: double.parse(_amountController.text),
              date: _selectedDate,
            ),
          )
          .then((_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Opening balance updated!'),
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
    final state = ref.watch(transactionProvider);
    final accounts = state.getUniqueAccounts();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24.w,
        24.h,
        24.w,
        MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Set Opening Balance',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              UIHelpers.verticalSpace(16),

              // Existing Account Selection
              if (accounts.isNotEmpty) ...[
                Text(
                  'Select Account',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                UIHelpers.verticalSpace(8),
                SizedBox(
                  height: 40.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: accounts.length,
                    separatorBuilder: (_, _) => UIHelpers.horizontalSpace(8),
                    itemBuilder: (context, index) {
                      final acc = accounts[index];
                      final isSelected = _selectedExistingAccount == acc;
                      return ChoiceChip(
                        label: Text(acc.displayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedExistingAccount = selected ? acc : null;
                            if (selected) {
                              _bankNameController.text = "";
                              _accountController.text = "";
                            }
                          });
                        },
                        selectedColor: colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        backgroundColor: AppTheme.getSurfaceSecondaryColor(
                          context,
                        ),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12.sp,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
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
                    },
                  ),
                ),
                UIHelpers.verticalSpace(20),
              ],

              if (_selectedExistingAccount == null) ...[
                _buildTextField(
                  controller: _bankNameController,
                  label: 'Bank Name',
                  hint: 'e.g. HDFC Bank',
                  icon: Icons.account_balance_rounded,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                UIHelpers.verticalSpace(16),
                _buildTextField(
                  controller: _accountController,
                  label: 'Account Number (Last 4)',
                  hint: 'e.g. 1234',
                  icon: Icons.credit_card_rounded,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                UIHelpers.verticalSpace(16),
              ],

              _buildTextField(
                controller: _amountController,
                label: 'Opening Amount',
                hint: '0.00',
                icon: Icons.currency_rupee_rounded,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              UIHelpers.verticalSpace(16),

              Text(
                'As of Date',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              UIHelpers.verticalSpace(8),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.getSurfaceSecondaryColor(context),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppTheme.getBorderColor(context)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 18.sp,
                        color: colorScheme.primary,
                      ),
                      UIHelpers.horizontalSpace(12),
                      Text(
                        DateFormat('dd MMM, yyyy').format(_selectedDate),
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),
              ),
              UIHelpers.verticalSpace(32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save Opening Balance',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        UIHelpers.verticalSpace(8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.24),
            ),
            filled: true,
            fillColor: AppTheme.getSurfaceSecondaryColor(context),
            prefixIcon: Icon(
              icon,
              size: 18.sp,
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ],
    );
  }
}
