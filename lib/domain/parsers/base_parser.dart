import '../../core/constants/app_constants.dart';
import '../entities/transaction.dart';

abstract class BankParser {
  /// Unique bank identifier
  String getBankName();

  /// Logo asset path
  String? getLogo();

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
    final prefixPattern = AppConstants.merchantCleanPrefixes.join('|');
    cleaned = cleaned.replaceFirst(
      RegExp("^($prefixPattern)\\s+", caseSensitive: false),
      "",
    );

    // 🛡️ Precision Fix: Remove trailing connecting words like "on", "at", "via"
    // This fixes "AMAZON on" or "MEDPLUS on" issues.
    cleaned = cleaned.replaceFirst(
      RegExp(r"\s+(on|at|at\s+the|via|for|to)$", caseSensitive: false),
      "",
    );

    // Remove common business suffixes
    final suffixPattern = AppConstants.merchantCleanSuffixes
        .map((s) => s.replaceAll(' ', '\\s+'))
        .join('|');
    cleaned = cleaned.replaceFirst(
      RegExp("\\s+($suffixPattern)\$", caseSensitive: false),
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

    if (AppConstants.merchantBlacklist.any(
      (token) => l == token || l.startsWith("$token "),
    )) {
      return false;
    }
    if (RegExp(r"^\d+$").hasMatch(name)) return false; // Just digits
    if (name.length < 2) return false;

    // Avoid capturing fragmented account info as merchant
    if (l.contains("account") || l.contains("a/c") || l.contains("ending")) {
      return false;
    }
    // ❌ Reject date-like strings
    if (RegExp(r'\b\d{2}[-/][A-Za-z]{3}[-/]\d{2,4}\b').hasMatch(name)) {
      return false;
    }

    // ❌ Reject strings starting with 'on'
    if (l.startsWith("on ")) return false;

    return true;
  }
}
