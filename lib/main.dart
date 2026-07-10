import 'package:expense_tracker/core/utils/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_router.dart';
import 'core/theme/app_theme.dart';

import 'core/theme/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Parser engine initialization removed.

  await Supabase.initialize(
    url: AppSecrets.apiUrl,
    publishableKey: AppSecrets.publishableKey,
  );

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: ExpenseTrackerApp()));
}

class ExpenseTrackerApp extends ConsumerWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          title: 'Expense Tracker',
          debugShowCheckedModeBanner: false,

          // Light Theme
          theme: AppTheme.light,

          // Dark Theme
          darkTheme: AppTheme.dark,

          // System Theme Mode
          themeMode: themeMode,
        );
      },
    );
  }
}
