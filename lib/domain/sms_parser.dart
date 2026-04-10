import 'parsers/entities/transaction.dart';
import 'parsers/combined_parser.dart';

class TransactionParser {
  TransactionParser();

  /// The main parsing entry point. Uses the Hierarchical Factory.
  Transaction? parse(String text, {String? sender, DateTime? fallbackDate}) {
    final bankSender = sender ?? "Unknown";
    final parser = BankParserFactory.getParser(bankSender);
    return parser.parse(text, fallbackDate: fallbackDate);
  }
}

class SmsParserEngine {
  /// Try to parse a single SMS, providing sender for better accuracy.
  Transaction? tryParse(
    String text, {
    String? sender,
    DateTime? fallbackDate,
  }) => TransactionParser().parse(
    text,
    sender: sender,
    fallbackDate: fallbackDate,
  );

  /// Parse a batch of messages.
  List<Transaction> parseBatch(
    List<({String body, String? sender, DateTime? date})> messages,
  ) {
    return messages
        .map((m) => tryParse(m.body, sender: m.sender, fallbackDate: m.date))
        .whereType<Transaction>()
        .toList();
  }
}
