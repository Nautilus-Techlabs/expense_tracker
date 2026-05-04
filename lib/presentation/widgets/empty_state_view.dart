import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/theme/app_theme.dart';

class EmptyStateView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isError;

  const EmptyStateView({
    super.key,
    this.message = 'No transactions found.\nTap sync to check your SMS.',
    required this.onRetry,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: (isError ? AppTheme.getExpenseColor(context) : Theme.of(context).colorScheme.primary).withAlpha(13),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isError ? Icons.error_outline_rounded : Icons.account_balance_wallet_outlined,
                size: 64.sp,
                color: (isError ? AppTheme.getExpenseColor(context) : Theme.of(context).colorScheme.primary).withAlpha(128),
              ),
            ),
            UIHelpers.verticalSpace(24),
            Text(
              isError ? 'Oops! Something went wrong' : 'Start Tracking',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  UIHelpers.mediumImpact();
                  onRetry();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isError ? 'Retry Sync' : 'Sync Now',
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
    );
  }
}
