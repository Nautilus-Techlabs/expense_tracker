class DateExtractor {
  static final List<RegExp> _patterns = [
    // 05-02-2026 / 05-02-26 / 05/02/26 / 05/02
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

    // 05 Feb / 05 feb / 05 April / 05 april
    RegExp(
      r'\b(\d{1,2})[\s-](Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|January|February|March|April|June|July|August|September|October|November|December)\b',
      caseSensitive: false,
    ),

    // 05Feb26 / 01Apr25
    RegExp(
      r'\b(\d{1,2})(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)(\d{2,4})\b',
      caseSensitive: false,
    ),

    // 25th December 2024
    RegExp(
      r'\b(\d{1,2})(?:st|nd|rd|th)?\s+(January|February|March|April|May|June|July|August|September|October|November|December)\s+(\d{2,4})\b',
      caseSensitive: false,
    ),

    // 08/AUG
    RegExp(
      r'\b(\d{1,2})[/-](Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\b',
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

    final day = int.parse(match.group(1)!);

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
      year = now.year; // fallback if year missing
    }

    return DateTime(year, month, day);
  }

  static int _parseMonth(String? input) {
    if (input == null) return 1;

    if (int.tryParse(input) != null) {
      return int.parse(input);
    }

    const months = {
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };

    return months[input.substring(0, 3).toLowerCase()] ?? 1;
  }
}
