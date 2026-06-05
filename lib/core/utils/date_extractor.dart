class DateExtractor {
  static final List<RegExp> _patterns = [
    // 2025-06-08 (YYYY-MM-DD)
    RegExp(r'\b(\d{4})[-/](\d{1,2})[-/](\d{1,2})\b'),

    // 03.05.2026 (DD.MM.YYYY) - Must have 3 parts to avoid matching amounts like 37.91
    RegExp(r'\b(\d{1,2})\.(\d{1,2})\.(\d{2,4})\b'),

    // 05-Feb-2026 / 05-Feb-26 / 05/02/26 / 05/02
    RegExp(r'\b(\d{1,2})[-/](\d{1,2})(?:[-/](\d{2,4}))?\b'),

    // 05-Feb-26 / 05-Feb-2026 / 09/NOV/2020
    RegExp(
      r'\b(\d{1,2})[-/](Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[-/](\d{2,4})\b',
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

    // 11SEP2024 / 14JUN2019
    RegExp(
      r'\b(\d{1,2})(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)(\d{2,4})\b',
      caseSensitive: false,
    ),

    // September 21, 2022
    RegExp(
      r'\b(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|January|February|March|April|June|July|August|September|October|November|December)\s+(\d{1,2}),\s+(\d{4})\b',
      caseSensitive: false,
    ),

    // Formats like "June 10,2020" or "August 12, 2020"
    RegExp(
      r'\b(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|January|February|March|April|June|July|August|September|October|November|December)[a-z]*\s+(\d{1,2})(?:st|nd|rd|th)?,?\s*(\d{2,4})\b',
      caseSensitive: false,
    ),
  ];

  static DateTime? extract(String sms) {
    RegExpMatch? earliestMatch;
    int earliestIndex = sms.length;

    // 1. Find the EARLIEST match across all patterns
    for (final pattern in _patterns) {
      final matches = pattern.allMatches(sms);
      for (final match in matches) {
        if (match.start < earliestIndex) {
          earliestIndex = match.start;
          earliestMatch = match;
        }
      }
    }

    if (earliestMatch == null) return null;

    DateTime extractedDate;
    try {
      extractedDate = _parseMatch(earliestMatch);
    } catch (_) {
      return null;
    }

    // 2. Try to find a time (e.g., 14:30:05 or 02:30 PM or 11.08.05)
    final timePattern = RegExp(
      r'\b(\d{1,2})[:.](\d{2})(?:[:.](\d{2}))?\s*(AM|PM)?\b',
      caseSensitive: false,
    );
    
    // Look for time after the date or anywhere in the SMS
    final timeMatches = timePattern.allMatches(sms);
    RegExpMatch? bestTimeMatch;
    
    // Preferably find time NEAR the date (within 20 chars)
    for (final tm in timeMatches) {
      if ((tm.start - earliestMatch.end).abs() < 20 || bestTimeMatch == null) {
        bestTimeMatch = tm;
        if ((tm.start - earliestMatch.end).abs() < 20) break;
      }
    }

    if (bestTimeMatch != null) {
      int hour = int.parse(bestTimeMatch.group(1)!);
      final minute = int.parse(bestTimeMatch.group(2)!);
      final second = int.tryParse(bestTimeMatch.group(3) ?? '0') ?? 0;
      final amPm = bestTimeMatch.group(4)?.toUpperCase();

      if (amPm == 'PM' && hour < 12) hour += 12;
      if (amPm == 'AM' && hour == 12) hour = 0;

      return DateTime(
        extractedDate.year,
        extractedDate.month,
        extractedDate.day,
        hour,
        minute,
        second,
      );
    }

    return extractedDate;
  }

  static DateTime _parseMatch(RegExpMatch match) {
    final now = DateTime.now();
    final g1 = match.group(1)!;
    
    if (g1.length == 4 && int.tryParse(g1) != null) {
      // YYYY-MM-DD format
      final year = int.parse(g1);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      return DateTime(year, month, day);
    }

    int day;
    String? monthRaw;
    String? yearRaw;

    if (match.groupCount >= 3) {
      // If the matched string looks like MMMM dd, yyyy, the groups are (Month, Day, Year)
      final g2 = match.group(2);
      final isMonthFirst = int.tryParse(g1) == null;
      if (isMonthFirst) {
        monthRaw = g1;
        day = int.parse(g2!);
        yearRaw = match.group(3);
      } else {
        day = int.parse(g1);
        monthRaw = g2;
        yearRaw = match.group(3);
      }
    } else {
      day = int.parse(g1);
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
