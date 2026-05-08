import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/app_router.dart';
import 'core/theme/app_theme.dart';
import 'domain/parsers/flutter_parser_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ CRITICAL: Initialize the Bank Parser Engine
  // Without this, the app doesn't know how to read your bank SMS.
  await FlutterParserInitializer.initialize();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: ExpenseTrackerApp()));
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}
