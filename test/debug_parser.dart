import 'dart:convert';
import 'dart:io';
import 'package:expense_tracker/domain/parsers/bank_factory.dart';
import 'package:expense_tracker/domain/parsers/entities/bank_definition.dart';
import 'package:expense_tracker/data/sample_data.dart';

void main() {
  // 1. Load the JSON configuration from the assets directory
  final configFile = File('assets/bank_configs.json');
  if (!configFile.existsSync()) {
    print('Error: assets/bank_configs.json not found. Run this from the project root.');
    exit(1);
  }

  final jsonString = configFile.readAsStringSync();
  final data = json.decode(jsonString) as Map<String, dynamic>;
  final banksJson = data['banks'] as List<dynamic>;
  final definitions = banksJson
      .map((b) => BankDefinition.fromJson(b as Map<String, dynamic>))
      .toList();

  // 2. Initialize factory from JSON definitions
  BankParserFactory.initializeFromDefinitions(definitions);

  final goodSamples = sampleSms.where((s) {
    final l = s.body.toLowerCase();
    final isExcluded = l.contains('otp') || 
                       l.contains('verification code') || 
                       l.contains('password') ||
                       l.contains('failed') || 
                       l.contains('declined') || 
                       l.contains('insufficient fund') ||
                       l.contains('rejected') || 
                       l.contains('limit reached') ||
                       l.contains('cancelled') ||
                       l.contains('offer!') ||
                       (l.contains('balance in') && !l.contains('debited') && !l.contains('credited'));
    return !isExcluded;
  }).toList();

  print('--- DEBUG PARSERS ON SAMPLES (JSON DRIVEN) ---');
  for (var sample in goodSamples) {
    final parser = BankParserFactory.getParser(sample.sender);
    final tx = parser.parse(sample.body);

    if (tx == null) {
      print('FAILED: [${sample.sender}] ${sample.body}');
    } else {
      final status = tx.isVerified ? 'VERIFIED' : 'ESTIMATED';
      print('[$status] [${tx.method.name.toUpperCase()}] "${tx.merchant ?? "Unknown"}" | Amt: ${tx.amount} | Acc: ${tx.account} from: ${sample.body}');
    }
  }
}
