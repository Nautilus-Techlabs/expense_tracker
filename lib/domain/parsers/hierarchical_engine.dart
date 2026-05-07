import '../../core/constants/app_constants.dart';
import '../../core/utils/balance_extractor.dart';
import '../../core/utils/date_extractor.dart';
import '../entities/bank_definition.dart';
import '../entities/transaction.dart';
import 'base_parser.dart';

/// A universal parser engine that uses data-driven BankDefinitions
/// to parse SMS messages.
class HierarchicalBankParser extends BankParser {
  final BankDefinition definition;

  HierarchicalBankParser(this.definition);

  @override
  String getBankName() => definition.bankName;

  @override
  bool canHandle(String sender) => definition.canHandle(sender);

  @override
  String? getLogo() => definition.logo;

  @override
  Transaction? parse(String sms, {DateTime? fallbackDate}) {
    Transaction? bestTransaction;
    int bestScore = -1;
    final sortedTemplates = [...definition.templates]
      ..sort((a, b) => a.priority.compareTo(b.priority));

    for (var template in sortedTemplates) {
      if (template.type == TransactionType.meta) continue;

      if (!template.matches(sms)) continue;
      final result = _extract(sms, template, fallbackDate);
      if (result == null) continue;
      final score = _calculateScore(result, template);

      if (score > bestScore) {
        bestScore = score;
        bestTransaction = result;
      }
    }
    return bestTransaction;
  }

  int _calculateScore(Transaction tx, SmSTemplate template) {
    int score = 0;

    score += 50; // mandatory
    if (tx.merchant != null) score += 20;
    if (tx.account != null) score += 15;
    if (tx.availableBalance != null) score += 10;

    // bonus for specific method
    if (template.method != PaymentMethod.unknown) score += 5;

    // priority bonus
    score += (100 - template.priority);

    return score;
  }

  Transaction? _extract(
    String sms,
    SmSTemplate template,
    DateTime? fallbackDate,
  ) {
    final match = template.pattern.firstMatch(sms);
    if (match == null) return null;

    // 1. Amount Extraction
    double? amount;
    if (template.amountGroup != null) {
      final rawAmount = match.group(template.amountGroup!);
      if (rawAmount != null) {
        amount = double.tryParse(rawAmount.replaceAll(",", ""));
      }
    }

    if (amount == null) return null;

    // 2. Merchant Extraction
    String? merchant;
    if (template.merchantGroup != null) {
      final rawMerchant = match.group(template.merchantGroup!);

      if (rawMerchant != null) {
        final cleaned = cleanMerchantName(rawMerchant);

        final lower = cleaned.toLowerCase();

        // 🚫 HARD BLOCK (very important)
        if (AppConstants.merchantHardBlockKeywords.any(
          (k) => lower.contains(k),
        )) {
          merchant = null; // ❌ reject garbage
        } else if (isValidMerchantName(cleaned)) {
          merchant = cleaned; // ✅ accept only clean
        }
      }
    }

    // 2.b Fallback Merchant Guessing (if template didn't capture it)
    if (merchant == null) {
      // Unified pattern for common merchant/sender keywords (debit & credit)
      final universalPattern = RegExp(
        r"(?:at|to|towards|for|using|trf\s+to|transfer\s+to|transfer\s+from|from\s+beneficiary|beneficiary|from)\s+([a-zA-Z0-9\s\-&]+?)(?:\s+on|\s+at|\s+via|\s+using|\s+Ref|\s+Refno|\s+UTR|\.|$|;)",
        caseSensitive: false,
      );

      final m = universalPattern.firstMatch(sms);
      if (m != null) {
        final guessed = cleanMerchantName(m.group(1)!);
        if (isValidMerchantName(guessed)) {
          merchant = guessed;
        }
      }
    }

    // 3. Account Extraction
    String? account;
    if (template.accountGroup != null) {
      account = match.group(template.accountGroup!);
    }

    // 2. FALLBACK: If template failed, try a general search in the SMS body
    if (account == null) {
      final fallbackRegex = RegExp(
        AppConstants.accountFallbackPattern,
        caseSensitive: false,
      );
      final fallbackMatch = fallbackRegex.firstMatch(sms);
      if (fallbackMatch != null) {
        account = fallbackMatch.group(1);
      }
    }

    // 3. CLEANUP: Standardize the display (e.g., remove 'XX' or '****')
    if (account != null) {
      // Keep only the last 4 digits for a clean UI
      account = account.replaceAll(RegExp(r'[^0-9]'), '');
      if (account.length > 4) {
        account = account.substring(account.length - 4);
      }
    }
    if (account != null) {
      account = 'XX$account';
    }

    // 4. Balance Extraction
    double? balance;
    if (template.balanceGroup != null) {
      final rawBalance = match.group(template.balanceGroup!);
      if (rawBalance != null) {
        balance = double.tryParse(rawBalance.replaceAll(",", ""));
      }
    }
    final extractedMethod = _extractPaymentMethod(sms);
    final extractedBalance = BalanceExtractor.extract(sms);
    final extractedDate = DateExtractor.extract(sms);
    DateTime finalDate = fallbackDate ?? DateTime.now();

    if (extractedDate != null) {
      // If DateExtractor found a date but its time is 00:00:00,
      // try to preserve the time from the SMS metadata (fallbackDate).
      if (extractedDate.hour == 0 &&
          extractedDate.minute == 0 &&
          extractedDate.second == 0) {
        finalDate = DateTime(
          extractedDate.year,
          extractedDate.month,
          extractedDate.day,
          finalDate.hour,
          finalDate.minute,
          finalDate.second,
          finalDate.millisecond,
        );
      } else {
        // DateExtractor found a specific time in the SMS, use it!
        finalDate = extractedDate;
      }
    }

    return Transaction(
      amount: amount,
      type: template.type,
      date: finalDate,
      merchant: merchant,
      method: extractedMethod != PaymentMethod.unknown
          ? extractedMethod
          : template.method,
      account: account,
      availableBalance: extractedBalance ?? balance,
      rawSms: sms,
      bankName: definition.bankName,
      templateName: template.name,
      isVerified: true, // Specific bank match is verified
    );
  }

  PaymentMethod _extractPaymentMethod(String sms) {
    final pattern = RegExp(
      AppConstants.paymentMethodPattern,
      caseSensitive: false,
    );
    final match = pattern.firstMatch(sms)?.group(0);

    return PaymentMethod.values.firstWhere(
      (e) => e.name.toLowerCase() == match?.toLowerCase(),
      orElse: () => PaymentMethod.unknown,
    );
  }
}
