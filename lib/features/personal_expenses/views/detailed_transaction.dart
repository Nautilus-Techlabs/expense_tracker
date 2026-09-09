import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/core/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors_extension.dart';
import '../../../core/constants/app_constants.dart';
import '../../circle/models/circle_transaction_split_model.dart';
import '../../circle/viewmodels/circle_transaction_details_provider.dart';
import '../models/transaction_model.dart';
import '../viewmodels/detailed_transaction_provider.dart';
import '../viewmodels/transaction_notifier.dart';
import '../widgets/edit_transaction_sheet.dart';

class DetailedTransactionScreen extends ConsumerStatefulWidget {
  final TransactionModel transaction;
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
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final detailState = ref.watch(
      detailedTransactionProvider(widget.transaction),
    );

    final amountColor = detailState.isExpense
        ? AppColors.expense
        : AppColors.income;
    final isCircleTransaction = detailState.isCircleTransaction;
    final categoryName = detailState.categoryName;
    final accountName = detailState.accountName;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppTopBar(title: 'Transaction detail'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            UIHelpers.verticalSpace(32),

            // ── Hero Icon ──
            _buildHeroIcon(isCircleTransaction, amountColor),
            UIHelpers.verticalSpace(20),

            // ── Merchant Name ──
            Text(
              widget.transaction.note ?? 'Unknown',
              style: context.appTexts.displayMedium.copyWith(
                color: context.colors.primary,
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            UIHelpers.verticalSpace(8),

            // ── Amount ──
            Text(
              '₹${widget.transaction.amount}',
              style: context.appTexts.displayLarge.copyWith(
                color: amountColor,
                fontSize: 40.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            UIHelpers.verticalSpace(8),

            // ── Subtitle: Category · Type · Date ──
            Text(
              _buildSubtitle(categoryName),
              style: context.appTexts.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            UIHelpers.verticalSpace(32),

            // ── Details Card ──
            _buildDetailsCard(
              context,
              isCircleTransaction,
              isDark,
              accountName,
              categoryName,
            ),
            UIHelpers.verticalSpace(16),

            // ── Split Details Card (only for Circle transactions) ──
            if (isCircleTransaction)
              ref
                  .watch(
                    circleTransactionDetailsProvider(widget.transaction.id),
                  )
                  .when(
                    data: (splitModel) {
                      if (splitModel == null) return const SizedBox.shrink();
                      return _buildSplitDetailsCard(
                        context,
                        isDark,
                        splitModel,
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(
                      child: Text(
                        'Error: $e',
                        style: TextStyle(color: context.colors.textPrimary),
                      ),
                    ),
                  ),
            UIHelpers.verticalSpace(32),

            // ── Action Buttons ──
            if (detailState.canEditOrDelete)
              _buildActionButtons(context, isDark),
            UIHelpers.verticalSpace(40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroIcon(bool isCircleTransaction, Color amountColor) {
    final bgColor = isCircleTransaction ? AppColors.income : amountColor;
    final icon = isCircleTransaction ? Icons.group_rounded : _getCategoryIcon();

    return Hero(
      tag: widget.heroTag ?? 'tx_detail_${widget.transaction.id}',
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 36.sp),
      ),
    );
  }

  Widget _buildDetailsCard(
    BuildContext context,
    bool isCircleTransaction,
    bool isDark,
    String accountName,
    String categoryName,
  ) {
    final cardColor = context.colors.card;
    final borderColor = context.colors.border;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: _formatDate(widget.transaction.txnDate),
            isDark: isDark,
            showDivider: true,
          ),
          _buildDetailRow(
            icon: Icons.account_balance_outlined,
            label: 'Account',
            value: accountName,
            isDark: isDark,
            showDivider: true,
          ),
          if (!isCircleTransaction) ...[
            _buildDetailRow(
              icon: Icons.label_outline_rounded,
              label: 'Category',
              value: categoryName,
              isDark: isDark,
              showDivider: true,
            ),
            _buildDetailRow(
              icon: Icons.edit_outlined,
              label: 'Note',
              value: widget.transaction.note ?? '—',
              isDark: isDark,
              showDivider: true,
            ),
          ],
          _buildDetailRow(
            icon: Icons.swap_vert_rounded,
            label: 'Type',
            value:
                widget.transaction.type[0].toUpperCase() +
                widget.transaction.type.substring(1),
            isDark: isDark,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    required bool showDivider,
    Color? valueColor,
    bool isItalic = false,
  }) {
    final borderColor = context.colors.border;
    final labelColor = context.colors.textSecondary;
    final resolvedValueColor = valueColor ?? (context.colors.textPrimary);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              Icon(icon, size: 22.sp, color: labelColor),
              UIHelpers.horizontalSpace(14),
              Text(
                label,
                style: context.appTexts.bodyMedium.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: context.appTexts.bodyMedium.copyWith(
                    color: resolvedValueColor,
                    fontWeight: FontWeight.w600,
                    fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: borderColor,
            indent: 20.w,
            endIndent: 20.w,
          ),
      ],
    );
  }

  Widget _buildSplitDetailsCard(
    BuildContext context,
    bool isDark,
    CircleTransactionSplitModel splitModel,
  ) {
    final cardColor = context.colors.card;
    final borderColor = context.colors.border;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w).copyWith(bottom: 10.h),
            child: Text(
              'Splits',
              style: context.appTexts.bodyMedium.copyWith(
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(height: 1, color: borderColor),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: splitModel.splits.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: borderColor,
              indent: 20.w,
              endIndent: 20.w,
            ),
            itemBuilder: (context, index) {
              final split = splitModel.splits[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          split.fullName,
                          style: context.appTexts.bodyMedium.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        UIHelpers.verticalSpace(2),
                        Text(
                          split.splitType,
                          style: context.appTexts.bodySmall.copyWith(
                            color: context.colors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹${split.actualAmount}',
                      style: context.appTexts.bodyMedium.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Row(
      children: [
        // Edit button
        Expanded(
          child: OutlinedButton(
            onPressed: () => _showEditSheet(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.primary,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: Text(
              'Edit transaction',
              style: context.appTexts.bodyMedium.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        UIHelpers.horizontalSpace(16),
        // Delete button
        Expanded(
          child: OutlinedButton(
            onPressed: ref.watch(transactionProvider).isLoading
                ? null
                : () => _handleDelete(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.expense, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: ref.watch(transactionProvider).isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.expense,
                    ),
                  )
                : Text(
                    'Delete',
                    style: context.appTexts.bodyMedium.copyWith(
                      color: AppColors.expense,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => EditTransactionSheet(
        transaction: widget.transaction,
        onSaved: (updatedTx) {
          if (mounted) {
            context.pop();
          }
        },
      ),
    );
  }

  String _buildSubtitle(String categoryName) {
    String typeLabel = 'Expense';
    if (widget.transaction.type == 'income') {
      typeLabel = 'Income';
    } else if (widget.transaction.type == 'withdrawal') {
      typeLabel = 'Withdrawal';
    }
    final when = _timeLabel(widget.transaction.txnDate);
    return '$categoryName · $typeLabel · $when';
  }

  String _timeLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return 'Today';
    if (d == yesterday) return 'Yesterday';
    return DateFormat('dd MMM').format(date);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final prefix = d == today ? 'Today, ' : '';
    return '$prefix${DateFormat('dd MMM yyyy').format(date)}';
  }

  IconData _getCategoryIcon() {
    return Icons.receipt_long_rounded;
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark
            : AppColors.cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text('Delete Transaction', style: context.appTexts.heading),
        content: Text(
          'Are you sure you want to delete this transaction? This cannot be undone.',
          style: context.appTexts.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: context.appTexts.bodyMedium.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textPrimaryDark
                    : AppColors.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.expense,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Delete',
              style: context.appTexts.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(transactionProvider.notifier)
          .deleteTransaction(widget.transaction.id);

      if (mounted) {
        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Transaction deleted'),
              backgroundColor: AppColors.income,
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to delete transaction'),
              backgroundColor: AppColors.expense,
            ),
          );
        }
      }
    }
  }
}
