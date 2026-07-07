import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/notification_service.dart';
import '../viewmodels/transaction_notifier.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), _navigateToHome);
  }

  void _navigateToHome() async {
    if (!mounted) return;

    // Check SMS permissions
    final status = await Permission.sms.status;
    final bool isGranted = status.isGranted;

    // Request notification permission after SMS check
    await NotificationService.instance.initialize();

    if (isGranted) {
      // Ensure data is loaded (it should have started in transactionProvider's build)
      // We wait for isLoading to become false
      bool isLoading = ref.read(transactionProvider).isLoading;
      if (isLoading) {
        // Wait until it's not loading anymore (or timeout after 5 more seconds)
        int retries = 0;
        while (mounted &&
            ref.read(transactionProvider).isLoading &&
            retries < 50) {
          await Future.delayed(const Duration(milliseconds: 100));
          retries++;
        }
      }
    }

    if (mounted) {
      context.go(isGranted ? AppRouter.transactions : AppRouter.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Simple Logo Presentation
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
            SizedBox(height: 24.h),
            Text(
              'Finia',
              style: AppTexts.displayLarge.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
