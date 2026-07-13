import 'package:expense_tracker/features/auth/model/user_payload.dart';
import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_router.dart';
import '../../../../core/utils/ui_helpers.dart';
import 'auth_widgets.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool _obscurePassword = true;

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    // Email → dashboard
    final data = UserPayload(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    final success = await ref.read(authProvider.notifier).signUp(data);
    if (success && mounted) {
      context.push(AppRouter.addAccount);
    } else if (mounted) {
      final error = ref.read(authProvider).errorMessage;
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
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
                      'Create account',
                      style: context.appTexts.displayMedium.copyWith(
                        color: textPrimary,
                        fontSize: 32.sp,
                      ),
                    ),
                    UIHelpers.verticalSpace(6),
                    Text(
                      'Enter your details to get started',
                      style: context.appTexts.bodyMedium.copyWith(
                        color: textSecondary,
                      ),
                    ),
                    UIHelpers.verticalSpace(32),

                    // ── Fields ──
                    Text(
                      'Name',
                      style: context.appTexts.bodySmall.copyWith(
                        color: textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UIHelpers.verticalSpace(8),
                    AuthInputField(
                      controller: _nameController,
                      hint: 'Enter your full name',
                      keyboardType: TextInputType.name,
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                    ),
                    UIHelpers.verticalSpace(20),
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
                      hint: 'Create a password',
                      obscure: _obscurePassword,
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
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
                        context.push(AppRouter.signIn);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: context.appTexts.bodySmall.copyWith(
                            color: textSecondary,
                          ),
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
                      onPressed: authState.isLoading ? null : _onSubmit,
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
                              'CREATE ACCOUNT',
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
