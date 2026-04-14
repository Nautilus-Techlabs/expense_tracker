class AppConstants {
  /// Words that indicate an SMS is not a transaction (OTP, Password, etc.)
  /// We include non-bank payment apps here to prevent them from being parsed
  /// as banks when they are just the medium.
  static const List<String> exclusionKeywords = [
    "otp",
    "code",
    "password",
    "will be",
    "due on",
    "login",
    "verify",
    "phonepe",
    "paytm",
    "gpay",
    "amazonpay",
    "recharge",
    "bill",
    "offers",
    "discount",
  ];

  /// Common senders that should be ignored entirely as they are not banks
  static const List<String> ignoredSenders = [
    "PHONEPE",
    "PAYTM",
    "GPAY",
    "AMAZON",
    "JIO",
    "AIRTEL",
    "VI",
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
  ];

  /// Hard block keywords that immediately invalidate a merchant name
  static const List<String> merchantHardBlockKeywords = [
    "ref",
    "txn",
    "no",
    "imps",
    "upi",
  ];

  /// Regex pattern for common payment methods
  static const String paymentMethodPattern = r'(UPI|Card|ATM|NEFT|RTGS|IMPS)';

  /// Regex pattern for account number fallback extraction
  static const String accountFallbackPattern =
      r'(?:A/c|Acct|ending|[\*X]{2,})[\s\.]*([X\*]*\d{4})';
}
