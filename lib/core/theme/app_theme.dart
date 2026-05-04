import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // --- BRAND COLORS ---
  static const Color primaryLight = Color(0xFF2563EB);
  static const Color primaryHover = Color(0xFF1D4ED8);
  static const Color primarySoft = Color(0xFFDBEAFE);
  static const Color primaryDark = Color(0xFF3B82F6);

  // --- SEMANTIC COLORS ---
  // Expense (Money out)
  static const Color expenseLight = Color(0xFFDC2626);
  static const Color expenseBgLight = Color(0xFFFEE2E2);
  static const Color expenseDark = Color(0xFFF87171);

  // Income (Money in)
  static const Color incomeLight = Color(0xFF16A34A);
  static const Color incomeBgLight = Color(0xFFDCFCE7);
  static const Color incomeDark = Color(0xFF4ADE80);

  // Neutral (Non-financial)
  static const Color neutralLight = Color(0xFF64748B);
  static const Color neutralBgLight = Color(0xFFF1F5F9);
  static const Color neutralDark = Color(0xFF9CA3AF);

  // --- LIGHT THEME TOKENS ---
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceSecondaryLight = Color(0xFFF1F5F9);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // --- DARK THEME TOKENS ---
  static const Color bgDark = Color(0xFF0B1220);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color surfaceElevatedDark = Color(0xFF1F2937);
  static const Color borderDark = Color(0xFF374151);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF6B7280);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryLight,
        onPrimary: Colors.white,
        surface: surfaceLight,
        onSurface: textPrimaryLight,
        error: expenseLight,
        onError: Colors.white,
        outline: borderLight,
      ),
      scaffoldBackgroundColor: bgLight,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimaryLight,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: textPrimaryLight),
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceSecondaryLight,
        selectedColor: primarySoft,
        side: const BorderSide(color: borderLight, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        labelStyle: TextStyle(
          fontSize: 12.sp, 
          fontWeight: FontWeight.w500, 
          color: textSecondaryLight,
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w800,
          color: textPrimaryLight,
          letterSpacing: -1,
        ),
        titleLarge: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: textPrimaryLight,
        ),
        bodyLarge: TextStyle(fontSize: 16.sp, color: textSecondaryLight),
        bodyMedium: TextStyle(fontSize: 14.sp, color: textSecondaryLight),
        labelSmall: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          color: textTertiaryLight,
          letterSpacing: 1.2,
        ),
      ),
      dividerTheme: const DividerThemeData(color: borderLight, thickness: 1),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        onPrimary: Colors.white,
        surface: surfaceDark,
        onSurface: textPrimaryDark,
        error: expenseDark,
        onError: Colors.black,
        outline: borderDark,
      ),
      scaffoldBackgroundColor: bgDark,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimaryDark,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: textPrimaryDark),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: borderDark, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceElevatedDark,
        selectedColor: primaryDark.withAlpha(51),
        side: const BorderSide(color: borderDark, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        labelStyle: TextStyle(
          fontSize: 12.sp, 
          fontWeight: FontWeight.w500, 
          color: textSecondaryDark,
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w800,
          color: textPrimaryDark,
          letterSpacing: -1,
        ),
        titleLarge: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: textPrimaryDark,
        ),
        bodyLarge: TextStyle(fontSize: 16.sp, color: textSecondaryDark),
        bodyMedium: TextStyle(fontSize: 14.sp, color: textSecondaryDark),
        labelSmall: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          color: textTertiaryDark,
          letterSpacing: 1.2,
        ),
      ),
      dividerTheme: const DividerThemeData(color: borderDark, thickness: 1),
    );
  }
  
  // Helper for semantic colors based on context
  static Color getExpenseColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? expenseLight : expenseDark;
  }
  
  static Color getIncomeColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? incomeLight : incomeDark;
  }

  static Color getExpenseBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? expenseBgLight
        : expenseDark.withAlpha(26); // Soft dark red
  }

  static Color getIncomeBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? incomeBgLight
        : incomeDark.withAlpha(26); // Soft dark green
  }
  
  static Color getNeutralColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? neutralLight : neutralDark;
  }

  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? borderLight : borderDark;
  }

  static Color getSurfaceSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? surfaceSecondaryLight : surfaceElevatedDark;
  }
}
