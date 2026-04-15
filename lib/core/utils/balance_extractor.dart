class BalanceExtractor {
  static final List<RegExp> _patterns = [
    RegExp(
      r'(?:Available|Avl|Avail|Avbl|Bal|Balance)\s*(?:bal|balance|limit)?[:\s]*(?:Rs\.?|INR|₹)?\s*([\d,]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    ),

    RegExp(
      r'Bal(?:ance)?[:\s]*(?:Rs\.?|INR|₹)?\s*([\d,]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    ),

    RegExp(
      r'Avl[:\s]*(?:Rs\.?|INR|₹)?\s*([\d,]+(?:\.\d{1,2})?)',
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
