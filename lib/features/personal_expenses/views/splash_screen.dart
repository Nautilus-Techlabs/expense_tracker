import 'package:expense_tracker/core/utils/app_logger.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/data/remote/supabase/supabase_helper.dart';
import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:expense_tracker/services/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_router.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../viewmodels/account_notifier.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _timerFinished = false;
  bool _isInitializing = false;
  bool _isAppInitialized = false;
  bool _isNoConnectionDialogOpen = false;
  bool _isForceUpdateDialogOpen = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() => _timerFinished = true);
        if (_isAppInitialized) {
          _checkNavigation();
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    if (_isInitializing || _isAppInitialized) return;

    final isConnected = ref.read(connectivityStreamProvider).value ?? true;
    if (!isConnected) {
      _showNoConnectionDialog();
      return;
    }

    _dismissNoConnectionDialog();

    setState(() => _isInitializing = true);

    try {
      final needsUpdate = await _checkAppVersion();
      if (needsUpdate) {
        setState(() => _isInitializing = false);
        return;
      }

      if (mounted) {
        setState(() {
          _isAppInitialized = true;
          _isInitializing = false;
        });
        _checkNavigation();
      }
    } catch (e) {
      AppLogger.e("Initialization error: $e");
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  Future<bool> _checkAppVersion() async {
    try {
      final status = await SupabaseHelper().appVersionCheck();
      if (status == AppVersionStatus.needsUpdate) {
        _showForceUpdateDialog();
        return true;
      }
    } catch (e) {
      debugPrint("App version check failed: $e");
      AppLogger.e("Failed to check app version.");
    }
    return false;
  }

  void _showNoConnectionDialog() {
    if (_isNoConnectionDialogOpen || !mounted) return;
    _isNoConnectionDialogOpen = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: ctx.colors.danger, size: 28.sp),
            UIHelpers.horizontalSpace(12),
            Expanded(
              child: Text(
                'No Connection',
                style: ctx.appTexts.headingSmall.copyWith(
                  color: ctx.colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Please check your internet connection to continue using Expense Lite.',
          style: ctx.appTexts.bodyMedium.copyWith(
            color: ctx.colors.textSecondary,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _isNoConnectionDialogOpen = false;
              _initializeApp();
            },
            child: Text(
              'Retry',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    ).then((_) {
      _isNoConnectionDialogOpen = false;
    });
  }

  void _dismissNoConnectionDialog() {
    if (_isNoConnectionDialogOpen && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      _isNoConnectionDialogOpen = false;
    }
  }

  void _showForceUpdateDialog() {
    if (_isForceUpdateDialogOpen || !mounted) return;
    _isForceUpdateDialogOpen = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.system_update_rounded,
              color: AppColors.primary,
              size: 28.sp,
            ),
            UIHelpers.horizontalSpace(12),
            Expanded(
              child: Text(
                'Update Required',
                style: ctx.appTexts.headingSmall.copyWith(
                  color: ctx.colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Your app version is outdated. Please update to continue using the app.',
          style: ctx.appTexts.bodyMedium.copyWith(
            color: ctx.colors.textSecondary,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: _launchAppStore,
            child: Text(
              'Update Now',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _launchAppStore() async {
    const url =
        "https://play.google.com/store/apps/details?id=com.nt.expensetracker";
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppLogger.e('Unable to open the app store.');
    }
  }

  void _checkNavigation() async {
    final authState = ref.read(authProvider);
    if (!_timerFinished || !_isAppInitialized || authState.isLoading) return;

    if (authState.user != null) {
      await ref.read(accountProvider.notifier).fetchAccounts();
      final accountState = ref.read(accountProvider);

      if (!mounted) return;

      if (accountState.errorMessage != null) {
        // Safe navigation on network failure -> show main screen, don't force account creation
        context.pushReplacement(AppRouter.transactions);
      } else if (accountState.accounts.isEmpty) {
        context.pushReplacement(AppRouter.addAccount);
      } else {
        context.pushReplacement(AppRouter.transactions);
      }
    } else {
      context.pushReplacement(AppRouter.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(connectivityStreamProvider, (previous, next) {
      final isConnected = next.value ?? false;
      if (isConnected) {
        _dismissNoConnectionDialog();
        _initializeApp();
      } else {
        _showNoConnectionDialog();
      }
    });

    // Watch authProvider to trigger _checkNavigation when isLoading changes
    ref.listen(authProvider, (previous, next) {
      if (!next.isLoading) {
        _checkNavigation();
      }
    });

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.card,
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
            UIHelpers.verticalSpace(24),
            Text(
              'Expense Lite',
              style: context.appTexts.displayLarge.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
