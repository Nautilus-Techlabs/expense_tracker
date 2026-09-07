import 'package:flutter/material.dart';

// ─────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────

abstract class AppColors {
  // Brand
  static const Color primary = Color(
    0xFF0A3D2E,
  ); // Deep Forest Green — buttons, FAB, active states
  static const Color primaryLight = Color(
    0xFFE8F0ED,
  ); // Light green tint — badges, chip backgrounds

  // Income / Expense
  static const Color income = Color(
    0xFF8BA685,
  ); // Sage green — income amounts, positive balances
  static const Color expense = Color(
    0xFFE87C56,
  ); // Terracotta — expense amounts, negative balances

  // Warning / Status
  static const Color warning = Color(
    0xFFF5A623,
  ); // Amber — due dates, pending badges
  static const Color danger = Color(
    0xFFE87C56,
  ); // Same as expense — delete actions, danger zone

  // Light mode surfaces
  static const Color backgroundLight = Color(
    0xFFFDFCF8,
  ); // Cream — page background
  static const Color cardLight = Color(0xFFFFFFFF); // White — card surfaces
  static const Color borderLight = Color(
    0xFFDDDDDD,
  ); // Light gray — card borders, dividers
  static const Color textPrimaryLight = Color(
    0xFF1A1A1A,
  ); // Near black — primary text
  static const Color textMutedLight = Color(
    0xFF888888,
  ); // Medium gray — captions, labels
  static const Color textSecondaryLight = Color(
    0xFF444444,
  ); // Dark gray — secondary text

  // Dark mode surfaces
  static const Color backgroundDark = Color(
    0xFF121212,
  ); // True dark — page background
  static const Color cardDark = Color(0xFF1E1E1E); // Dark card — card surfaces
  static const Color cardElevatedDark = Color(
    0xFF252525,
  ); // Elevated dark — modals, bottom sheets
  static const Color borderDark = Color(
    0xFF2A2A2A,
  ); // Subtle border — card borders in dark
  static const Color textPrimaryDark = Color(
    0xFFFFFFFF,
  ); // White — primary text
  static const Color textMutedDark = Color(
    0xFF98989F,
  ); // Muted gray — captions in dark mode
  static const Color textSecondaryDark = Color(
    0xFFCCCCCC,
  ); // Light gray — secondary text in dark

  // Semantic backgrounds (tinted surfaces for badges, pills)
  static const Color incomeBg = Color(
    0xFFEBF2EA,
  ); // Sage green tint — income badge bg
  static const Color expenseBg = Color(
    0xFFFAEDE8,
  ); // Terracotta tint — expense badge bg
  static const Color warningBg = Color(
    0xFFFFF8E7,
  ); // Amber tint — warning badge bg

  // Uncategorized
  static const Color uncategorized = Color(
    0xFF98989F,
  ); // Muted gray — Uncategorized category
}

// ─────────────────────────────────────────
// THEME DATA
// ─────────────────────────────────────────

abstract class AppThemeData {
  // ── LIGHT MODE ──
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    fontFamily: 'Inter',

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.income,
      error: AppColors.expense,
      surface: AppColors.cardLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryLight,
      onError: Colors.white,
    ),

    // App bar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textPrimaryLight,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 16,
      centerTitle: false,
    ),

    // Cards
    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderLight, width: 0.5),
      ),
      margin: EdgeInsets.zero,
    ),

    // Dividers
    dividerTheme: const DividerThemeData(
      color: AppColors.borderLight,
      thickness: 0.5,
      space: 0,
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardLight,
      focusColor: AppColors.primary,
      hintStyle: const TextStyle(
        color: AppColors.textMutedLight,
        fontSize: 14,
        fontFamily: 'Inter',
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderLight, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderLight, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    // Text selection
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withAlpha(50),
      selectionHandleColor: AppColors.primary,
    ),

    // FAB
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // Progress indicators
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.borderLight,
      refreshBackgroundColor: AppColors.backgroundLight,
    ),

    // Bottom navigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMutedLight,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
      ),
    ),

    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.cardLight,
      selectedColor: AppColors.primary,
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryLight,
        fontFamily: 'Inter',
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontFamily: 'Inter',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.borderLight, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),

    // Elevated buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    ),

    // Outlined buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    ),

    // Text buttons
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    ),

    // Splash / ripple
    splashColor: AppColors.primary.withAlpha(20),
    highlightColor: AppColors.primary.withAlpha(10),
  );

  // ── DARK MODE ──
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    fontFamily: 'Inter',

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.income,
      error: AppColors.expense,
      surface: AppColors.cardDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryDark,
      onError: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 16,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderDark, width: 0.5),
      ),
      margin: EdgeInsets.zero,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.borderDark,
      thickness: 0.5,
      space: 0,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardDark,
      focusColor: AppColors.primary,
      hintStyle: const TextStyle(
        color: AppColors.textMutedDark,
        fontSize: 14,
        fontFamily: 'Inter',
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderDark, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderDark, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withAlpha(50),
      selectionHandleColor: AppColors.primary,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.borderDark,
      refreshBackgroundColor: AppColors.backgroundDark,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMutedDark,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.cardDark,
      selectedColor: AppColors.primary,
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        fontFamily: 'Inter',
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontFamily: 'Inter',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.borderDark, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    ),

    splashColor: AppColors.primary.withAlpha(20),
    highlightColor: AppColors.primary.withAlpha(10),
  );
}

// ─────────────────────────────────────────
// TEXT STYLES
// ─────────────────────────────────────────

extension AppTextsExtension on BuildContext {
  AppTexts get appTexts => AppTexts(this);
}

class AppTexts {
  final BuildContext context;
  AppTexts(this.context);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _textPrimary =>
      _isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  Color get _textMuted =>
      _isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

  TextStyle get displayLarge => TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 36,
    fontWeight: FontWeight.w500,
    letterSpacing: -1.0,
    color: _textPrimary,
  );

  TextStyle get displayMedium => TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 28,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5,
    color: _textPrimary,
  );

  TextStyle get displaySmall => TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: _textPrimary,
  );

  // ── Headings (Inter)
  // Use for: screen titles, section headings, card titles

  TextStyle get heading => TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: _textPrimary,
    letterSpacing: -0.3,
  );

  TextStyle get headingMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: _textPrimary,
  );

  TextStyle get headingSmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: _textPrimary,
  );

  // ── Body (Inter)
  // Use for: transaction names, account names, form labels

  TextStyle get bodyLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: _textPrimary,
  );

  TextStyle get bodyMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: _textPrimary,
  );

  TextStyle get bodySmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: _textPrimary,
  );

  // ── Captions and labels
  // Use for: category names under transactions, section labels, muted info

  TextStyle get caption => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: _textMuted,
  );

  TextStyle get captionBold => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: _textMuted,
  );

  TextStyle get label => TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: _textMuted,
    letterSpacing: 0.6,
  );

  // ── Amounts — use these for all money values
  // Color is set here, do not override in widgets

  TextStyle get amountIncome => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.income,
  );

  TextStyle get amountExpense => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.expense,
  );

  TextStyle get amountLargeIncome => const TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.income,
    letterSpacing: -0.5,
  );

  TextStyle get amountLargeExpense => const TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.expense,
    letterSpacing: -0.5,
  );

  // ── Navigation labels

  TextStyle get navLabel => TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: _textMuted,
  );

  TextStyle get navLabelActive => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  // ── Buttons

  TextStyle get buttonPrimary => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  TextStyle get buttonSecondary => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  TextStyle get buttonDanger => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.expense,
  );

  // ── Links

  TextStyle get link => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );
}
