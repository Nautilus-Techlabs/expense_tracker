import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_router.dart';
import '../../../../core/utils/ui_helpers.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // ── Logo & Branding ──
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'F',
                        style: context.appTexts.displayLarge.copyWith(
                          color: Colors.white,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    UIHelpers.verticalSpace(20),
                    Text(
                      'Expense Lite',
                      style: context.appTexts.displayLarge.copyWith(
                        color: textPrimary,
                        fontSize: 36.sp,
                      ),
                    ),
                    UIHelpers.verticalSpace(8),
                    Text(
                      'Your money, your story.',
                      style: context.appTexts.bodyMedium.copyWith(
                        color: textSecondary,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ── Buttons ──
              _PrimaryButton(
                label: 'Create account',
                onTap: () => context.push(AppRouter.signup),
              ),
              UIHelpers.verticalSpace(12),
              _OutlineButton(
                label: 'Sign in',
                onTap: () => context.push(AppRouter.signIn),
                isDark: isDark,
              ),
              UIHelpers.verticalSpace(32),

              // ── Footer ──
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: context.appTexts.bodySmall.copyWith(
                      color: textSecondary,
                      fontSize: 11.sp,
                    ),
                    children: [
                      const TextSpan(text: 'By continuing you agree to our '),
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              UIHelpers.verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.r),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: context.appTexts.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  const _OutlineButton({
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.r),
          ),
        ),
        child: Text(
          label,
          style: context.appTexts.bodyMedium.copyWith(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
