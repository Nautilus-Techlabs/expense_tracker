import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';
import '../widgets/bank_summary_card.dart';
import '../widgets/set_opening_balance_sheet.dart';
import '../widgets/transaction_card.dart';

class BankDetailTransactionsScreen extends ConsumerStatefulWidget {
  final String bankName;
  final String? accountNumber;

  const BankDetailTransactionsScreen({
    super.key,
    required this.bankName,
    this.accountNumber,
  });

  @override
  ConsumerState<BankDetailTransactionsScreen> createState() =>
      _BankDetailTransactionsScreenState();
}

class _BankDetailTransactionsScreenState
    extends ConsumerState<BankDetailTransactionsScreen> {
  PaymentMethod? _methodFilter;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);
    // Filter transactions by bank and method
    final allBankTransactions = state.allTransactions.where((t) {
      final matchesBank = t.bankName == widget.bankName;
      bool matchesAccount = true;
      if (widget.accountNumber != null) {
        matchesAccount = t.account == widget.accountNumber;
      }

      return matchesBank && matchesAccount;
    }).toList();

    // Available methods for this bank
    final availableMethods =
        allBankTransactions
            .map((t) => t.method)
            .where((m) => m != PaymentMethod.unknown)
            .toSet()
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

    final bankTransactions = allBankTransactions.where((t) {
      if (_methodFilter == null) return true;
      return t.method == _methodFilter;
    }).toList();

    // Sort by date desc
    bankTransactions.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.bankName,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18.sp,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            Text(
              '${bankTransactions.length} Transactions',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.getNeutralColor(context),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_balance_wallet_rounded, size: 20.sp),
            onPressed: () => _showOpeningBalanceSheet(context),
            tooltip: 'Set Initial Balance',
          ),
          UIHelpers.horizontalSpace(8),
        ],
      ),
      body: Column(
        children: [
          // ── Summary Card ──
          BankSummaryCard(
            bankName: widget.bankName,
            accountNumber: widget.accountNumber,
            balance: widget.accountNumber != null
                ? state.getAccountBalance(
                    widget.bankName,
                    widget.accountNumber!,
                  )
                : state.getAvailableBanks().contains(widget.bankName)
                ? state.allTransactions
                      .where(
                        (t) => t.bankName == widget.bankName && t.isVerified,
                      )
                      .map((t) => t.account)
                      .toSet()
                      .fold(
                        0.0,
                        (sum, acc) =>
                            sum +
                            (acc != null
                                ? state.getAccountBalance(widget.bankName, acc)
                                : 0),
                      )
                : 0,
            income: bankTransactions
                .where(
                  (t) =>
                      t.type == TransactionType.credit &&
                      !state.isTransactionBeforeOpening(t),
                )
                .fold(0.0, (sum, t) => sum + t.amount),
            spends: bankTransactions
                .where(
                  (t) =>
                      t.type == TransactionType.debit &&
                      !state.isTransactionBeforeOpening(t),
                )
                .fold(0.0, (sum, t) => sum + t.amount),
          ),

          // ── Filter Bar ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Row(
              children: [
                _buildFilterChip(null, 'All'),
                ...availableMethods.map(
                  (m) => Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: _buildFilterChip(m, m.name.toUpperCase()),
                  ),
                ),
              ],
            ),
          ),

          // ── Transaction List ──
          Expanded(
            child: bankTransactions.isEmpty
                ? _buildEmptyState()
                : _buildGroupedList(bankTransactions),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(PaymentMethod? method, String label) {
    final isSelected = _methodFilter == method;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        UIHelpers.lightImpact();
        setState(() => _methodFilter = method);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : (isDark ? AppTheme.surfaceElevatedDark : Colors.white),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? activeColor : AppTheme.getBorderColor(context),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withAlpha(60),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : AppTheme.getNeutralColor(context),
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }

  void _showOpeningBalanceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SetOpeningBalanceSheet(
        initialAccount: widget.accountNumber != null
            ? BankAccount(
                bankName: widget.bankName,
                accountNumber: widget.accountNumber!,
              )
            : null,
        isFixed: true,
      ),
    );
  }

  Widget _buildGroupedList(List<Transaction> transactions) {
    final grouped = _groupByDate(transactions);
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 40.h),
      physics: const BouncingScrollPhysics(),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final item = grouped[index];
        if (item is String) {
          return Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
            child: Text(
              item.toUpperCase(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppTheme.getNeutralColor(context),
                letterSpacing: 0.5,
              ),
            ),
          );
        }
        final transaction = item as Transaction;
        return TransactionCard(
          transaction: transaction,
          heroTag: 'bank_detail_${transaction.id ?? transaction.rawSms}',
        );
      },
    );
  }

  List<dynamic> _groupByDate(List<Transaction> transactions) {
    final List<dynamic> grouped = [];
    String? lastDate;
    for (final t in transactions) {
      final dateStr = _formatDateHeader(t.date);
      if (dateStr != lastDate) {
        grouped.add(dateStr);
        lastDate = dateStr;
      }
      grouped.add(t);
    }
    return grouped;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tDate = DateTime(date.year, date.month, date.day);
    if (tDate == today) {
      return "Today, ${DateFormat('MMM dd, yyyy').format(date)}";
    } else if (tDate == yesterday) {
      return "Yesterday, ${DateFormat('MMM dd, yyyy').format(date)}";
    } else {
      return DateFormat('EEEE, MMM dd, yyyy').format(date);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 64.sp,
            color: AppTheme.getNeutralColor(context).withAlpha(100),
          ),
          UIHelpers.verticalSpace(16),
          Text(
            'No matches found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.getNeutralColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
