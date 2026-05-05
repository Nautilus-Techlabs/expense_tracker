import 'dart:convert';
import 'dart:io';
import 'package:expense_tracker/domain/entities/bank_definition.dart';
import 'package:expense_tracker/domain/parsers/combined_parser.dart';
import 'package:expense_tracker/data/sample_data.dart';

void main() {
  // 1. Load the JSON configuration from the assets directory
  final configFile = File('assets/bank_configs.json');
  if (!configFile.existsSync()) {
    print(
      'Error: assets/bank_configs.json not found. Run this from the project root.',
    );
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

  print('--- SMS HIERARCHICAL PARSER ACCURACY REPORT ---');
  print('Total Samples: ${sampleSms.length}');

  final bankStats = <String, Map<String, int>>{};
  int totalTransactions = 0;
  final failedByBank = <String, List<String>>{};

  for (var sample in sampleSms) {
    // Filter out OTPs and Spam
    if (sample.sender == 'SPAM') continue;
    if (sample.body.toLowerCase().contains('otp') ||
        sample.body.toLowerCase().contains('code') ||
        sample.body.toLowerCase().contains('one time password')) {
      continue;
    }

    totalTransactions++;

    // Determine the bank name from definitions based on sender
    String bankName = 'Unknown/Generic';
    final senderUpper = sample.sender.toUpperCase();
    for (var def in definitions) {
      if (def.senderIdentifiers.any((id) => senderUpper.contains(id.toUpperCase()))) {
        bankName = def.bankName;
        break;
      }
    }

    bankStats.putIfAbsent(bankName, () => {'total': 0, 'success': 0, 'merchant': 0, 'verified': 0});
    bankStats[bankName]!['total'] = (bankStats[bankName]!['total'] ?? 0) + 1;

    final parser = BankParserFactory.getParser(sample.sender);
    final resH = parser.parse(sample.body);
    
    if (resH != null) {
      bankStats[bankName]!['success'] = (bankStats[bankName]!['success'] ?? 0) + 1;
      if (resH.merchant != null) bankStats[bankName]!['merchant'] = (bankStats[bankName]!['merchant'] ?? 0) + 1;
      if (resH.isVerified) bankStats[bankName]!['verified'] = (bankStats[bankName]!['verified'] ?? 0) + 1;
    } else {
      failedByBank.putIfAbsent(bankName, () => []);
      failedByBank[bankName]!.add('[${sample.sender}] ${sample.body}');
    }
  }

  // Print Summary Table
  print('\n| Bank Name | Total | Success | Accuracy | Merchant |');
  print('|-----------|-------|---------|----------|----------|');
  
  final sortedBanks = bankStats.keys.toList()..sort();
  int overallSuccess = 0;

  for (var name in sortedBanks) {
    final stats = bankStats[name]!;
    final total = stats['total']!;
    final success = stats['success']!;
    final merchant = stats['merchant']!;
    overallSuccess += success;
    
    double acc = (success / total) * 100;
    print('| ${name.padRight(18)} | ${total.toString().padLeft(5)} | ${success.toString().padLeft(7)} | ${acc.toStringAsFixed(1).padLeft(7)}% | ${merchant.toString().padLeft(8)} |');
  }

  print('\n[OVERALL PERFORMANCE]');
  print('Total Parsable SMS: $totalTransactions');
  print('Overall Accuracy: ${((overallSuccess / totalTransactions) * 100).toStringAsFixed(1)}%');
  print('----------------------------------');

  // Print failures for top banks with issues
  print('\nDETAILED FAILURES:');
  for (var name in sortedBanks) {
    final failures = failedByBank[name];
    if (failures != null && failures.isNotEmpty) {
      print('\n--- $name (${failures.length} failures) ---');
      for (var f in failures.take(3)) {
        print('  $f');
      }
      if (failures.length > 3) print('  ... and ${failures.length - 3} more.');
    }
  }
}
