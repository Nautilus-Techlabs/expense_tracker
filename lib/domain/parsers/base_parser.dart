import 'entities/transaction.dart';

abstract class BankParser {
  /// Unique bank identifier
  String getBankName();

  /// Default currency for this bank
  String getCurrency() => "INR";

  /// Checks if the sender ID (e.g., AD-HDFCBK) can be handled by this parser
  bool canHandle(String sender);

  /// The main parsing domain for this bank
  Transaction? parse(String sms, {DateTime? fallbackDate});

  /// Helper to clean merchant names
  String cleanMerchantName(String name) {
    var cleaned = name.trim();
    // Remove "at", "to", "towards" if they are at the start
    cleaned = cleaned.replaceFirst(
      RegExp(
        r"^(at|to|towards|from|for|info|vpa|on|by)\s+",
        caseSensitive: false,
      ),
      "",
    );

    // 🛡️ Precision Fix: Remove trailing connecting words like "on", "at", "via" 
    // This fixes "AMAZON on" or "MEDPLUS on" issues.
    cleaned = cleaned.replaceFirst(
      RegExp(
        r"\s+(on|at|at\s+the|via|for|to)$",
        caseSensitive: false,
      ),
      "",
    );

    // Remove common business suffixes
    cleaned = cleaned.replaceFirst(
      RegExp(
        r"\s+(pvt\.?\s*ltd\.?|private\s+limited|ltd\.?|limited)$",
        caseSensitive: false,
      ),
      "",
    );
    // Remove digits and symbols at the end
    cleaned = cleaned.replaceFirst(RegExp(r"[^a-zA-Z\s]+$"), "");
    return cleaned.trim();
  }

  /// Check if the captured name is valid
  bool isValidMerchantName(String name) {
    if (name.isEmpty) return false;
    final l = name.toLowerCase();
    final blacklist = [
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
    ];
    if (blacklist.any((token) => l == token || l.startsWith("$token ")))
      return false;
    if (RegExp(r"^\d+$").hasMatch(name)) return false; // Just digits
    if (name.length < 2) return false;

    // Avoid capturing fragmented account info as merchant
    if (l.contains("account") || l.contains("a/c") || l.contains("ending"))
      return false;
    // ❌ Reject date-like strings
    if (RegExp(r'\b\d{2}[-/][A-Za-z]{3}[-/]\d{2,4}\b').hasMatch(name)) {
      return false;
    }

    // ❌ Reject strings starting with 'on'
    if (l.startsWith("on ")) return false;

    return true;
  }
}
