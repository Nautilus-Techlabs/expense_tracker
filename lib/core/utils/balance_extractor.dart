class BalanceExtractor {
  static final List<RegExp> _patterns = [
    RegExp(
      r'(?:Available|Avl|Avail|Avbl|Bal|Balance|balance\s+is|BAL-|New balance is)[^0-9]*?(?:Rs\.?|INR|₹)?\s*([\d,]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    ),
    RegExp(
      r'(?:Total\s+)?Avl\s+Bal[:\s-]*(?:Rs\.?|INR|₹)?\s*([\d,]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    ),
    RegExp(
      r'New\s+(?:Available\s+)?Balance[:\s-]*(?:Rs\.?|INR|₹)?\s*([\d,]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    ),
    RegExp(
      r'BAL-(?:Rs\.?|INR|₹)?\s*([\d,]+(?:\.\d{1,2})?)',
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
