import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:expense_tracker/core/constants/app_router.dart';
import 'dart:math' as math;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Master Your Finances",
      description:
          "Take control of your spending with automated tracking and smart insights.",
      icon: Icons.account_balance_wallet_rounded,
      color: AppTheme.primary,
    ),
    OnboardingData(
      title: "Smart SMS Sync",
      description:
          "We securely analyze your bank SMS to automatically categorize your expenses without any manual entry.",
      icon: Icons.auto_graph_rounded,
      color: AppTheme.accent,
    ),
    OnboardingData(
      title: "Privacy First",
      description:
          "Your data stays on your device. We only read transaction SMS to help you track your budget.",
      icon: Icons.security_rounded,
      color: AppTheme.rose,
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
            backgroundColor: AppTheme.rose,
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
      body: Stack(
        children: [
          // Background Gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        _pages[_currentPage].color.withAlpha(40),
                        AppTheme.slate900,
                      ]
                    : [
                        _pages[_currentPage].color.withAlpha(20),
                        AppTheme.slate50,
                      ],
              ),
            ),
          ),

          // Content
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _OnboardingPage(data: _pages[index]);
                  },
                ),
              ),

              // Bottom Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
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
                          height: 8.h,
                          width: _currentPage == index ? 24.w : 8.w,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? _pages[_currentPage].color
                                : (isDark
                                      ? AppTheme.slate700
                                      : AppTheme.slate300),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: _currentPage == _pages.length - 1
                            ? _handlePermission
                            : () => _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pages[_currentPage].color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? "Grant Permission"
                              : "Next",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    if (_currentPage < _pages.length - 1) ...[
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: () => _pageController.animateToPage(
                          _pages.length - 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        ),
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color: isDark
                                ? AppTheme.slate400
                                : AppTheme.slate500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Illustration
          Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: data.color.withAlpha(isDark ? 30 : 20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated Rings
                _AnimatedRings(color: data.color),

                // Icon
                Icon(data.icon, size: 80.w, color: data.color),
              ],
            ),
          ),
          SizedBox(height: 60.h),

          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppTheme.slate900,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: isDark ? AppTheme.slate400 : AppTheme.slate600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedRings extends StatefulWidget {
  final Color color;

  const _AnimatedRings({required this.color});

  @override
  State<_AnimatedRings> createState() => _AnimatedRingsState();
}

class _AnimatedRingsState extends State<_AnimatedRings>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(200.w, 200.w),
          painter: _RingPainter(
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final ringProgress = (progress + i / 3) % 1.0;
      final radius = (size.width / 2) * ringProgress;
      final opacity = 1.0 - ringProgress;

      paint.color = color.withAlpha((opacity * 100).toInt());
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
