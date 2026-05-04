import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../domain/entities/transaction.dart';

class TransactionIcon extends StatelessWidget {
  final PaymentMethod method;
  final Color color;
  final double? size;
  final bool isVerified;
  final bool showStatus;
  final String? bankName;

  const TransactionIcon({
    super.key,
    required this.method,
    required this.color,
    this.size,
    this.isVerified = true,
    this.showStatus = false,
    this.bankName,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? 22.sp;
    final iconData = getIconData(method);

    final logoPath = bankName != null ? AppConstants.getBankLogo(bankName!) : '';

    Widget iconWidget = Container(
      padding: EdgeInsets.all(logoPath.isNotEmpty ? 8.w : 12.w),
      decoration: BoxDecoration(
        color: logoPath.isNotEmpty ? Colors.white : color.withAlpha(26),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: logoPath.isNotEmpty ? [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ] : null,
      ),
      child: logoPath.isNotEmpty
          ? SvgPicture.asset(logoPath, width: iconSize + 8.w, height: iconSize + 8.w, fit: BoxFit.contain)
          : Icon(iconData, color: color, size: iconSize),
    );

    if (!showStatus) return iconWidget;

    return Stack(
      children: [
        iconWidget,
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isVerified ? Icons.verified_rounded : Icons.warning_amber_rounded,
              color: isVerified
                  ? AppTheme.getIncomeColor(context)
                  : AppTheme.getNeutralColor(context),
              size: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  static IconData getIconData(PaymentMethod method) {
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

class TransactionAmountText extends StatelessWidget {
  final double amount;
  final TransactionType type;
  final TextStyle? style;
  final bool showSign;

  const TransactionAmountText({
    super.key,
    required this.amount,
    required this.type,
    this.style,
    this.showSign = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDebit = type == TransactionType.debit;
    final color = isDebit
        ? AppTheme.getExpenseColor(context)
        : AppTheme.getIncomeColor(context);

    final sign = isDebit ? "-" : "+";
    final formattedAmount = amount.toStringAsFixed(0);

    return Text(
      '${showSign ? sign : ""}₹$formattedAmount',
      style:
          style?.copyWith(color: color) ??
          TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 16.sp),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).textTheme.titleLarge?.color,
            letterSpacing: -0.5,
          ),
        ),
        if (actionLabel != null && onActionPressed != null)
          TextButton(
            onPressed: onActionPressed,
            child: Text(
              actionLabel!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class BankCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? letter;
  final IconData? icon;
  final Color color;

  const BankCard({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.letter,
    this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: GestureDetector(
        onTap: () {
          UIHelpers.lightImpact();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 80.w,
          decoration: BoxDecoration(
            color: isSelected ? color : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? color : AppTheme.getBorderColor(context),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withAlpha(51) // 0.2 * 255
                      : (AppConstants.getBankLogo(label).isNotEmpty ? Colors.white : color.withAlpha(26)),
                  shape: BoxShape.circle,
                ),
                child: AppConstants.getBankLogo(label).isNotEmpty && !isSelected
                    ? ClipOval(
                        child: SvgPicture.asset(
                          AppConstants.getBankLogo(label),
                          width: 24.sp,
                          height: 24.sp,
                          fit: BoxFit.contain,
                        ),
                      )
                    : (letter != null
                        ? Text(
                            letter!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : color,
                              fontWeight: FontWeight.w900,
                              fontSize: 16.sp,
                            ),
                          )
                        : Icon(
                            icon,
                            color: isSelected ? Colors.white : color,
                            size: 20.sp,
                          )),
              ),
              UIHelpers.verticalSpace(8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
