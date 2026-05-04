import '../../core/utils/app_logger.dart';
import 'combined_parser.dart';
import 'parser_config_service.dart';

class FlutterParserInitializer {
  /// Must be called once during app startup (e.g., in main()).
  static Future<void> initialize() async {
    AppLogger.i("Initializing Bank Parser Engine...");
    final definitions = await ParserConfigService.loadDefinitions();
    BankParserFactory.initializeFromDefinitions(definitions);
    AppLogger.i("Bank Parser Engine initialized with ${definitions.length} banks.");
  }

  /// Rebuilds the parser list from a fresh set of definitions.
  static Future<void> reload() async {
    final definitions = await ParserConfigService.loadDefinitions();
    BankParserFactory.reload(definitions);
  }
}
