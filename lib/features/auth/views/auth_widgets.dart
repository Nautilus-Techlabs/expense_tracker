/// Shared auth widgets used by SignInScreen and SignUpScreen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';

class AuthTabToggle extends StatelessWidget {
  final bool isPhoneSelected;
  final bool isDark;
  final VoidCallback onPhoneTap;
  final VoidCallback onEmailTap;

  const AuthTabToggle({
    super.key,
    required this.isPhoneSelected,
    required this.isDark,
    required this.onPhoneTap,
    required this.onEmailTap,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveColor = isDark ? AppColors.cardDark : const Color(0xFFEDEDE8);
    return Container(
      height: 44.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: inactiveColor,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'Phone',
            selected: isPhoneSelected,
            onTap: onPhoneTap,
            isDark: isDark,
          ),
          _TabItem(
            label: 'Email & Password',
            selected: !isPhoneSelected,
            onTap: onEmailTap,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected
                ? (isDark ? AppColors.backgroundDark : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.appTexts.bodySmall.copyWith(
              color: selected
                  ? (isDark ? AppColors.textPrimaryDark : AppColors.primary)
                  : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class AuthPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;

  const AuthPhoneField({
    super.key,
    required this.controller,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              '+91',
              style: context.appTexts.bodyMedium.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(width: 1, height: 28.h, color: borderColor),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: context.appTexts.bodyMedium.copyWith(color: textPrimary),
              decoration: InputDecoration(
                hintText: 'Mobile number',
                hintStyle: context.appTexts.bodyMedium.copyWith(
                  color: textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    this.validator,
    this.enabled = true,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    return Container(
      // Allow dynamic height when error text appears
      constraints: BoxConstraints(minHeight: 56.h),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: enabled
            ? cardBg
            : (isDark ? Colors.grey[850] : Colors.grey[200]),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              enabled: enabled,
              validator: validator,
              textInputAction: textInputAction,
              onFieldSubmitted: onFieldSubmitted,
              style: context.appTexts.bodyMedium.copyWith(color: textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: context.appTexts.bodyMedium.copyWith(
                  color: textSecondary,
                ),
                border: InputBorder.none,
                errorStyle: TextStyle(height: 0.8), // Keep error text compact
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
              ),
            ),
          ),
          if (suffix != null)
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: suffix,
            ),
        ],
      ),
    );
  }
}
