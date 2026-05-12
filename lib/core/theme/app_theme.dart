import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // =====================================================
  // BRAND COLORS
  // =====================================================

  // Primary Brand (Teal)
  static const Color primaryLight = Color(0xFF00B894);
  static const Color primaryHover = Color(0xFF009170);
  static const Color primarySoft = Color(0xFFE6FFF8);

  // Accent (Blue - use sparingly)
  static const Color accent = Color(0xFF2962FF);

  // Dark Theme Primary
  static const Color primaryDark = Color(0xFF00B894);

  // =====================================================
  // SEMANTIC COLORS
  // =====================================================

  // Expense (Money Out)
  static const Color expenseLight = Color(0xFFDC2626);
  static const Color expenseBgLight = Color(0xFFFEE2E2);
  static const Color expenseDark = Color(0xFFF87171);

  // Income (Money In)
  static const Color incomeLight = Color(0xFF16A34A);
  static const Color incomeBgLight = Color(0xFFDCFCE7);
  static const Color incomeDark = Color(0xFF4ADE80);

  // Neutral
  static const Color neutralLight = Color(0xFF64748B);
  static const Color neutralBgLight = Color(0xFFF1F5F9);
  static const Color neutralDark = Color(0xFF9CA3AF);

  // =====================================================
  // LIGHT THEME TOKENS
  // =====================================================

  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceSecondaryLight = Color(0xFFF1F5F9);

  static const Color borderLight = Color(0xFFE2E8F0);

  static const Color textPrimaryLight = Color(0xFF121212);
  static const Color textSecondaryLight = Color(0xFF5F6A73);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // =====================================================
  // DARK THEME TOKENS
  // =====================================================

  static const Color bgDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color surfaceElevatedDark = Color(0xFF1F2937);

  static const Color borderDark = Color(0xFF374151);

  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textTertiaryDark = Color(0xFF6B7280);

  // =====================================================
  // LIGHT THEME
  // =====================================================

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Manrope',

      colorScheme: const ColorScheme.light(
        primary: primaryLight,
        secondary: accent,
        onPrimary: Colors.white,
        surface: surfaceLight,
        onSurface: textPrimaryLight,
        error: expenseLight,
        onError: Colors.white,
        outline: borderLight,
      ),

      scaffoldBackgroundColor: bgLight,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimaryLight,
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: textPrimaryLight),
      ),

      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 0,
        shadowColor: Colors.black.withAlpha(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surfaceSecondaryLight,
        selectedColor: primaryLight,
        disabledColor: surfaceSecondaryLight,
        side: const BorderSide(color: borderLight, width: 1),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: textSecondaryLight,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),

      dividerTheme: const DividerThemeData(color: borderLight, thickness: 1),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: bgLight,
        headerBackgroundColor: primaryLight,
        headerForegroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        dayStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        rangeSelectionBackgroundColor: primaryLight.withValues(alpha: 0.15),
        rangePickerHeaderBackgroundColor: primaryLight,
        rangePickerHeaderForegroundColor: Colors.white,
      ),

      timePickerTheme: TimePickerThemeData(
        backgroundColor: bgLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        hourMinuteColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primaryLight.withValues(alpha: 0.12)
              : surfaceSecondaryLight,
        ),
        hourMinuteTextColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primaryLight
              : textPrimaryLight,
        ),
        dialHandColor: primaryLight,
        dialBackgroundColor: surfaceSecondaryLight,
      ),

      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 36.sp,
          fontWeight: FontWeight.w800,
          color: textPrimaryLight,
          letterSpacing: -1.5,
        ),

        headlineMedium: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w800,
          color: textPrimaryLight,
          letterSpacing: -1,
        ),

        titleLarge: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: textPrimaryLight,
        ),

        titleMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: textPrimaryLight,
        ),

        bodyLarge: TextStyle(
          fontSize: 16.sp,
          height: 1.4,
          color: textSecondaryLight,
        ),

        bodyMedium: TextStyle(
          fontSize: 14.sp,
          height: 1.4,
          color: textSecondaryLight,
        ),

        labelLarge: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),

        labelSmall: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: textTertiaryLight,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // =====================================================
  // DARK THEME
  // =====================================================

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Manrope',

      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        secondary: accent,
        onPrimary: Colors.white,
        surface: surfaceDark,
        onSurface: textPrimaryDark,
        error: expenseDark,
        onError: Colors.black,
        outline: borderDark,
      ),

      scaffoldBackgroundColor: bgDark,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimaryDark,
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: textPrimaryDark),
      ),

      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: const BorderSide(color: borderDark, width: 1),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surfaceElevatedDark,
        selectedColor: primaryDark.withAlpha(40),
        disabledColor: surfaceElevatedDark,
        side: const BorderSide(color: borderDark, width: 1),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: textSecondaryDark,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),

      dividerTheme: const DividerThemeData(color: borderDark, thickness: 1),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: bgDark,
        headerBackgroundColor: primaryDark,
        headerForegroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        dayStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        rangeSelectionBackgroundColor: primaryDark.withValues(alpha: 0.25),
        rangePickerHeaderBackgroundColor: primaryDark,
        rangePickerHeaderForegroundColor: Colors.white,
      ),

      timePickerTheme: TimePickerThemeData(
        backgroundColor: bgDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        hourMinuteColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primaryDark.withValues(alpha: 0.2)
              : surfaceElevatedDark,
        ),
        hourMinuteTextColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primaryDark
              : textPrimaryDark,
        ),
        dialHandColor: primaryDark,
        dialBackgroundColor: surfaceElevatedDark,
      ),

      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 36.sp,
          fontWeight: FontWeight.w800,
          color: textPrimaryDark,
          letterSpacing: -1.5,
        ),

        headlineMedium: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w800,
          color: textPrimaryDark,
          letterSpacing: -1,
        ),

        titleLarge: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: textPrimaryDark,
        ),

        titleMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: textPrimaryDark,
        ),

        bodyLarge: TextStyle(
          fontSize: 16.sp,
          height: 1.4,
          color: textSecondaryDark,
        ),

        bodyMedium: TextStyle(
          fontSize: 14.sp,
          height: 1.4,
          color: textSecondaryDark,
        ),

        labelLarge: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),

        labelSmall: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: textTertiaryDark,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // =====================================================
  // HELPERS
  // =====================================================

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getExpenseColor(BuildContext context) {
    return isDark(context) ? expenseDark : expenseLight;
  }

  static Color getIncomeColor(BuildContext context) {
    return isDark(context) ? incomeDark : incomeLight;
  }

  static Color getExpenseBgColor(BuildContext context) {
    return isDark(context) ? expenseDark.withAlpha(25) : expenseBgLight;
  }

  static Color getIncomeBgColor(BuildContext context) {
    return isDark(context) ? incomeDark.withAlpha(25) : incomeBgLight;
  }

  static Color getNeutralColor(BuildContext context) {
    return isDark(context) ? neutralDark : neutralLight;
  }

  static Color getBorderColor(BuildContext context) {
    return isDark(context) ? borderDark : borderLight;
  }

  static Color getSurfaceSecondaryColor(BuildContext context) {
    return isDark(context) ? surfaceElevatedDark : surfaceSecondaryLight;
  }
}
