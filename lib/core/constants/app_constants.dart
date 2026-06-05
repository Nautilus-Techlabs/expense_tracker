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
