import 'dart:convert';
import 'dart:io';
import '../entities/bank_definition.dart';

/// Compatibility shim for legacy tests expecting `BankDefinitions.all`.
///
/// Loads bank definitions synchronously from the asset file so that
/// `BankParserFactory.initializeFromDefinitions(BankDefinitions.all)` works
/// without requiring an async call in the test suite.
class BankDefinitions {
  /// Synchronously loads the JSON asset and parses it into a list of
  /// `BankDefinition` objects.
  static List<BankDefinition> _loadSync() {
    try {
      final jsonString = File('assets/bank_configs.json').readAsStringSync();
      final data = json.decode(jsonString) as Map<String, dynamic>;
      final banks = data['banks'] as List<dynamic>;
      return banks
          .map((b) => BankDefinition.fromJson(b as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If the asset is missing, return an empty list to avoid crashes.
      return [];
    }
  }

  /// Static list used by legacy test code.
  static final List<BankDefinition> all = _loadSync();
}
