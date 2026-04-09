class BalanceExtractor {
  static final List<RegExp> _patterns = [
    RegExp(
      r'(?:Available|Avl|Avail)\s*(?:bal|balance)?[:\s]*(?:Rs\.?|INR)?\s*([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    ),

    RegExp(
      r'Balance[:\s]*(?:Rs\.?|INR)?\s*([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    ),

    RegExp(
      r'Avl[:\s]*(?:Rs\.?|INR)?\s*([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    ),
  ];

  static double? extract(String sms) {
    for (final pattern in _patterns) {
      final match = pattern.firstMatch(sms);
      if (match != null) {
        final raw = match.group(1);
        if (raw != null) {
          return double.tryParse(raw.replaceAll(",", ""));
        }
      }
    }
    return null;
  }
}
