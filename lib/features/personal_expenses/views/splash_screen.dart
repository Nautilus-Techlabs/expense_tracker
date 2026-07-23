import 'package:expense_tracker/core/utils/ui_helpers.dart';

import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../viewmodels/account_notifier.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_router.dart';
import '../../../../core/theme/app_colors_extension.dart';
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

  void _checkNavigation() async {
    final authState = ref.read(authProvider);
    if (!_timerFinished || authState.isLoading) return;

    if (authState.user != null) {
      await ref.read(accountProvider.notifier).fetchAccounts();
      final accountState = ref.read(accountProvider);
      
      if (!mounted) return;

      if (accountState.errorMessage != null) {
        // Safe navigation on network failure -> show main screen, don't force account creation
        context.pushReplacement(AppRouter.transactions);
      } else if (accountState.accounts.isEmpty) {
        context.pushReplacement(AppRouter.addAccount);
      } else {
        context.pushReplacement(AppRouter.transactions);
      }
    } else {
      context.pushReplacement(AppRouter.welcome);
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

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.card,
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
              'Expense Lite',
              style: context.appTexts.displayLarge.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
