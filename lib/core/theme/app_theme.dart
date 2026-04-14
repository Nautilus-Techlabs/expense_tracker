import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF0EA5E9); // Sky 500
  static const Color primaryDark = Color(0xFF0369A1); // Sky 700
  static const Color accent = Color(0xFF10B981); // Emerald 500
  static const Color rose = Color(0xFFFB7185); // Rose 400
  static const Color emerald = Color(0xFF34D399); // Emerald 400
  
  // Slate Scale
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        surface: slate50,
      ),
      scaffoldBackgroundColor: slate100,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: slate900,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: slate900),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: slate200, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: primary.withAlpha(26), // 0.1 * 255
        side: const BorderSide(color: slate200, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        labelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w800,
          color: slate900,
          letterSpacing: -1,
        ),
        titleLarge: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: slate800,
        ),
        bodyLarge: TextStyle(fontSize: 16.sp, color: slate700),
        bodyMedium: TextStyle(fontSize: 14.sp, color: slate600),
        labelSmall: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          color: slate400,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        surface: slate800,
        background: slate900,
      ),
      scaffoldBackgroundColor: slate900,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: slate50,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: slate50),
      ),
      cardTheme: CardThemeData(
        color: slate800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: slate700, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: slate800,
        selectedColor: primary.withAlpha(51), // 0.2 * 255
        side: const BorderSide(color: slate700, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        labelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: slate50),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w800,
          color: slate50,
          letterSpacing: -1,
        ),
        titleLarge: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: slate100,
        ),
        bodyLarge: TextStyle(fontSize: 16.sp, color: slate200),
        bodyMedium: TextStyle(fontSize: 14.sp, color: slate300),
        labelSmall: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          color: slate500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
