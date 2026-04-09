import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'entities/bank_definition.dart';

class ParserConfigService {
  static const _prefsKey = 'bank_configs_json';
  static const _assetPath = 'assets/bank_configs.json';

  /// Loads bank definitions. Checks SharedPreferences first (for OTA updates),
  /// falls back to the bundled asset.
  static Future<List<BankDefinition>> loadDefinitions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedJson = prefs.getString(_prefsKey);
      if (storedJson != null) {
        return _parseJson(storedJson);
      }
    } catch (_) {
      // fall through to asset
    }
    final assetJson = await rootBundle.loadString(_assetPath);
    return _parseJson(assetJson);
  }

  /// Saves new JSON definitions to local storage for future use.
  /// Call this when you receive updated config (e.g., from a server).
  static Future<void> updateDefinitions(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonString);
  }

  static List<BankDefinition> _parseJson(String jsonString) {
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final banks = data['banks'] as List<dynamic>;
    return banks
        .map((b) => BankDefinition.fromJson(b as Map<String, dynamic>))
        .toList();
  }
}
