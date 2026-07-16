import 'package:expense_tracker/core/providers/app_message_provider.dart';
import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_router.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../services/validators.dart';
import 'auth_widgets.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final success = await ref
        .read(authProvider.notifier)
        .signIn(_emailController.text.trim(), _passwordController.text.trim());
    if (success && mounted) {
      context.go(AppRouter.transactions);
    } else if (mounted) {
      final error = ref.read(authProvider).errorMessage;
      if (error != null) {
        ref.read(appMessageProvider.notifier).showError(error);
      }
    }
  }

  Future<void> _onGoogleSignIn() async {
    final success = await ref.read(authProvider.notifier).signInWithGoogle();
    if (success && mounted) {
      final isNewUser = ref.read(authProvider).isNewUser;
      if (isNewUser) {
        context.go(AppRouter.addAccount);
      } else {
        context.go(AppRouter.transactions);
      }
    } else if (mounted) {
      final error = ref.read(authProvider).errorMessage;
      if (error != null) {
        ref.read(appMessageProvider.notifier).showError(error);
      }
    }
  }

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
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final authState = ref.watch(authProvider);

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
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: 24.sp,
                  color: textPrimary,
                ),
                alignment: Alignment.centerLeft,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIHelpers.verticalSpace(24),

                    // ── Heading ──
                    Text(
                      'Welcome back',
                      style: context.appTexts.displayMedium.copyWith(
                        color: textPrimary,
                        fontSize: 32.sp,
                      ),
                    ),
                    UIHelpers.verticalSpace(6),
                    Text(
                      'Sign in to continue to Expense Lite',
                      style: context.appTexts.bodyMedium.copyWith(
                        color: textSecondary,
                      ),
                    ),
                    UIHelpers.verticalSpace(32),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: context.appTexts.bodySmall.copyWith(
                              color: textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          UIHelpers.verticalSpace(8),
                          AuthInputField(
                            controller: _emailController,
                            hint: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            validator: Validator.validateEmail,
                            enabled: !authState.isLoading,
                            textInputAction: TextInputAction.next,
                          ),
                          UIHelpers.verticalSpace(20),
                          Text(
                            'Password',
                            style: context.appTexts.bodySmall.copyWith(
                              color: textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          UIHelpers.verticalSpace(8),
                          AuthInputField(
                            controller: _passwordController,
                            hint: 'Enter your password',
                            obscure: _obscurePassword,
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            validator: Validator.validateRequiredField,
                            enabled: !authState.isLoading,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onSignIn(),
                            suffix: GestureDetector(
                              onTap: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20.sp,
                                color: textSecondary,
                              ),
                            ),
                          ),
                          UIHelpers.verticalSpace(12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot password?',
                              style: context.appTexts.bodySmall.copyWith(
                                color: textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    UIHelpers.verticalSpace(32),

                    // ── Social Login ──
                    Row(
                      children: [
                        Expanded(child: Divider(color: borderColor)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'OR',
                            style: context.appTexts.label.copyWith(
                              color: textSecondary,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: borderColor)),
                      ],
                    ),
                    UIHelpers.verticalSpace(24),

                    SizedBox(
                      height: 56.h,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: authState.isLoading ? null : _onGoogleSignIn,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.r),
                          ),
                        ),
                        child: authState.isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                'Continue with Google',
                                style: context.appTexts.bodyMedium.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
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
                        context.push(AppRouter.signup);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: context.appTexts.bodySmall.copyWith(
                            color: textSecondary,
                          ),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Create one',
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
                      onPressed: authState.isLoading ? null : _onSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        elevation: 0,
                      ),
                      child: authState.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'SIGN IN',
                              style: context.appTexts.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                                letterSpacing: 1,
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
