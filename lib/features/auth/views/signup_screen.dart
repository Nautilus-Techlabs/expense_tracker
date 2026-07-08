import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_router.dart';
import '../../../../core/utils/ui_helpers.dart';
import 'auth_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPhoneTab = true;
  bool _obscurePassword = true;

  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_isPhoneTab) {
      // Phone → OTP screen
      context.push(AppRouter.verifyOtp, extra: '+91 ${_phoneController.text.trim()}');
    } else {
      // Email → dashboard
      context.go(AppRouter.transactions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Back button ──
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_rounded, size: 24.sp, color: textPrimary),
                alignment: Alignment.centerLeft,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIHelpers.verticalSpace(24),

                    // ── Heading ──
                    Text(
                      'Create account',
                      style: context.appTexts.displayMedium.copyWith(
                        color: textPrimary,
                        fontSize: 32.sp,
                      ),
                    ),
                    UIHelpers.verticalSpace(6),
                    Text(
                      'Enter your details to get started',
                      style: context.appTexts.bodyMedium.copyWith(color: textSecondary),
                    ),
                    UIHelpers.verticalSpace(32),

                    // ── Tab Toggle ──
                    AuthTabToggle(
                      isPhoneSelected: _isPhoneTab,
                      isDark: isDark,
                      onPhoneTap: () => setState(() => _isPhoneTab = true),
                      onEmailTap: () => setState(() => _isPhoneTab = false),
                    ),
                    UIHelpers.verticalSpace(28),

                    // ── Fields ──
                    if (_isPhoneTab) ...[
                      AuthPhoneField(
                        controller: _phoneController,
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                      ),
                    ] else ...[
                      Text('Email',
                          style: context.appTexts.bodySmall.copyWith(
                              color: textSecondary, fontWeight: FontWeight.w600)),
                      UIHelpers.verticalSpace(8),
                      AuthInputField(
                        controller: _emailController,
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                      ),
                      UIHelpers.verticalSpace(20),
                      Text('Password',
                          style: context.appTexts.bodySmall.copyWith(
                              color: textSecondary, fontWeight: FontWeight.w600)),
                      UIHelpers.verticalSpace(8),
                      AuthInputField(
                        controller: _passwordController,
                        hint: 'Create a password',
                        obscure: _obscurePassword,
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        suffix: GestureDetector(
                          onTap: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20.sp,
                            color: textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Bottom: link + button ──
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        context.pop();
                        context.push(AppRouter.signin);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: context.appTexts.bodySmall.copyWith(color: textSecondary),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  UIHelpers.verticalSpace(16),
                  SizedBox(
                    height: 56.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isPhoneTab ? 'Send OTP' : 'CREATE ACCOUNT',
                        style: context.appTexts.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
