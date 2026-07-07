import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/theme/app_theme.dart';
import 'common/app_primary_button.dart';

class EmptyStateView extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback onRetry;
  final bool isError;
  final IconData? icon;
  final String? actionLabel;

  const EmptyStateView({
    super.key,
    this.title,
    this.message = 'No transactions found.\nTap sync to check your SMS.',
    required this.onRetry,
    this.isError = false,
    this.icon,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = isError
        ? AppTheme.getExpenseColor(context)
        : colorScheme.primary;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ??
                      (isError
                          ? Icons.error_outline_rounded
                          : Icons.account_balance_wallet_outlined),
                  size: 64.sp,
                  color: primaryColor.withValues(alpha: 0.6),
                ),
              ),
              UIHelpers.verticalSpace(24),
              Text(
                title ??
                    (isError ? 'Oops! Something went wrong' : 'Start Tracking'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              UIHelpers.verticalSpace(12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.getNeutralColor(context),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              UIHelpers.verticalSpace(32),
              AppPrimaryButton(
                label: actionLabel ?? (isError ? 'Retry Sync' : 'Sync Now'),
                onPressed: onRetry,
                backgroundColor: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
