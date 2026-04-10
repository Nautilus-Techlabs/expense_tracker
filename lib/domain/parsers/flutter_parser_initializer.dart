import 'combined_parser.dart';
import 'parser_config_service.dart';

class FlutterParserInitializer {
  /// Must be called once during app startup (e.g., in main()).
  static Future<void> initialize() async {
    final definitions = await ParserConfigService.loadDefinitions();
    BankParserFactory.initializeFromDefinitions(definitions);
  }

  /// Rebuilds the parser list from a fresh set of definitions.
  static Future<void> reload() async {
    final definitions = await ParserConfigService.loadDefinitions();
    BankParserFactory.reload(definitions);
  }
}
