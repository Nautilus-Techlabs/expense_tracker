import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/presentation/screens/transaction_list_screen.dart';
import 'package:expense_tracker/presentation/screens/onboarding_screen.dart';
import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _ringController;
  late AnimationController _iconController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late AnimationController _shimmerController;

  // Ring animations
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;

  // Icon animations
  late Animation<double> _iconScale;
  late Animation<double> _iconOpacity;
  late Animation<double> _iconRotation;

  // Text animations
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;

  // Shimmer
  late Animation<double> _shimmerPosition;

  @override
  void initState() {
    super.initState();

    // ── Ring pulse animation ──
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _ringScale = Tween<double>(begin: 0.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _ringOpacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // ── Icon entrance animation ──
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _iconScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.15,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(_iconController);

    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _iconRotation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // ── Text stagger animation ──
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
          ),
        );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
      ),
    );

    _taglineSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    // ── Floating particles ──
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // ── Shimmer sweep ──
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _shimmerPosition = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // ── Orchestrate animations ──
    _startAnimationSequence();

    // Navigate to home after splash
    Timer(const Duration(milliseconds: 4500), _navigateToHome);
  }

  void _startAnimationSequence() async {
    // 1. Ring pulse starts immediately
    _ringController.forward();

    // 2. Icon drops in after a tiny delay
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _iconController.forward();

    // 3. Particles float up
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _particleController.forward();

    // 4. Text slides in after icon settles
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _textController.forward();

    // 5. Shimmer sweep on the icon
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _shimmerController.forward();
  }

  void _navigateToHome() async {
    if (!mounted) return;

    final status = await Permission.sms.status;
    final bool isGranted = status.isGranted;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (context, animation, secondaryAnimation) {
            return isGranted
                ? const TransactionListScreen()
                : const OnboardingScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeIn,
            );
            final scale = Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return FadeTransition(
              opacity: fade,
              child: ScaleTransition(scale: scale, child: child),
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _ringController.dispose();
    _iconController.dispose();
    _textController.dispose();
    _particleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 1.0],
            colors: isDark
                ? [
                    const Color(0xFF0A1628),
                    const Color(0xFF0F172A),
                    const Color(0xFF0A1628),
                  ]
                : [
                    const Color(0xFFF0F9FF),
                    const Color(0xFFE0F2FE),
                    const Color(0xFFF0F9FF),
                  ],
          ),
        ),
        child: Stack(
          children: [
            // ── Background floating particles ──
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _ParticlePainter(
                    progress: _particleController.value,
                    isDark: isDark,
                  ),
                );
              },
            ),

            // ── Main content ──
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Pulsing ring + Icon ──
                  SizedBox(
                    width: 180.w,
                    height: 180.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ring pulse
                        AnimatedBuilder(
                          animation: _ringController,
                          builder: (context, _) {
                            return Transform.scale(
                              scale: _ringScale.value,
                              child: Container(
                                width: 140.w,
                                height: 140.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.primary.withAlpha(
                                      (_ringOpacity.value * 150).toInt(),
                                    ),
                                    width: 2.5,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Icon container with shimmer
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            _iconController,
                            _shimmerController,
                          ]),
                          builder: (context, child) {
                            return Opacity(
                              opacity: _iconOpacity.value,
                              child: Transform.scale(
                                scale: _iconScale.value,
                                child: Transform.rotate(
                                  angle: _iconRotation.value,
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: _buildLogoIcon(isDark),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // ── Title ──
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _titleOpacity.value,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      'Expense Tracker',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                        color: isDark ? AppTheme.slate50 : AppTheme.slate900,
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // ── Tagline ──
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _taglineOpacity.value,
                        child: SlideTransition(
                          position: _taglineSlide,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      'Track  •  Save  •  Grow',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 3,
                        color: isDark ? AppTheme.slate400 : AppTheme.slate500,
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

  Widget _buildLogoIcon(bool isDark) {
    return Container(
      width: 130.w,
      height: 130.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0F172A), // Match logo background
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppTheme.primary : AppTheme.primaryDark).withAlpha(
              60,
            ),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
      ),
    );
  }
}

/// Custom painter for floating particle dots
class _ParticlePainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _ParticlePainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // Fixed seed for consistent positions
    final paint = Paint();

    for (int i = 0; i < 20; i++) {
      final startX = random.nextDouble() * size.width;
      final startY =
          size.height * 0.3 + random.nextDouble() * size.height * 0.5;
      final radius = 2.0 + random.nextDouble() * 3.0;

      // Each particle has a staggered start
      final particleDelay = random.nextDouble() * 0.4;
      final particleProgress =
          ((progress - particleDelay) / (1.0 - particleDelay)).clamp(0.0, 1.0);

      if (particleProgress <= 0) continue;

      final currentY = startY - (particleProgress * size.height * 0.3);
      final currentX = startX + sin(particleProgress * pi * 2) * 15;
      final opacity = (sin(particleProgress * pi) * 0.5).clamp(0.0, 1.0);

      paint.color = (isDark ? AppTheme.primary : AppTheme.accent).withAlpha(
        (opacity * 100).toInt(),
      );

      canvas.drawCircle(Offset(currentX, currentY), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
