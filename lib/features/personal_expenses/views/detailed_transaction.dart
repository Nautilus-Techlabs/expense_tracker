import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/transaction.dart';
import '../viewmodels/detailed_transaction_viewmodel.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(detailedTransactionViewModelProvider.notifier)
          .init(widget.transaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailedTransactionViewModelProvider);
    final vm = ref.read(detailedTransactionViewModelProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDebit = widget.transaction.type == TransactionType.debit;
    final amountColor = isDebit ? AppColors.expense : AppColors.income;

    // Detect if it belongs to a Circle
    // TODO: Replace with real circleId check once Circle feature is built
    final bool isCircleTransaction = widget.transaction.description?.startsWith('circle:') ?? false;

    ref.listen<DetailedTransactionState>(
        detailedTransactionViewModelProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 20.sp,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Transaction detail',
          style: AppTexts.heading.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
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
              state.merchant.isNotEmpty ? state.merchant : 'Unknown',
              style: AppTexts.displayMedium.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            UIHelpers.verticalSpace(8),

            // ── Amount ──
            Text(
              '₹${state.amount}',
              style: AppTexts.displayLarge.copyWith(
                color: amountColor,
                fontSize: 40.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            UIHelpers.verticalSpace(8),

            // ── Subtitle: Category · Type · Date ──
            Text(
              _buildSubtitle(state),
              style: AppTexts.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            UIHelpers.verticalSpace(32),

            // ── Details Card ──
            _buildDetailsCard(context, state, isCircleTransaction, isDark),
            UIHelpers.verticalSpace(16),

            // ── Split Details Card (only for Circle transactions) ──
            if (isCircleTransaction)
              _buildSplitDetailsCard(context, isDark),
            UIHelpers.verticalSpace(32),

            // ── Action Buttons ──
            _buildActionButtons(context, vm, isDark),
            UIHelpers.verticalSpace(40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroIcon(bool isCircleTransaction, Color amountColor) {
    final bgColor = isCircleTransaction ? AppColors.income : amountColor;
    final icon = isCircleTransaction
        ? Icons.group_rounded
        : _getCategoryIcon();

    return Hero(
      tag: widget.heroTag ?? 'tx_detail_${widget.transaction.id}',
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 36.sp),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, DetailedTransactionState state, bool isCircleTransaction, bool isDark) {
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

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
            value: _formatDate(widget.transaction.date),
            isDark: isDark,
            showDivider: true,
          ),
          _buildDetailRow(
            icon: Icons.account_balance_outlined,
            label: 'Account',
            value: state.bankName.isNotEmpty ? state.bankName : 'N/A',
            isDark: isDark,
            showDivider: true,
          ),
          if (!isCircleTransaction) ...[
            _buildDetailRow(
              icon: Icons.label_outline_rounded,
              label: 'Category',
              value: widget.transaction.category?.name ?? 'Uncategorized',
              isDark: isDark,
              showDivider: true,
            ),
            _buildDetailRow(
              icon: Icons.edit_outlined,
              label: 'Note',
              value: state.description.isNotEmpty ? state.description : '—',
              isDark: isDark,
              showDivider: true,
            ),
          ],
          _buildDetailRow(
            icon: Icons.circle_outlined,
            label: 'Circle',
            value: 'Not part of any circle',
            valueColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            isItalic: true,
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
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final resolvedValueColor = valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

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
                style: AppTexts.bodyMedium.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: AppTexts.bodyMedium.copyWith(
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
          Divider(height: 1, thickness: 1, color: borderColor, indent: 20.w, endIndent: 20.w),
      ],
    );
  }

  Widget _buildSplitDetailsCard(BuildContext context, bool isDark) {
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    // Mock split data for UI demo
    final splits = [
      _SplitPerson(initials: 'RK', name: 'You (paid)', amount: 3600, share: 1200, color: AppColors.primary, status: 'Paid'),
      _SplitPerson(initials: 'AM', name: 'Amit', amount: 1200, share: 1200, color: AppColors.expense, status: 'Pending'),
      _SplitPerson(initials: 'PR', name: 'Priya', amount: 1200, share: 1200, color: const Color(0xFF7C3AED), status: 'Settled'),
    ];

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
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
            child: Text(
              'Split details',
              style: AppTexts.bodyLarge.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w700,
                fontSize: 17.sp,
              ),
            ),
          ),
          ...splits.map((split) => _buildSplitRow(split, isDark, splits.last == split)),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
            child: Text(
              'Total recovered: ₹1,200 of ₹2,400',
              style: AppTexts.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitRow(_SplitPerson split, bool isDark, bool isLast) {
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    Color statusColor;
    Color statusBgColor;
    switch (split.status) {
      case 'Paid':
        statusColor = Colors.white;
        statusBgColor = AppColors.primary;
        break;
      case 'Pending':
        statusColor = Colors.white;
        statusBgColor = AppColors.expense;
        break;
      case 'Settled':
        statusColor = Colors.white;
        statusBgColor = AppColors.income;
        break;
      default:
        statusColor = Colors.white;
        statusBgColor = AppColors.primary;
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(color: split.color, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  split.initials,
                  style: AppTexts.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              UIHelpers.horizontalSpace(12),
              // Name
              Expanded(
                child: Text(
                  split.name,
                  style: AppTexts.bodyMedium.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Amount + status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    split.status == 'Paid'
                        ? '₹${split.amount.toStringAsFixed(0)}'
                        : 'Owes ₹${split.share.toStringAsFixed(0)}',
                    style: AppTexts.bodyMedium.copyWith(
                      color: split.status == 'Paid'
                          ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                          : AppColors.expense,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (split.status == 'Paid')
                    Text(
                      'Your share: ₹${split.share.toStringAsFixed(0)}',
                      style: AppTexts.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 11.sp,
                      ),
                    ),
                ],
              ),
              UIHelpers.horizontalSpace(10),
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  split.status,
                  style: AppTexts.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, thickness: 1, color: borderColor, indent: 20.w, endIndent: 20.w),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, DetailedTransactionViewModel vm, bool isDark) {
    return Row(
      children: [
        // Edit button (outlined, dark green)
        Expanded(
          child: OutlinedButton(
            onPressed: vm.toggleEditing,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: Text(
              'Edit transaction',
              style: AppTexts.bodyMedium.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        UIHelpers.horizontalSpace(16),
        // Delete button (outlined, terracotta)
        Expanded(
          child: OutlinedButton(
            onPressed: () => _handleDelete(context, vm),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.expense, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: Text(
              'Delete',
              style: AppTexts.bodyMedium.copyWith(
                color: AppColors.expense,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _buildSubtitle(DetailedTransactionState state) {
    final category = widget.transaction.category?.name ?? 'Uncategorized';
    final type = widget.transaction.type == TransactionType.debit ? 'Expense' : 'Income';
    final when = _timeLabel(widget.transaction.date);
    return '$category · $type · $when';
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
    final icon = widget.transaction.category?.icon ?? '';
    switch (icon) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'home':
        return Icons.home_rounded;
      case 'phone':
        return Icons.phone_iphone_rounded;
      case 'salary':
        return Icons.work_rounded;
      case 'transport':
        return Icons.directions_car_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  Future<void> _handleDelete(BuildContext context, DetailedTransactionViewModel vm) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark
            : AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('Delete Transaction', style: AppTexts.heading),
        content: Text(
          'Are you sure you want to delete this transaction? This cannot be undone.',
          style: AppTexts.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: AppTexts.bodyMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.textPrimaryDark : AppColors.primary
            )),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.expense,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text('Delete', style: AppTexts.bodyMedium.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await vm.deleteTransaction();
      if (success && context.mounted) {
        context.pop();
      }
    }
  }
}

// Helper model for split person
class _SplitPerson {
  final String initials;
  final String name;
  final double amount;
  final double share;
  final Color color;
  final String status; // 'Paid', 'Pending', 'Settled'

  const _SplitPerson({
    required this.initials,
    required this.name,
    required this.amount,
    required this.share,
    required this.color,
    required this.status,
  });
}
