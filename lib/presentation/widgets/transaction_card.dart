import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../domain/entities/transaction.dart';

class TransactionCard extends StatefulWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    final isDebit = widget.transaction.type == TransactionType.debit;
    final color = isDebit ? AppTheme.rose : AppTheme.emerald;
    final icon = _getIcon(widget.transaction.method);
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: theme.dividerColor.withAlpha(13), // 0.05 * 255
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
              extra: widget.transaction,
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildLeadingIcon(color, icon),
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
                            overflow: TextOverflow.ellipsis,
                          ),
                          UIHelpers.verticalSpace(4),
                          Text(
                            DateFormat(
                              'dd MMM, yyyy',
                            ).format(widget.transaction.date),
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withAlpha(128), // 0.5 * 255
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${isDebit ? "-" : "+"}₹${widget.transaction.amount.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: color,
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
                                color: theme.colorScheme.onSurface.withAlpha(
                                  102,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(Color color, IconData icon) {
    return Hero(
      tag: 'transaction_${widget.transaction.rawSms}',
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withAlpha(26), // 0.1 * 255
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: color, size: 22.sp),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.transaction.isVerified
                    ? Icons.verified_rounded
                    : Icons.warning_amber_rounded,
                color: widget.transaction.isVerified
                    ? Colors.green
                    : Colors.amber,
                size: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    final method = widget.transaction.method;
    final isDebit = widget.transaction.type == TransactionType.debit;
    final typeStr = isDebit ? 'Debit' : 'Credit';

    if (method == PaymentMethod.unknown) return typeStr;
    return '${method.name.toUpperCase()} $typeStr';
  }

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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withAlpha(102), // 0.4 * 255
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withAlpha(204), // 0.8 * 255
            ),
          ),
        ],
      ),
    );
  }
}
