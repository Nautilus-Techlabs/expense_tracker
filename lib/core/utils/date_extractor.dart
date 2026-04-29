class DateExtractor {
  static final List<RegExp> _patterns = [
    // 2025-06-08 (YYYY-MM-DD)
    RegExp(r'\b(\d{4})[-/](\d{1,2})[-/](\d{1,2})\b'),

    // 05-Feb-2026 / 05-Feb-26 / 05/02/26 / 05/02
    RegExp(r'\b(\d{1,2})[-/](\d{1,2})(?:[-/](\d{2,4}))?\b'),

    // 05-Feb-26 / 05-Feb-2026
    RegExp(
      r'\b(\d{1,2})-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-(\d{2,4})\b',
      caseSensitive: false,
    ),

    // 05 Feb 2026 / 05 feb 26
    RegExp(
      r'\b(\d{1,2})\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+(\d{2,4})\b',
      caseSensitive: false,
    ),

    // 05 Feb / 05 April (No Year)
    RegExp(
      r'\b(\d{1,2})[\s-](Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|January|February|March|April|June|July|August|September|October|November|December)\b',
      caseSensitive: false,
    ),
  ];

  static DateTime? extract(String sms) {
    for (final pattern in _patterns) {
      final match = pattern.firstMatch(sms);
      if (match != null) {
        try {
          return _parseMatch(match);
        } catch (_) {
          continue;
        }
      }
    }
    return null;
  }

  static DateTime _parseMatch(RegExpMatch match) {
    final now = DateTime.now();
    final g1 = match.group(1)!;
    
    if (g1.length == 4) {
      // YYYY-MM-DD format
      final year = int.parse(g1);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      return DateTime(year, month, day);
    }

    final day = int.parse(g1);
    String? monthRaw;
    String? yearRaw;

    if (match.groupCount >= 3) {
      monthRaw = match.group(2);
      yearRaw = match.group(3);
    } else {
      monthRaw = match.group(2);
    }

    int month = _parseMonth(monthRaw);

    int year;
    if (yearRaw != null) {
      year = int.parse(yearRaw);
      if (year < 100) year += 2000;
    } else {
      year = now.year;
    }

    return DateTime(year, month, day);
  }

  static int _parseMonth(String? input) {
    if (input == null) return 1;
    final parsed = int.tryParse(input);
    if (parsed != null) return parsed;

    const months = {
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
      'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
    };

    final lower = input.substring(0, 3).toLowerCase();
    return months[lower] ?? 1;
  }
}
