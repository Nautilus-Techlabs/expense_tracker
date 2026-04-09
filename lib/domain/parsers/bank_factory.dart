import 'base_parser.dart';
import 'entities/bank_definition.dart';
import 'hierarchical_engine.dart';
import 'entities/transaction.dart';

class CombinedParser extends BankParser {
  final BankParser? primary;
  final BankParser fallback;

  CombinedParser(this.primary, this.fallback);

  @override
  String getBankName() => primary?.getBankName() ?? fallback.getBankName();

  @override
  bool canHandle(String sender) => true;

  @override
  Transaction? parse(String sms, {DateTime? fallbackDate}) {
    Transaction? result;
    if (primary != null) {
      result = primary!.parse(sms, fallbackDate: fallbackDate);
    }
    if (result == null) {
      result = fallback.parse(sms, fallbackDate: fallbackDate);
      if (result != null) {
        // Mark as unverified if it came from fallback
        result = _markUnverified(result);
      }
    }
    return result;
  }

  Transaction _markUnverified(Transaction tx) {
    // If we have a primary parser, use its bank name instead of "Unsupported"
    final name = primary?.getBankName() ?? 'Unsupported Bank';
    
    return Transaction(
      amount: tx.amount,
      type: tx.type,
      date: tx.date,
      method: tx.method,
      merchant: tx.merchant,
      account: tx.account,
      availableBalance: tx.availableBalance,
      rawSms: tx.rawSms,
      bankName: name, 
      templateName: tx.templateName,
      isVerified: false,
    );
  }
}

class BankParserFactory {
  static List<BankParser> _parsers = [];
  static BankParser _fallback = _NoOpParser();
  static bool _initialized = false;

  /// Synchronous initializer for CLI scripts / tests that cannot use Flutter assets.
  static void initializeFromDefinitions(List<BankDefinition> definitions) {
    _buildFrom(definitions);
    _initialized = true;
  }

  /// Rebuilds the parser list from a fresh set of definitions.
  static void reload(List<BankDefinition> definitions) {
    _buildFrom(definitions);
  }

  static void _buildFrom(List<BankDefinition> definitions) {
    final generic = definitions.where((d) => d.bankName == 'Generic').toList();
    final specific = definitions.where((d) => d.bankName != 'Generic').toList();

    _parsers = specific
        .map((d) => HierarchicalBankParser(d) as BankParser)
        .toList();
    _fallback = generic.isNotEmpty
        ? HierarchicalBankParser(generic.first)
        : _NoOpParser();
  }

  /// Returns the appropriate parser for the given sender.
  static BankParser getParser(String sender) {
    BankParser? specificParser;
    for (final parser in _parsers) {
      if (parser.canHandle(sender)) {
        specificParser = parser;
        break;
      }
    }
    return CombinedParser(specificParser, _fallback);
  }
}

/// A no-op fallback used before initialization completes.
class _NoOpParser extends BankParser {
  @override
  String getBankName() => 'None';
  @override
  bool canHandle(String sender) => false;
  @override
  Transaction? parse(String sms, {DateTime? fallbackDate}) => null;
}
