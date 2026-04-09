import '../../core/utils/balance_extractor.dart';
import '../../core/utils/date_extractor.dart';
import 'base_parser.dart';
import 'entities/bank_definition.dart';
import 'entities/transaction.dart';

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
  Transaction? parse(String sms, {DateTime? fallbackDate}) {
    Transaction? bestTransaction;
    int bestScore = -1;
    final sortedTemplates = [...definition.templates]
      ..sort((a, b) => a.priority.compareTo(b.priority));

    for (var template in sortedTemplates) {
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

    if (tx.amount != null) score += 50; // mandatory
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
        if (lower.contains("ref") ||
            lower.contains("txn") ||
            lower.contains("no") ||
            lower.contains("imps") ||
            lower.contains("upi")) {
          merchant = null; // ❌ reject garbage
        } else if (isValidMerchantName(cleaned)) {
          merchant = cleaned; // ✅ accept only clean
        }
      }
    }

    // 3. Account Extraction
    String? account;
    if (template.accountGroup != null) {
      account = match.group(template.accountGroup!);
    }

    // 4. Balance Extraction
    double? balance;
    if (template.balanceGroup != null) {
      final rawBalance = match.group(template.balanceGroup!);
      if (rawBalance != null) {
        balance = double.tryParse(rawBalance.replaceAll(",", ""));
      }
    }
    final extractedBalance = BalanceExtractor.extract(sms);
    final extractedDate = DateExtractor.extract(sms);
    return Transaction(
      amount: amount,
      type: template.type,
      date: extractedDate ?? fallbackDate ?? DateTime.now(),
      merchant: merchant,
      method: template.method,
      account: account,
      availableBalance: extractedBalance ?? balance,
      rawSms: sms,
      bankName: definition.bankName,
      templateName: template.name,
      isVerified: true, // Specific bank match is verified
    );
  }
}
