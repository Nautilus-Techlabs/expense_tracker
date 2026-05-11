import 'package:expense_tracker/domain/entities/opening_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';

class SetOpeningBalanceSheet extends ConsumerStatefulWidget {
  final BankAccount? initialAccount;
  final bool isFixed;
  const SetOpeningBalanceSheet({
    super.key,
    this.initialAccount,
    this.isFixed = false,
  });

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
  bool _isFromTransaction = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialAccount != null) {
      _selectedExistingAccount = widget.initialAccount;
      // Auto-fill amount if it already exists
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = ref.read(transactionProvider);
        final existing = state.openingBalances.where(
          (ob) =>
              ob.bankName == widget.initialAccount!.bankName &&
              ob.accountNumber == widget.initialAccount!.accountNumber,
        );
        if (existing.isNotEmpty) {
          _amountController.text = existing.first.amount.toStringAsFixed(0);
        }
      });
    }
  }

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
        _isFromTransaction = false;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final bank =
          _selectedExistingAccount?.bankName ?? _bankNameController.text;
      final acc =
          _selectedExistingAccount?.accountNumber ?? _accountController.text;
      final amount = double.parse(_amountController.text);

      if (!_isFromTransaction) {
        final state = ref.read(transactionProvider);
        final potentialDuplicate = state.allTransactions.where((t) {
          final sameAccount = t.bankName == bank && t.account == acc;
          final sameAmount =
              (t.availableBalance != null &&
                  (t.availableBalance! - amount).abs() < 0.1) ||
              (t.amount - amount).abs() < 0.1;
          final sameDay =
              t.date.year == _selectedDate.year &&
              t.date.month == _selectedDate.month &&
              t.date.day == _selectedDate.day;
          return sameAccount && sameAmount && sameDay;
        }).toList();

        if (potentialDuplicate.isNotEmpty) {
          _showDuplicateDialog(bank, acc, amount, potentialDuplicate.first);
          return;
        }
      }

      _doSubmit(bank, acc, amount, _selectedDate);
    }
  }

  void _showDuplicateDialog(
    String bank,
    String acc,
    double amount,
    Transaction existingTx,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Potential Duplicate'),
        content: Text(
          'A transaction with the same amount (₹$amount) and date already exists for this account. '
          'Should this transaction be treated as the initial balance, or should the initial balance be added separately?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _doSubmit(bank, acc, amount, _selectedDate);
            },
            child: const Text('Add Separately'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _doSubmit(bank, acc, amount, existingTx.date);
            },
            child: const Text('Use Existing Transaction'),
          ),
        ],
      ),
    );
  }

  void _doSubmit(String bank, String acc, double amount, DateTime date) {
    ref
        .read(transactionProvider.notifier)
        .setOpeningBalance(
          OpeningBalance(
            bankName: bank,
            accountNumber: acc,
            amount: double.parse(_amountController.text),
            date: date,
          ),
        )
        .then((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening balance for $bank updated!'),
                backgroundColor: AppTheme.getIncomeColor(context),
                behavior: SnackBarBehavior.floating,
              ),
            );

            if (widget.isFixed) {
              Navigator.pop(context);
            } else {
              setState(() {
                _amountController.clear();
                _selectedExistingAccount = null;
                _bankNameController.clear();
                _accountController.clear();
                _isFromTransaction = false;
              });
            }
          }
        });
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

  Widget _buildRecentTransactionsLinker(TransactionState state) {
    final bank = widget.initialAccount?.bankName;
    final acc = widget.initialAccount?.accountNumber;
    
    final txs = state.allTransactions
        .where((t) => t.bankName == bank && t.account == acc)
        .where((t) => t.availableBalance != null)
        .take(5)
        .toList();

    if (txs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel('Link to Transaction (Recommended)', Icons.link_rounded),
        UIHelpers.verticalSpace(8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.getSurfaceSecondaryColor(context),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppTheme.getBorderColor(context)),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: txs.length,
            separatorBuilder: (_, _) => Divider(height: 1, color: AppTheme.getBorderColor(context)),
            itemBuilder: (context, index) {
              final t = txs[index];
              final isSelected = t.date == _selectedDate;
              return ListTile(
                onTap: () {
                  setState(() {
                    _selectedDate = t.date;
                    _amountController.text = t.availableBalance!.toStringAsFixed(0);
                  });
                },
                dense: true,
                selected: isSelected,
                selectedTileColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                leading: Icon(
                  isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: isSelected ? Theme.of(context).colorScheme.primary : AppTheme.getNeutralColor(context),
                  size: 20.sp,
                ),
                title: Text(
                  'Balance: ₹${t.availableBalance!.toStringAsFixed(0)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                ),
                subtitle: Text(
                  DateFormat('dd MMM, hh:mm a').format(t.date),
                  style: TextStyle(fontSize: 11.sp),
                ),
              );
            },
          ),
        ),
        UIHelpers.verticalSpace(4),
        Text(
          'Linking ensures the opening balance starts exactly after this message.',
          style: TextStyle(
            fontSize: 10.sp,
            color: AppTheme.getNeutralColor(context),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: AppTheme.getNeutralColor(context)),
          UIHelpers.horizontalSpace(8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.getNeutralColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard() {
    return _buildTextField(
      controller: _amountController,
      label: 'Opening Amount',
      hint: '0.00',
      icon: Icons.currency_rupee_rounded,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    );
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
                    widget.isFixed ? 'Set Balance' : 'Set Opening Balance',
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

              if (widget.isFixed && widget.initialAccount != null) ...[
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance_rounded,
                        color: colorScheme.primary,
                        size: 20.sp,
                      ),
                      UIHelpers.horizontalSpace(12),
                      Expanded(
                        child: Text(
                          widget.initialAccount!.displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                UIHelpers.verticalSpace(20),
              ] else if (accounts.isNotEmpty) ...[
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
                      final hasBalance = state.openingBalances.any(
                        (ob) =>
                            ob.bankName == acc.bankName &&
                            ob.accountNumber == acc.accountNumber,
                      );
                      return ChoiceChip(
                        avatar: hasBalance
                            ? Icon(
                                Icons.check_circle_rounded,
                                size: 16.sp,
                                color: Colors.green,
                              )
                            : null,
                        label: Text(acc.displayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedExistingAccount = selected ? acc : null;
                            if (selected) {
                              _bankNameController.text = "";
                              _accountController.text = "";
                              final existing = state.openingBalances.where(
                                (ob) =>
                                    ob.bankName == acc.bankName &&
                                    ob.accountNumber == acc.accountNumber,
                              );
                              if (existing.isNotEmpty) {
                                _amountController.text = existing.first.amount
                                    .toStringAsFixed(0);
                              } else {
                                _amountController.clear();
                              }
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

              KeyedSubtree(key: const ValueKey('amount_input'), child: _buildAmountCard()),
              UIHelpers.verticalSpace(24),

              _buildInputLabel('Effective Date & Time', Icons.calendar_today_rounded),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: AppTheme.getSurfaceSecondaryColor(context),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppTheme.getBorderColor(context)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month_rounded, size: 18.sp, color: colorScheme.primary),
                            UIHelpers.horizontalSpace(8),
                            Text(
                              DateFormat('dd MMM, yyyy').format(_selectedDate),
                              style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  UIHelpers.horizontalSpace(12),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: AppTheme.getSurfaceSecondaryColor(context),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppTheme.getBorderColor(context)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 18.sp, color: colorScheme.primary),
                            UIHelpers.horizontalSpace(8),
                            Text(
                              DateFormat('hh:mm a').format(_selectedDate),
                              style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              UIHelpers.verticalSpace(24),

              if (widget.initialAccount != null) ...[
                _buildRecentTransactionsLinker(state),
                UIHelpers.verticalSpace(24),
              ],

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