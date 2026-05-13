import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_notifier.dart';
import '../widgets/common/app_choice_chip.dart';
import '../widgets/common/app_primary_button.dart';
import '../widgets/common/app_section_label.dart';
import '../widgets/transaction_ui_components.dart';

class DetailedTransactionScreen extends ConsumerStatefulWidget {
  final Transaction transaction;
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
  late PaymentMethod _selectedMethod;
  late TextEditingController _accountController;
  late TextEditingController _bankController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _merchantController;
  late bool _isVerified;
  int? _selectedCategoryId;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.transaction.method == PaymentMethod.unknown
        ? PaymentMethod.upi
        : widget.transaction.method;
    _accountController = TextEditingController(
      text: widget.transaction.account ?? '',
    );
    _bankController = TextEditingController(text: widget.transaction.bankName);
    _amountController = TextEditingController(
      text: widget.transaction.amount.toStringAsFixed(2),
    );
    _descriptionController = TextEditingController(
      text: widget.transaction.description ?? '',
    );
    _merchantController = TextEditingController(
      text: widget.transaction.merchant ?? '',
    );
    _isVerified = widget.transaction.isVerified;
    _selectedCategoryId = widget.transaction.categoryId;
  }

  @override
  void dispose() {
    _accountController.dispose();
    _bankController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (_accountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an account number')),
      );
      return;
    }

    if (_bankController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a bank name')));
      return;
    }

    if (widget.transaction.rawSms == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot verify a manual transaction')),
      );
      return;
    }

    await ref
        .read(transactionProvider.notifier)
        .verifyTransaction(
          rawSms: widget.transaction.rawSms!,
          method: _selectedMethod,
          account: _accountController.text.trim(),
          bankName: _bankController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction verified successfully!'),
          backgroundColor: AppTheme.incomeLight,
        ),
      );
      context.pop();
    }
  }

  Future<void> _handleSave() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (widget.transaction.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot edit sample transactions')),
      );
      return;
    }

    final isManual = widget.transaction.source == TransactionSource.manual;
    await ref
        .read(transactionProvider.notifier)
        .updateTransactionDetails(
          id: widget.transaction.id!,
          amount: amount,
          method: _selectedMethod,
          isVerified: isManual ? true : _isVerified,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          categoryId: _selectedCategoryId,
          merchant: _merchantController.text.trim().isEmpty
              ? null
              : _merchantController.text.trim(),
        );

    if (mounted) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully!'),
          backgroundColor: AppTheme.incomeLight,
        ),
      );
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text(
          'Are you sure you want to delete this manual transaction?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getExpenseColor(context),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.transaction.id != null) {
      await ref
          .read(transactionProvider.notifier)
          .deleteTransaction(widget.transaction.id!);
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider).allTransactions;

    final seen = <String>{};
    final existingAccounts = <({String account, String bank})>[];

    for (final t in transactions) {
      if (t.account != null && t.account!.isNotEmpty) {
        final key = '${t.account}|${t.bankName}';
        if (!seen.contains(key)) {
          seen.add(key);
          existingAccounts.add((account: t.account!, bank: t.bankName));
        }
      }
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final isManual = widget.transaction.source == TransactionSource.manual;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _isEditing ? 'Edit Transaction' : 'Transaction Details',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        actions: [
          if (!_isEditing && !widget.transaction.isSample) ...[
            if (isManual)
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 22.sp,
                  color: AppTheme.getExpenseColor(context),
                ),
                onPressed: _handleDelete,
              ),
            IconButton(
              icon: Icon(Icons.edit_rounded, size: 22.sp),
              onPressed: () => setState(() => _isEditing = true),
            ),
          ] else if (_isEditing)
            TextButton(
              onPressed: _handleSave,
              child: Text(
                'Save',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                ),
              ),
            ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              if (widget.heroTag != null)
                Hero(tag: widget.heroTag!, child: _buildAmountCard(isDark))
              else
                _buildAmountCard(isDark),
              SizedBox(height: 20.h),

              if (!widget.transaction.isVerified) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(28.r),
                    border: Border.all(
                      color: AppTheme.getExpenseColor(context).withAlpha(80),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            color: AppTheme.getExpenseColor(context),
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Complete Info',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(
                                context,
                              ).textTheme.titleLarge?.color,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      AppSectionLabel(text: 'Payment Method'),
                      SizedBox(height: 8.h),
                      DropdownButtonFormField<PaymentMethod>(
                        initialValue: _selectedMethod,
                        dropdownColor: Theme.of(context).cardColor,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: _inputDecoration(isDark),
                        items: PaymentMethod.values
                            .where((e) => e != PaymentMethod.unknown)
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedMethod = val);
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      AppSectionLabel(text: 'Account Number'),
                      SizedBox(height: 8.h),
                      if (existingAccounts.isNotEmpty) ...[
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: existingAccounts.map((acc) {
                            final isSelected =
                                _accountController.text == acc.account &&
                                _bankController.text == acc.bank;
                            return AppChoiceChip(
                              label: '${acc.account} (${acc.bank})',
                              isSelected: isSelected,
                              color: AppTheme.getExpenseColor(context),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _accountController.text = acc.account;
                                    _bankController.text = acc.bank;
                                  });
                                }
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 12.h),
                      ],
                      TextFormField(
                        controller: _accountController,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: _inputDecoration(
                          isDark,
                        ).copyWith(hintText: 'e.g. X1234'),
                      ),
                      SizedBox(height: 20.h),
                      AppSectionLabel(text: 'Bank Name'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _bankController,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: _inputDecoration(
                          isDark,
                        ).copyWith(hintText: 'e.g. HDFC Bank'),
                      ),
                      SizedBox(height: 20.h),
                      AppSectionLabel(text: 'Description (Optional)'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 2,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: _inputDecoration(
                          isDark,
                        ).copyWith(hintText: 'Add a brief note...'),
                      ),
                      SizedBox(height: 24.h),
                      AppPrimaryButton(
                        label: 'Verify & Save',
                        onPressed: _handleVerify,
                        backgroundColor: AppTheme.getExpenseColor(context),
                        height: 54.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
              ],

              _buildModernDetailCard(
                context,
                'STATUS',
                isManual || _isVerified ? 'Verified' : 'Unverified',
                isManual || _isVerified
                    ? Icons.check_rounded
                    : Icons.warning_rounded,
                isManual || _isVerified
                    ? AppTheme.getIncomeColor(context)
                    : AppTheme.getNeutralColor(context),
                trailing: _isEditing && !isManual
                    ? Switch.adaptive(
                        value: _isVerified,
                        onChanged: (val) => setState(() => _isVerified = val),
                      )
                    : null,
              ),
              SizedBox(height: 12.h),
              _buildModernDetailCard(
                context,
                'BANK NAME',
                widget.transaction.bankName,
                Icons.store_rounded,
                AppTheme.getNeutralColor(context),
              ),
              SizedBox(height: 12.h),
              _buildModernDetailCard(
                context,
                'ACCOUNT NUMBER',
                widget.transaction.account ?? 'N/A',
                Icons.tag_rounded,
                Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 12.h),
              _isEditing
                  ? _buildEditableMethodCard(isDark)
                  : _buildModernDetailCard(
                      context,
                      'PAYMENT METHOD',
                      widget.transaction.method.name.toUpperCase(),
                      Icons.credit_card_rounded,
                      Theme.of(context).colorScheme.primary,
                    ),
              SizedBox(height: 12.h),
              _buildModernDetailCard(
                context,
                'DATE & TIME',
                DateFormat(
                  'dd MMM yyyy, hh:mm a',
                ).format(widget.transaction.date),
                Icons.calendar_today_rounded,
                AppTheme.getNeutralColor(context),
              ),
              SizedBox(height: 12.h),
              if (_isEditing)
                _buildEditableDescriptionCard(isDark)
              else if (widget.transaction.description != null &&
                  widget.transaction.description!.isNotEmpty)
                _buildModernDetailCard(
                  context,
                  'DESCRIPTION',
                  widget.transaction.description!,
                  Icons.notes_rounded,
                  AppTheme.getNeutralColor(context),
                ),
              _isEditing ? SizedBox(height: 12.h) : const SizedBox.shrink(),
              _isEditing
                  ? _buildEditableCategoryCard()
                  : widget.transaction.category != null
                  ? _buildModernDetailCard(
                      context,
                      'CATEGORY',
                      widget.transaction.category!.name,
                      UIHelpers.getCategoryIcon(
                        widget.transaction.category!.icon,
                      ),
                      widget.transaction.category!.color != null
                          ? Color(widget.transaction.category!.color!)
                          : Theme.of(context).colorScheme.primary,
                    )
                  : const SizedBox.shrink(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.message_rounded,
                          size: 14.sp,
                          color: AppTheme.getNeutralColor(context),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'RAW SMS MESSAGE',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: AppTheme.getNeutralColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.surfaceElevatedDark
                          : AppTheme.surfaceSecondaryLight,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppTheme.getBorderColor(context),
                      ),
                    ),
                    child: Text(
                      widget.transaction.rawSms ?? 'Manual Entry (No SMS)',
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.6,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernDetailCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color accentColor, {
    Widget? trailing,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppTheme.getBorderColor(context), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(isDark ? 35 : 15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: accentColor),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppTheme.getNeutralColor(context),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  Widget _buildEditableMethodCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(100),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PAYMENT METHOD',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppTheme.getNeutralColor(context),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 12.h),
          DropdownButtonFormField<PaymentMethod>(
            initialValue: _selectedMethod,
            dropdownColor: Theme.of(context).cardColor,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w600,
            ),
            decoration: _inputDecoration(isDark),
            items: PaymentMethod.values
                .where((e) => e != PaymentMethod.unknown)
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name.toUpperCase()),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedMethod = val);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditableDescriptionCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(100),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DESCRIPTION',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppTheme.getNeutralColor(context),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _descriptionController,
            maxLines: 2,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w600,
            ),
            decoration: _inputDecoration(
              isDark,
            ).copyWith(hintText: 'Add a note...'),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: AppTheme.getSurfaceSecondaryColor(context),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(
        color: AppTheme.getNeutralColor(context),
        fontSize: 14.sp,
      ),
    );
  }

  Widget _buildAmountCard(bool isDark) {
    final isDebit = widget.transaction.type == TransactionType.debit;
    final semanticColor = isDebit
        ? AppTheme.getExpenseColor(context)
        : AppTheme.getIncomeColor(context);
    final semanticBg = isDebit
        ? AppTheme.getExpenseBgColor(context)
        : AppTheme.getIncomeBgColor(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: semanticBg,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: semanticColor.withAlpha(isDark ? 150 : 80),
          width: 2.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Material(
          type: MaterialType.transparency,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withAlpha(40)
                        : Colors.white.withAlpha(150),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: semanticColor.withAlpha(50),
                      width: 1,
                    ),
                  ),
                  child: TransactionIcon(
                    method: widget.transaction.method,
                    color: semanticColor,
                    size: 24.sp,
                  ),
                ),
                if (_isEditing)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextFormField(
                      controller: _merchantController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: semanticColor,
                        letterSpacing: -0.5,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Merchant Name',
                        hintStyle: TextStyle(
                          color: semanticColor.withAlpha(100),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                      ),
                    ),
                  )
                else
                  Text(
                    widget.transaction.merchant ?? 'Unknown Merchant',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: semanticColor,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (_isEditing)
                        SizedBox(
                          width: 150.w,
                          child: TextFormField(
                            controller: _amountController,
                            textAlign: TextAlign.center,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: TextStyle(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w900,
                              color: semanticColor,
                              letterSpacing: -1,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: '0.00',
                              hintStyle: TextStyle(
                                color: semanticColor.withAlpha(100),
                              ),
                            ),
                          ),
                        )
                      else
                        TransactionAmountText(
                          amount:
                              double.tryParse(_amountController.text) ??
                              widget.transaction.amount,
                          type: widget.transaction.type,
                          showSign: false,
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w900,
                            color: semanticColor,
                            letterSpacing: -1,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableCategoryCard() {
    final state = ref.watch(transactionProvider);
    final categories = state.categories;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(100),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CATEGORY',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppTheme.getNeutralColor(context),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: _showAddCategoryDialog,
                child: Text(
                  '+ ADD NEW',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
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
              ...categories.map((cat) {
                final isSelected = _selectedCategoryId == cat.id;
                final catColor = cat.color != null
                    ? Color(cat.color!)
                    : Theme.of(context).colorScheme.primary;
                return AppChoiceChip(
                  label: cat.name,
                  isSelected: isSelected,
                  color: catColor,
                  avatar: Icon(
                    UIHelpers.getCategoryIcon(cat.icon),
                    size: 14.sp,
                    color: isSelected
                        ? catColor
                        : AppTheme.getNeutralColor(context),
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCategoryId = cat.id);
                  },
                );
              }),
            ],
          ),
        ],
      ),
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
          decoration: _inputDecoration(
            Theme.of(context).brightness == Brightness.dark,
          ).copyWith(hintText: 'Category Name'),
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
