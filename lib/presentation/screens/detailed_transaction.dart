import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_notifier.dart';

class DetailedTransactionScreen extends ConsumerStatefulWidget {
  final Transaction transaction;

  const DetailedTransactionScreen({super.key, required this.transaction});

  @override
  ConsumerState<DetailedTransactionScreen> createState() =>
      _DetailedTransactionScreenState();
}

class _DetailedTransactionScreenState
    extends ConsumerState<DetailedTransactionScreen> {
  late PaymentMethod _selectedMethod;
  late TextEditingController _accountController;
  late TextEditingController _bankController;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.transaction.method == PaymentMethod.unknown
        ? PaymentMethod.upi
        : widget.transaction.method;
    _accountController = TextEditingController(
      text: widget.transaction.account ?? '',
    );
    _bankController = TextEditingController(
      text: widget.transaction.bankName,
    );
  }

  @override
  void dispose() {
    _accountController.dispose();
    _bankController.dispose();
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a bank name')),
      );
      return;
    }

    await ref
        .read(transactionProvider.notifier)
        .verifyTransaction(
          rawSms: widget.transaction.rawSms,
          method: _selectedMethod,
          account: _accountController.text.trim(),
          bankName: _bankController.text.trim(),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction verified successfully!'),
          backgroundColor: AppTheme.emerald,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider).allTransactions;

    // Get unique combinations of account and bank
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

    final isDebit = widget.transaction.type == TransactionType.debit;
    final color = isDebit ? AppTheme.rose : AppTheme.emerald;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Transaction Details',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18.sp,
            color: isDark ? AppTheme.slate50 : AppTheme.slate900,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            children: [
              // ── Amount Header Card ──
              Hero(
                tag: 'transaction_${widget.transaction.rawSms}',
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withAlpha(40), color.withAlpha(15)],
                    ),
                    borderRadius: BorderRadius.circular(32.r),
                    border: Border.all(color: color.withAlpha(60), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: color.withAlpha(20),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32.r),
                    child: Material(
                      type: MaterialType.transparency,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: color.withAlpha(40),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withAlpha(30),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _getIcon(widget.transaction.method),
                                color: color,
                                size: 36.sp,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              isDebit ? "Total Spent" : "Total Received",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppTheme.slate400
                                    : AppTheme.slate500,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '₹',
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700,
                                      color: color.withAlpha(180),
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    widget.transaction.amount.toStringAsFixed(
                                      2,
                                    ),
                                    style: TextStyle(
                                      fontSize: 42.sp,
                                      fontWeight: FontWeight.w900,
                                      color: isDark
                                          ? AppTheme.slate50
                                          : AppTheme.slate900,
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
                ),
              ),

              SizedBox(height: 32.h),

              // ── Manual Verification Form (Only if Unverified) ──
              if (!widget.transaction.isVerified) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.slate800 : Colors.white,
                    borderRadius: BorderRadius.circular(28.r),
                    border: Border.all(
                      color: AppTheme.rose.withAlpha(100),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            color: AppTheme.rose,
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Complete Transaction Info',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppTheme.slate50
                                  : AppTheme.slate900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.slate500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      DropdownButtonFormField<PaymentMethod>(
                        value: _selectedMethod,
                        dropdownColor: isDark
                            ? AppTheme.slate800
                            : Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark
                              ? AppTheme.slate900
                              : AppTheme.slate50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
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
                          if (val != null)
                            setState(() => _selectedMethod = val);
                        },
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Account Number',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.slate500,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // ── Quick Select Accounts ──
                      if (existingAccounts.isNotEmpty) ...[
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: existingAccounts.map((acc) {
                            final isSelected =
                                _accountController.text == acc.account;
                            return ChoiceChip(
                              label: Text('${acc.account} (${acc.bank})'),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _accountController.text = acc.account;
                                    _bankController.text = acc.bank;
                                  });
                                }
                              },
                              selectedColor: AppTheme.rose.withAlpha(40),
                              labelStyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppTheme.rose
                                    : (isDark
                                          ? AppTheme.slate300
                                          : AppTheme.slate700),
                              ),
                              backgroundColor: isDark
                                  ? AppTheme.slate900
                                  : AppTheme.slate100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppTheme.rose
                                      : Colors.transparent,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 12.h),
                      ],

                      TextFormField(
                        controller: _accountController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'e.g. X1234',
                          filled: true,
                          fillColor: isDark
                              ? AppTheme.slate900
                              : AppTheme.slate50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Bank Name',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.slate500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _bankController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'e.g. HDFC Bank',
                          filled: true,
                          fillColor: isDark ? AppTheme.slate900 : AppTheme.slate50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: _handleVerify,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.rose,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Verify & Save',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
              ],

              // ── Main Details Card ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.slate800 : Colors.white,
                  borderRadius: BorderRadius.circular(28.r),
                  border: Border.all(
                    color: isDark ? AppTheme.slate700 : AppTheme.slate200,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 30 : 10),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailItem(
                      context,
                      'Status',
                      widget.transaction.isVerified ? 'Verified' : 'Unverified',
                      widget.transaction.isVerified
                          ? Icons.verified_rounded
                          : Icons.warning_amber_rounded,
                      widget.transaction.isVerified
                          ? AppTheme.emerald
                          : Colors.amber,
                    ),
                    _divider(isDark),
                    _buildDetailItem(
                      context,
                      'Bank Name',
                      widget.transaction.bankName,
                      Icons.account_balance_rounded,
                      AppTheme.primary,
                    ),
                    _divider(isDark),
                    _buildDetailItem(
                      context,
                      'Account Number',
                      widget.transaction.account ?? 'N/A',
                      Icons.tag_rounded,
                      AppTheme.primary,
                    ),
                    _divider(isDark),
                    _buildDetailItem(
                      context,
                      'Payment Method',
                      widget.transaction.method.name.toUpperCase(),
                      Icons.payment_rounded,
                      AppTheme.primary,
                    ),
                    _divider(isDark),
                    _buildDetailItem(
                      context,
                      'Date & Time',
                      DateFormat(
                        'dd MMM yyyy, hh:mm a',
                      ).format(widget.transaction.date),
                      Icons.calendar_today_rounded,
                      AppTheme.primary,
                    ),
                    if (widget.transaction.availableBalance != null) ...[
                      _divider(isDark),
                      _buildDetailItem(
                        context,
                        'Available Balance',
                        '₹${widget.transaction.availableBalance!.toStringAsFixed(2)}',
                        Icons.account_balance_wallet_rounded,
                        AppTheme.emerald,
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // ── Raw Message Section ──
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
                          size: 16.sp,
                          color: AppTheme.slate500,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'RAW SMS MESSAGE',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: AppTheme.slate500,
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
                          ? AppTheme.slate800.withAlpha(150)
                          : AppTheme.slate100,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isDark ? AppTheme.slate700 : AppTheme.slate200,
                      ),
                    ),
                    child: Text(
                      widget.transaction.rawSms,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.6,
                        color: isDark ? AppTheme.slate300 : AppTheme.slate700,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 20.sp, color: iconColor),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.slate500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.slate50 : AppTheme.slate900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) => Divider(
    height: 1,
    color: isDark
        ? AppTheme.slate700.withAlpha(100)
        : AppTheme.slate200.withAlpha(150),
  );

  IconData _getIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.upi:
        return Icons.qr_code_2_rounded;
      case PaymentMethod.card:
        return Icons.credit_card_rounded;
      case PaymentMethod.atm:
        return Icons.account_balance_wallet_rounded;
      case PaymentMethod.imps:
        return Icons.bolt_rounded;
      case PaymentMethod.neft:
      case PaymentMethod.rtgs:
        return Icons.account_balance_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }
}
