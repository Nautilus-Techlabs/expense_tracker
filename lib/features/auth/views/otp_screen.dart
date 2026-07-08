import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_router.dart';
import '../../../../core/utils/ui_helpers.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _otpLength = 6;
  static const int _resendSeconds = 30;

  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  int _secondsRemaining = _resendSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) { c.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void _onDigitInput(String value, int index) {
    if (value.isNotEmpty) {
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        // Last digit filled — auto-verify
        _verifyOtp();
      }
    }
  }

  void _onBackspace(String value, int index) {
    if (value.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyOtp() {
    // Navigate to dashboard (mock verification)
    context.go(AppRouter.transactions);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back button ──
              Padding(
                padding: EdgeInsets.only(left: 0, top: 8.h),
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.arrow_back_rounded, size: 24.sp, color: textPrimary),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
              UIHelpers.verticalSpace(32),

              // ── Heading ──
              Text(
                'Verify OTP',
                style: context.appTexts.displayMedium.copyWith(
                  color: textPrimary,
                  fontSize: 32.sp,
                ),
              ),
              UIHelpers.verticalSpace(8),
              RichText(
                text: TextSpan(
                  style: context.appTexts.bodyMedium.copyWith(color: textSecondary),
                  children: [
                    const TextSpan(text: 'We sent a 6-digit code to '),
                    TextSpan(
                      text: widget.phoneNumber,
                      style: TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              UIHelpers.verticalSpace(40),

              // ── OTP Boxes ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_otpLength, (i) {
                  final isFilled = _controllers[i].text.isNotEmpty;
                  return _OtpBox(
                    controller: _controllers[i],
                    focusNode: _focusNodes[i],
                    isDark: isDark,
                    borderColor: borderColor,
                    isFilled: isFilled,
                    onChanged: (v) => _onDigitInput(v, i),
                    onBackspace: (v) => _onBackspace(v, i),
                  );
                }),
              ),
              UIHelpers.verticalSpace(32),

              // ── Resend ──
              Center(
                child: Column(
                  children: [
                    Text(
                      "Didn't receive it?",
                      style: context.appTexts.bodySmall.copyWith(color: textSecondary),
                    ),
                    UIHelpers.verticalSpace(4),
                    if (_secondsRemaining > 0)
                      RichText(
                        text: TextSpan(
                          style: context.appTexts.bodySmall.copyWith(color: textSecondary),
                          children: [
                            const TextSpan(text: 'Resend in '),
                            TextSpan(
                              text: '${_secondsRemaining}s',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: _startTimer,
                        child: Text(
                          'Resend OTP',
                          style: context.appTexts.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDark;
  final Color borderColor;
  final bool isFilled;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onBackspace;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.isDark,
    required this.borderColor,
    required this.isFilled,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final activeBorder = isFilled ? AppColors.primary : borderColor;

    return SizedBox(
      width: 50.w,
      height: 60.h,
      child: Container(
        decoration: BoxDecoration(
          color: isFilled ? AppColors.primary.withAlpha(20) : cardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: focusNode.hasFocus ? AppColors.primary : activeBorder,
            width: focusNode.hasFocus || isFilled ? 2 : 1,
          ),
        ),
        child: Center(
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace) {
                onBackspace(controller.text);
              }
            },
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: context.appTexts.displayMedium.copyWith(
                color: isFilled ? AppColors.primary : textPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
