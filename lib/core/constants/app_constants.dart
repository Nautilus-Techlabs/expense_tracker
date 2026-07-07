import 'package:flutter/material.dart';

class AppConstants {
  static const bool debugUseSampleData = true;

  static const List<String> debitKeywords = [
    'debited',
    'spent',
    'withdrawn',
    'paid',
    'transfer',
    'txn',
    'purchase',
    'payment',
    'dr',
    'wdl',
    'deducted',
    'sent',
    'using',
    'done',
    'transferred',
  ];

  static const List<String> creditKeywords = [
    'credited',
    'received',
    'refund',
    'deposited',
    'added',
    'cr',
    'inbound',
    'deposit',
    'cashback',
  ];

  static String get debitKeywordsRegex => '(?:${debitKeywords.join('|')})';
  static String get creditKeywordsRegex => '(?:${creditKeywords.join('|')})';

  /// Words that indicate an SMS is not a transaction (OTP, Password, etc.)
  /// We include non-bank payment apps here to prevent them from being parsed
  /// as banks when they are just the medium.
  static const List<String> exclusionKeywords = [
    "otp",
    "code",
    "password",
    "due on",
    "login",
    "verify",
    "offers",
    "discount",
    "failed",
    "declined",
    "unsuccessful",
    "insufficient funds",
    "rejected",
    "get flat",
    "on your next",
    "win",
    "promo",
    "use code",
    "mandate",
    "consolidated charges",
    "hold for",
    "we have received payment",
    "credited to beneficiary",
    "using a bank-specific app",
    "towards service number",
    "received payment",
    "towards your sip",
    "units at nav",
  ];

  /// Common senders that should be ignored entirely as they are not banks
  static const List<String> ignoredSenders = [
    "PHONEPE",
    "PAYTM",
    "GPAY",
    "ZOMATO",
    "SWIGGY",
    "UBER",
    "OLA",
  ];

  /// Common words to remove from merchant names to get a clean name
  static const List<String> merchantCleanPrefixes = [
    "at",
    "to",
    "towards",
    "from",
    "for",
    "info",
    "vpa",
    "on",
    "by",
  ];

  /// Common business suffixes to remove for cleaner UI
  static const List<String> merchantCleanSuffixes = [
    "pvt ltd",
    "private limited",
    "ltd",
    "limited",
  ];

  /// Words that, if they appear alone or as the start of a merchant name,
  /// indicate the captured name is likely garbage/noise.
  static const List<String> merchantBlacklist = [
    "account",
    "bank",
    "savings",
    "current",
    "ending",
    "a/c",
    "card",
    "rs",
    "inr",
    "your",
    "any",
    "queries",
    "please",
    "contact",
    "support",
    "available",
    "balance",
    "avl",
    "bal",
    "clear",
    "new",
    "total",
    "dispute",
    "dial",
    "call",
    "sms",
    "no",
    "is",
    "dear",
    "with",
    "credited",
    "debited",
    "info",
    "vpa",
    "upi",
    "txn",
    "ref",
    "services",
    "other services",
    "call",
    "support",
  ];

  /// Hard block keywords that immediately invalidate a merchant name
  static const List<String> merchantHardBlockKeywords = [
    "ref",
    "txn",
    "no",
    "imps",
    "upi",
  ];

  /// Priority prefixes for merchant extraction (typically debits)
  static const List<String> merchantPriorityPrefixes = [
    "at",
    "spent at",
    "at the",
    "to",
    "towards",
    "for",
    "using",
    "trf to",
    "transfer to",
    "paid to",
    "spent at",
    "sent to",
    "into",
    "toll paid",
  ];

  /// Secondary prefixes for merchant extraction (typically credits)
  static const List<String> merchantSecondaryPrefixes = [
    "transfer from",
    "from beneficiary",
    "beneficiary",
    "from",
  ];

  /// Words that signal the end of a merchant name in an SMS
  static const List<String> merchantStopWords = [
    "on",
    "at",
    "for",
    "via",
    "using",
    "Ref",
    "Refno",
    "UTR",
  ];

  /// Regex part for allowed characters in a merchant name
  static const String merchantNameChars = r"[a-zA-Z0-9\s\-\.&/]";

  static String get merchantPriorityRegex {
    final prefixes = merchantPriorityPrefixes
        .map((p) => p.replaceAll(' ', '\\s+'))
        .join('|');
    final stopWords = merchantStopWords.join('|');
    return "(?:$prefixes)\\s+($merchantNameChars+?)(?:\\s+(?:$stopWords)|\\.|\\\$|;)";
  }

  static String get merchantSecondaryRegex {
    final prefixes = merchantSecondaryPrefixes
        .map((p) => p.replaceAll(' ', '\\s+'))
        .join('|');
    final stopWords = merchantStopWords.join('|');
    return "(?:$prefixes)\\s+($merchantNameChars+?)(?:\\s+(?:$stopWords)|\\.|\\\$|;)";
  }

  /// Regex pattern for common payment methods
  static const String paymentMethodPattern = r'(UPI|Card|ATM|NEFT|RTGS|IMPS)';

  /// Regex pattern for account number fallback extraction
  static const String accountFallbackPattern =
      r'(?:\bA/c\s*(?:no\.?)?\s*|\bAcct?\s*(?:No\.?)?\s*|\bSavings\s*No\s*|\bending\s*|[\*X]{2,})[\s\.]*([X\*]*\d{4,6})';

