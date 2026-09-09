import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:expense_tracker/core/constants/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../core/constants/args.dart';
import '../../personal_expenses/models/transaction_model.dart';
import '../viewmodels/circle_all_transactions_notifier.dart';
import '../viewmodels/circle_details_notifier.dart';
import '../widgets/circle_transaction_tile.dart';

class CircleAllTransactionsScreen extends ConsumerStatefulWidget {
  final int circleId;

  const CircleAllTransactionsScreen({super.key, required this.circleId});

  @override
  ConsumerState<CircleAllTransactionsScreen> createState() =>
      _CircleAllTransactionsScreenState();
}

class _CircleAllTransactionsScreenState
    extends ConsumerState<CircleAllTransactionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(circleAllTransactionsProvider(widget.circleId).notifier)
          .fetchTransactions();
    });
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return 'Today';
    if (d == yesterday) return 'Yesterday';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final detailsState = ref.watch(circleDetailsProvider(widget.circleId));
    final screenData = detailsState.screenData;
    final members = screenData?.members ?? [];

    final transactionsState = ref.watch(
      circleAllTransactionsProvider(widget.circleId),
    );

    // Grouping
    final groupedTxns = <String, List<TransactionModel>>{};
    for (var tx in transactionsState.transactions) {
      final header = _formatDateHeader(tx.txnDate);
      if (!groupedTxns.containsKey(header)) {
        groupedTxns[header] = [];
      }
      groupedTxns[header]!.add(tx);
    }
    final groupKeys = groupedTxns.keys.toList();

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppTopBar(title: 'All Transactions'),
      body:
          transactionsState.isLoading && transactionsState.transactions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : transactionsState.error != null &&
                transactionsState.transactions.isEmpty
          ? Center(child: Text(transactionsState.error!))
          : groupKeys.isEmpty
          ? Center(
              child: Text(
                'No transactions found.',
                style: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 16.h,
              ).copyWith(bottom: 100.h),
              itemCount: groupKeys.length,
              itemBuilder: (context, index) {
                final dateString = groupKeys[index];
                final txns = groupedTxns[dateString]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.h,
                        top: index == 0 ? 0 : 24.h,
                      ),
                      child: Text(
                        dateString.toUpperCase(),
                        style: context.appTexts.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: context.colors.card,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: txns.length,
                        separatorBuilder: (context, sepIndex) => Divider(
                          height: 1,
                          indent: 76.w,
                          color: context.colors.border,
                        ),
                        itemBuilder: (context, txnIndex) {
                          final txn = txns[txnIndex];
                          final paidByMember = members
                              .where((m) => m.userId == txn.userId)
                              .firstOrNull;
                          final paidByName =
                              paidByMember?.fullName ?? 'Someone';

                          return InkWell(
                            onTap: () {
                              context.push(
                                AppRouter.transactionDetail,
                                extra: txn,
                              );
                            },
                            child: CircleTransactionTile(
                              icon: Icons.receipt_long_rounded,
                              title: txn.note ?? 'Expense',
                              subtitle: 'Paid by $paidByName',
                              amount: '₹${txn.amount}',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (members.isNotEmpty) {
            context.push(
              AppRouter.addCircleExpense,
              extra: AddCircleExpenseArgs(
                circleId: widget.circleId,
                members: members,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cannot add expense: members not loaded.'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.expense,
              ),
            );
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add expense',
          style: context.appTexts.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
