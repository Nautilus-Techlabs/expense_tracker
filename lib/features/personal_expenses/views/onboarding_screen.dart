import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/primary_button.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Placeholder data for the 7 onboarding screens as per the design document.
  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Master Your Money",
      description: "Take control of your spending with automated tracking.",
      icon: Icons.account_balance_wallet_outlined,
    ),
    OnboardingData(
      title: "Smart SMS Sync",
      description: "We securely analyze bank SMS to categorize expenses.",
      icon: Icons.message_outlined,
    ),
    OnboardingData(
      title: "Track Subscriptions",
      description: "Never pay for unwanted subscriptions again.",
      icon: Icons.event_repeat_outlined,
    ),
    OnboardingData(
      title: "Group Expenses",
      description: "Split bills effortlessly with your friends and family.",
      icon: Icons.group_outlined,
    ),
    OnboardingData(
      title: "Detailed Reports",
      description: "Understand your financial habits with clear charts.",
      icon: Icons.pie_chart_outline,
    ),
    OnboardingData(
      title: "Secure & Private",
      description: "Your data stays on your device. Privacy first.",
      icon: Icons.lock_outline,
    ),
    OnboardingData(
      title: "Ready To Start?",
      description: "Grant SMS permission to automate your expense tracking.",
      icon: Icons.rocket_launch_outlined,
    ),
  ];

  Future<void> _handlePermission() async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      _navigateToHome();
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Permission Required"),
            content: const Text(
              "SMS permission is essential for the app to function. Please enable it in settings.",
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  context.pop();
                },
                child: const Text("Settings"),
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("SMS permission is required to continue."),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    }
  }

  void _navigateToHome() {
    context.go(AppRouter.transactions);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(
                    data: _pages[index],
                    isDark: isDark,
                  );
                },
              ),
            ),
            
            // Bottom Controls
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        height: 6.h,
                        width: _currentPage == index ? 24.w : 6.w,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                  ),
                  UIHelpers.verticalSpace(32),

                  // CTA Button
                  PrimaryButton(
                    text: _currentPage == _pages.length - 1 ? "Grant Permission" : "Continue",
                    onPressed: _currentPage == _pages.length - 1
                        ? _handlePermission
                        : () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                  ),

                  // Skip Button (only show if not on last page)
                  if (_currentPage < _pages.length - 1) ...[
                    UIHelpers.verticalSpace(16),
                    TextButton(
                      onPressed: () => _pageController.animateToPage(
                        _pages.length - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ] else ...[
                    UIHelpers.verticalSpace(16.h + 48), // Maintain layout height when skip button is hidden
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final bool isDark;

  const _OnboardingPage({
    required this.data,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder for Lottie Animation
          Container(
            width: 280.w,
            height: 280.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                data.icon,
                size: 80.w,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
          ),
          
          UIHelpers.verticalSpace(48),
          
          // Headline (Playfair Display equivalent)
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppTexts.displayMedium.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
            ),
          ),
          
          UIHelpers.verticalSpace(16),
          
          // Subline (Inter)
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: AppTexts.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