  static String getBankLogo(String bankName) {
    final name = bankName.toLowerCase();
    if (name.contains('hdfc')) return 'assets/bank_logos/hdfc_bank.svg';
    if (name.contains('icici')) return 'assets/bank_logos/icici_bank.svg';
    if (name.contains('sbi') || name.contains('state bank')) {
      return 'assets/bank_logos/state_bank_of_india.svg';
    }
    if (name.contains('axis')) return 'assets/bank_logos/axis_bank.svg';
    if (name.contains('kotak')) {
      return 'assets/bank_logos/kotak_mahindra_bank.svg';
    }
    if (name.contains('yes')) return 'assets/bank_logos/yes_bank.svg';
    if (name.contains('pnb') || name.contains('punjab national')) {
      return 'assets/bank_logos/punjab_national_bank.svg';
    }
    if (name.contains('idfc')) return 'assets/bank_logos/idfc_bank.svg';
    if (name.contains('idbi')) return 'assets/bank_logos/idbi_bank.svg';
    if (name.contains('hsbc')) return 'assets/bank_logos/hsbc_bank.svg';
    if (name.contains('citi')) return 'assets/bank_logos/citi_bank.svg';
    if (name.contains('paytm')) {
      return 'assets/bank_logos/paytm_payments_bank.svg';
    }
    if (name.contains('jio')) {
      return 'assets/bank_logos/jio_payments_bank.svg';
    }
    if (name.contains('cred')) {
      return 'assets/bank_logos/cred.svg';
    }
    if (name.contains('south indian') || name.contains('south india')) {
      return 'assets/bank_logos/south_indian_bank.svg';
    }
    if (name.contains('indian overseas')) {
      return 'assets/bank_logos/indian_overseas_bank.svg';
    }
    if (name.contains('indian bank')) {
      return 'assets/bank_logos/indian_bank.svg';
    }
    if (name.contains('indusind') || name.contains('induslnd')) {
      return 'assets/bank_logos/induslnd_bank.svg';
    }
    if (name.contains('india post') || name.contains('ippb')) {
      return 'assets/bank_logos/india_post_payments_bank.svg';
    }
    if (name.contains('uco')) return 'assets/bank_logos/uco_bank.svg';
    if (name.contains('union')) return 'assets/bank_logos/union_bank.svg';
    if (name.contains('canara')) return 'assets/bank_logos/canara_bank.svg';
    if (name.contains('airtel')) {
      return 'assets/bank_logos/airtel_payments_bank.svg';
    }
    if (name.contains('au small') || name.contains('au bank')) {
      return 'assets/bank_logos/au_small_finance_bank.svg';
    }
    if (name.contains('baroda') || name.contains('bob')) {
      return 'assets/bank_logos/bank_of_baroda.svg';
    }
    if (name.contains('bank of india') || name.contains('boi')) {
      return 'assets/bank_logos/bank_of_india.svg';
    }
    if (name.contains('jammu & kashmir bank') || name.contains('jk')) {
      return 'assets/bank_logos/jammu_&_kashmir_bank.svg';
    }
    if (name.contains('kerala gramin bank') || name.contains('kgbank')) {
      return 'assets/bank_logos/kerala_gramin_bank.svg';
    }
    if (name.contains('federal')) {
      return 'assets/bank_logos/federal_bank.svg';
    }
    if (name.contains('standard chartered') || name.contains('scb')) {
      return 'assets/bank_logos/standard_chartered_bank.svg';
    }
    if (name.contains('karnataka')) {
      return 'assets/bank_logos/karnataka_bank.svg';
    }
    if (name.contains('amazon pay')) {
      return 'assets/bank_logos/amazon_pay.svg';
    }
    if (name.contains('city union')) {
      return 'assets/bank_logos/city_union_bank.svg';
    }
    if (name.contains('dhanlaxmi')) {
      return 'assets/bank_logos/dhanlaxmi_bank.svg';
    }

    if (name.contains('equitas')) {
      return 'assets/bank_logos/equitas_small_finance_bank.svg';
    }
    if (name.contains('saraswat')) {
      return 'assets/bank_logos/saraswat_co-operative_bank.svg';
    }

    return ''; // Return empty string if no logo found
  }
}

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

abstract class AppTexts {
  // ── Display / Hero amounts (Playfair Display equivalent)
  // Note: Register 'PlayfairDisplay' in pubspec.yaml fonts
  // Use for: balance amounts, transaction amounts, screen headings

  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 36,
    fontWeight: FontWeight.w500,
    letterSpacing: -1.0,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 28,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
  );

  // ── Headings (Inter)
  // Use for: screen titles, section headings, card titles

  static const TextStyle heading = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.3,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
  );

  // ── Body (Inter)
  // Use for: transaction names, account names, form labels

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimaryLight,
  );

  // ── Captions and labels
  // Use for: category names under transactions, section labels, muted info

  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMutedLight,
  );

  static const TextStyle captionBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMutedLight,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMutedLight,
    letterSpacing: 0.6,
  );

  // ── Amounts — use these for all money values
  // Color is set here, do not override in widgets

  static const TextStyle amountIncome = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.income,
  );

  static const TextStyle amountExpense = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.expense,
  );

  static const TextStyle amountLargeIncome = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.income,
    letterSpacing: -0.5,
  );

  static const TextStyle amountLargeExpense = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.expense,
    letterSpacing: -0.5,
  );

  // ── Navigation labels

  static const TextStyle navLabel = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textMutedLight,
  );

  static const TextStyle navLabelActive = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  // ── Buttons

  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  static const TextStyle buttonDanger = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.expense,
  );

  // ── Links

  static const TextStyle link = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );
}
