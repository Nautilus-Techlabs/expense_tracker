import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_notifier.dart';
import '../widgets/transaction_card.dart';

class BankDetailTransactionsScreen extends ConsumerStatefulWidget {
  final String bankName;

  const BankDetailTransactionsScreen({
    super.key,
    required this.bankName,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter transactions by bank and method
    final allBankTransactions = state.allTransactions.where((t) => t.bankName == widget.bankName).toList();
    
    // Available methods for this bank
    final availableMethods = allBankTransactions
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
      ),
      body: Column(
        children: [
          // ── Filter Bar ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              children: [
                _buildFilterChip(null, 'All'),
                ...availableMethods
                    .map((m) => Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: _buildFilterChip(m, m.name.toUpperCase()),
                        )),
              ],
            ),
          ),

          // ── Transaction List ──
          Expanded(
            child: bankTransactions.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 40.h),
                    physics: const BouncingScrollPhysics(),
                    itemCount: bankTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = bankTransactions[index];
                      return TransactionCard(
                        transaction: transaction,
                        heroTag: 'bank_detail_${transaction.id ?? transaction.rawSms}',
                      );
                    },
                  ),
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
          color: isSelected ? activeColor : (isDark ? AppTheme.surfaceElevatedDark : Colors.white),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? activeColor : AppTheme.getBorderColor(context),
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: activeColor.withAlpha(60),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ] : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.getNeutralColor(context),
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
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
