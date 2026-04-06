import '../models/transaction.dart';

class TransactionParser {
  /// Surgical Pipeline-based Parser
  Transaction? parse(String text, {DateTime? fallbackDate}) {
    final normalized = _normalize(text);
    if (normalized.isEmpty) return null;

    if (!_shouldParse(normalized)) return null;

    final amounts = _scoutAmounts(normalized);
    final transactionAmount = _identifyTransactionAmount(normalized, amounts);
    final balance = _identifyBalance(normalized, amounts);

    final type = _extractType(normalized);
    final method = _extractMethod(normalized);
    final date = _extractDate(normalized) ?? fallbackDate;

    final account = _extractAccount(normalized);
    final merchant = _extractMerchant(normalized);

    if (transactionAmount == null || type == null || date == null) return null;

    return Transaction(
      amount: transactionAmount,
      type: type,
      date: date,
      merchant: merchant,
      method: method,
      account: account,
      availableBalance: balance,
      rawSms: text,
    );
  }

  String _normalize(String text) {
    return text
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'\bA/c\b', caseSensitive: false), ' account ')
        .replaceAll(RegExp(r'\bA/C\b', caseSensitive: false), ' account ');
  }

  bool _shouldParse(String text) {
    final l = text.toLowerCase();
    if (l.contains('otp') ||
        l.contains('verification code') ||
        l.contains('password'))
      return false;
    final failureWords = [
      'failed',
      'declined',
      'insufficient',
      'rejected',
      'cancelled',
      'limit reached',
    ];
    for (var w in failureWords) {
      if (l.contains(w)) return false;
    }
    return _scoutAmounts(text).isNotEmpty;
  }

  List<_AmountContext> _scoutAmounts(String text) {
    final res = <_AmountContext>[];
    final cleanText = text.replaceAll(',', '');
    final pat = RegExp(
      r'(?:Rs\.?|INR|₹|MRP|Amt:?)\s*([\d]+\.?\d{0,2})|([\d]+\.?\d{1,2})\s*(?:Rs\.?|INR|₹)',
      caseSensitive: false,
    );
    final matches = pat.allMatches(cleanText);

    for (var m in matches) {
      final valStr = m.group(1) ?? m.group(2);
      if (valStr == null) continue;
      final val = double.tryParse(valStr);
      if (val == null || val == 0) continue;
      res.add(
        _AmountContext(
          value: val,
          start: m.start,
          end: m.end,
          isBalance: _isLabeledAsBalance(cleanText, m.start),
        ),
      );
    }
    return res;
  }

  bool _isLabeledAsBalance(String text, int start) {
    final pre = text.substring(0, start).toLowerCase();
    final balanceWords = [
      'bal:',
      'balance',
      'available',
      'balance is',
      'avl bal',
    ];
    for (var w in balanceWords) {
      if (pre.contains(w) && (start - pre.lastIndexOf(w)) < 15) return true;
    }
    return false;
  }

  double? _identifyTransactionAmount(String text, List<_AmountContext> scouts) {
    if (scouts.isEmpty) return null;
    for (var s in scouts) {
      if (s.isBalance) continue;
      final surrounding = text
          .substring(
            (s.start - 25).clamp(0, text.length),
            (s.end + 25).clamp(0, text.length),
          )
          .toLowerCase();
      if (surrounding.contains('debited') ||
          surrounding.contains('credited') ||
          surrounding.contains('spent') ||
          surrounding.contains('withdrawn') ||
          surrounding.contains('payment'))
        return s.value;
    }
    final fallbacks = scouts.where((s) => !s.isBalance).toList();
    return fallbacks.isNotEmpty ? fallbacks.first.value : null;
  }

  double? _identifyBalance(String text, List<_AmountContext> scouts) {
    final balances = scouts.where((s) => s.isBalance).toList();
    return balances.isNotEmpty ? balances.first.value : null;
  }

  TransactionType? _extractType(String text) {
    final l = text.toLowerCase();
    final creditWords = [
      'credited',
      'received',
      'deposited',
      'refund',
      'plus',
      'add',
      'cashback',
      'receipt',
      'credit',
    ];
    final debitWords = [
      'debited',
      'spent',
      'withdrawn',
      'paid',
      'payment',
      'sent',
      'debit',
      'withdrawal',
      'purchase',
      'processed',
    ];
    for (var w in creditWords) {
      if (l.contains(w)) return TransactionType.credit;
    }
    for (var w in debitWords) {
      if (l.contains(w)) return TransactionType.debit;
    }
    return null;
  }

  String? _extractMerchant(String text) {
    final l = text.toLowerCase();

    // 1. UPI VPA Check (100% accurate)
    final vpa = RegExp(
      r'([a-z0-9\._\-]+@[a-z]+)',
      caseSensitive: false,
    ).firstMatch(text);
    if (vpa != null) return vpa.group(1);

    // 2. Surgical Context Extraction
    String? raw;
    final contextualPats = [
      RegExp(r'from\s+(.*?)\s+to\s+', caseSensitive: false),
      RegExp(r'to\s+(.*?)\s+from\s+', caseSensitive: false),
      RegExp(r'at\s+(.*?)\s+(?:on|using|through|via)\s+', caseSensitive: false),
      RegExp(r'paid\s+for\s+(.*?)\s+on\s+', caseSensitive: false),
      RegExp(r'towards\s+(.*?)\s+on\s+', caseSensitive: false),
    ];

    for (var pat in contextualPats) {
      final m = pat.firstMatch(text);
      if (m != null) {
        raw = m.group(1);
        break;
      }
    }

    // 3. Fallback extraction after keywords
    if (raw == null) {
      final fallbackPats = [
        RegExp(
          r'(?:to|at|by|from|info|paid for|towards)\s+([A-Z0-9\s\.&_-]{2,})',
          caseSensitive: false,
        ),
      ];
      for (var pat in fallbackPats) {
        final m = pat.firstMatch(text);
        if (m != null) {
          raw = m.group(1);
          break;
        }
      }
    }

    if (raw == null) return null;

    // 4. THE SURGICAL CLEANUP
    // Remove "The", "your", etc.
    raw = raw
        .replaceAll(
          RegExp(
            r'^(the|at|a/c|your|bank|account|towards|vpa|savings|current)\s+',
            caseSensitive: false,
          ),
          '',
        )
        .trim();

    // STOP SPLITTER: Cut if any connector appears after the first word
    final stopWords = [
      'to',
      'from',
      'on',
      'at',
      'for',
      'through',
      'using',
      'via',
      'by',
      'bank',
      'account',
      'ending',
      'card',
      'successful',
      'success',
      'is',
      'has',
      'was',
      'available',
      'avl',
      'bal',
      'ref',
      'vpa',
      'with',
      'in',
    ];

    var words = raw.split(' ');
    var cleanWords = <String>[];
    for (int i = 0; i < words.length; i++) {
      final w = words[i].toLowerCase().replaceAll(RegExp(r'[^\w]'), '');
      if (stopWords.contains(w) && i > 0) break; // Cut here
      cleanWords.add(words[i]);
    }
    raw = cleanWords.join(' ').trim();

    // Aggressive Digit Removal
    raw = raw.replaceAll(RegExp(r'[\dX]{3,}', caseSensitive: false), '').trim();

    // Final Blacklist for full string
    final blacklist = [
      'savings',
      'current',
      'account',
      'bank',
      'your',
      'ending',
    ];
    if (blacklist.contains(raw.toLowerCase())) return null;

    // Remove trailing punctuation
    raw = raw.replaceAll(RegExp(r'[^a-zA-Z\s]+$'), '').trim();

    return raw.length >= 2 ? raw : null;
  }

  String? _extractAccount(String text) {
    final pat = RegExp(
      r'(?:account|Card|ending|XX|No\.)\s*[:.\-]?\s*([0-9X]{3,10})',
      caseSensitive: false,
    );
    final m = pat.firstMatch(text);
    if (m != null) {
      final pre = text.substring(0, m.start).toLowerCase();
      if (pre.contains('bal') && (m.start - pre.lastIndexOf('bal')) < 10)
        return null;
      return m.group(1);
    }
    return null;
  }

  DateTime? _extractDate(String text) {
    final patterns = [
      RegExp(r'\b(\d{1,2})[-/](\d{1,2})[-/](\d{2,4})\b'),
      RegExp(
        r'\b(\d{1,2})[-\s/](Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*[-\s/](\d{2,4})?\b',
        caseSensitive: false,
      ),
    ];
    for (var p in patterns) {
      final m = p.firstMatch(text);
      if (m != null) {
        int d = int.tryParse(m.group(1)!) ?? 1;
        int mon = int.tryParse(m.group(2) ?? '1') ?? _monthToInt(m.group(2)!);
        int y = DateTime.now().year;
        if (m.groupCount >= 3 && m.group(3) != null) {
          y = int.tryParse(m.group(3)!) ?? y;
          if (y < 100) y += 2000;
        }
        try {
          return DateTime(y, mon, d);
        } catch (_) {}
      }
    }
    return null;
  }

  int _monthToInt(String m) {
    final l = m.toLowerCase();
    const months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec',
    ];
    for (int i = 0; i < months.length; i++) {
      if (l.contains(months[i])) return i + 1;
    }
    return 1;
  }

  PaymentMethod _extractMethod(String text) {
    final l = text.toLowerCase();
    if (l.contains('upi') ||
        l.contains('google pay') ||
        l.contains('gpay') ||
        l.contains('phonepe') ||
        l.contains('paytm') ||
        l.contains('vpa')) {
      return PaymentMethod.upi;
    }
    if (l.contains('card') || l.contains('swipe')) return PaymentMethod.card;
    if (l.contains('atm')) return PaymentMethod.atm;
    if (l.contains('imps')) return PaymentMethod.imps;
    if (l.contains('neft')) return PaymentMethod.neft;
    if (l.contains('rtgs')) return PaymentMethod.rtgs;
    return PaymentMethod.unknown;
  }
}

class _AmountContext {
  final double value;
  final int start;
  final int end;
  final bool isBalance;
  _AmountContext({
    required this.value,
    required this.start,
    required this.end,
    this.isBalance = false,
  });
}

class SmsParserEngine {
  final parser = TransactionParser();
  Transaction? tryParse(String text, {DateTime? fallbackDate}) =>
      parser.parse(text, fallbackDate: fallbackDate);
  List<Transaction> parseBatch(
    List<String> messages, {
    DateTime? fallbackDate,
  }) => messages
      .map((m) => tryParse(m, fallbackDate: fallbackDate))
      .whereType<Transaction>()
      .toList();
}
