import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_notifier.dart';
import '../widgets/transaction_ui_components.dart';

class TransactionCard extends ConsumerStatefulWidget {
  final Transaction transaction;
  final String? heroTag;
  final String? source;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.heroTag,
    this.source,
  });

  @override
  ConsumerState<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends ConsumerState<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);
    final isHistorical = state.isTransactionBeforeOpening(widget.transaction);

    final isDebit = widget.transaction.type == TransactionType.debit;
    final color = isDebit
        ? AppTheme.getExpenseColor(context)
        : AppTheme.getIncomeColor(context);
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isHistorical
            ? theme.colorScheme.surface.withValues(alpha: 0.6)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isHistorical
              ? AppTheme.getBorderColor(context).withValues(alpha: 0.3)
              : AppTheme.getBorderColor(context),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: () {
            UIHelpers.lightImpact();
            context.push(
              AppRouter.transactionDetail,
              extra: {
                'transaction': widget.transaction,
                'heroTag': widget.heroTag,
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                _buildLeadingIcon(color, isHistorical),
                UIHelpers.horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTitle(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      UIHelpers.verticalSpace(4),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 4.h,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            DateFormat(
                              'h:mm a',
                            ).format(widget.transaction.date),
                            style: TextStyle(
                              color: AppTheme.getNeutralColor(context),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (widget.transaction.source ==
                              TransactionSource.manual)
                            _buildTag('MANUAL', theme.colorScheme.primary),
                          if (isHistorical)
                            _buildTag(
                              'HISTORICAL',
                              AppTheme.getNeutralColor(context),
                            ),
                          if (widget.transaction.category != null)
                            _buildTag(
                              widget.transaction.category!.name.toUpperCase(),
                              widget.transaction.category!.color != null
                                  ? Color(widget.transaction.category!.color!)
                                  : theme.colorScheme.primary,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Opacity(
                  opacity: isHistorical ? 0.5 : 1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TransactionAmountText(
                        amount: widget.transaction.amount,
                        type: widget.transaction.type,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16.sp,
                        ),
                      ),
                      if (widget.transaction.availableBalance != null)
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Text(
                            'Bal: ₹${widget.transaction.availableBalance!.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppTheme.getNeutralColor(context),
                              fontWeight: FontWeight.w600,
                            ),
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

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 8.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(Color color, bool isHistorical) {
    final iconWidget = Opacity(
      opacity: isHistorical ? 0.4 : 1.0,
      child: TransactionIcon(
        method: widget.transaction.method,
        color: color,
        isVerified: widget.transaction.isVerified,
        showStatus: true,
      ),
    );

    if (widget.heroTag == null) return iconWidget;

    return Hero(tag: widget.heroTag!, child: iconWidget);
  }

  String _getTitle() {
    if (widget.transaction.merchant != null &&
        widget.transaction.merchant!.isNotEmpty) {
      return widget.transaction.merchant!;
    }
    final isDebit = widget.transaction.type == TransactionType.debit;
    return isDebit ? 'Debit' : 'Credit';
  }
}
