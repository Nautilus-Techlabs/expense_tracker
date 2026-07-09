import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _timerFinished = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() => _timerFinished = true);
        _checkNavigation();
      }
    });
  }

  void _checkNavigation() {
    final authState = ref.read(authProvider);
    if (!_timerFinished || authState.isLoading) return;

    if (authState.user != null) {
      context.go(AppRouter.transactions);
    } else {
      context.go(AppRouter.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch authProvider to trigger _checkNavigation when isLoading changes
    ref.listen(authProvider, (previous, next) {
      if (!next.isLoading) {
        _checkNavigation();
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(40),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 60.sp,
                      color: AppColors.primary,
                    );
                  },
                ),
              ),
            ),
            UIHelpers.verticalSpace(24),
            Text(
              'Finia',
              style: context.appTexts.displayLarge.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
