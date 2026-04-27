import 'dart:convert';
import 'dart:io';
import 'package:expense_tracker/domain/parsers/combined_parser.dart';
import 'package:expense_tracker/domain/parsers/entities/bank_definition.dart';
import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/domain/parsers/entities/transaction.dart';

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

  print('--- SMS HIERARCHICAL PARSER ACCURACY REPORT (JSON DRIVEN) ---');
  print('Total Samples: ${sampleSms.length}');

  int hierSuccess = 0;
  int hierMerchants = 0;
  int hierVerified = 0;
  int totalTransactions = 0;

  final failedSamples = <String>[];

  for (var sample in sampleSms) {
    if (sample.sender == 'SPAM') continue;
    if (sample.body.toLowerCase().contains('otp') ||
        sample.body.toLowerCase().contains('code'))
      continue;

    totalTransactions++;

    // Hierarchical Results
    final parser = BankParserFactory.getParser(sample.sender);
    final resH = parser.parse(sample.body);
    if (resH != null) {
      hierSuccess++;
      if (resH.merchant != null) hierMerchants++;
      if (resH.isVerified) hierVerified++;
    } else {
      failedSamples.add('[${sample.sender}] ${sample.body}');
    }
  }

  double hp = (hierSuccess / totalTransactions) * 100;
  double hm = (hierMerchants / hierSuccess) * 100;
  double hv = (hierVerified / hierSuccess) * 100;

  print('\n[HIERARCHICAL PARSER PERFORMANCE]');
  print('Active Coverage: $hierSuccess / $totalTransactions identified.');
  print('Accuracy Score: ${hp.toStringAsFixed(1)}%');
  print('Verified Matches: ${hierVerified} (${hv.toStringAsFixed(1)}%)');
  print(
    'Merchant Extraction: ${hm.toStringAsFixed(1)}% ($hierMerchants/$hierSuccess)',
  );
  print('----------------------------------');

  if (failedSamples.isNotEmpty) {
    print('\nFAILED SAMPLES:');
    for (var failed in failedSamples.take(20)) {
      print(failed);
    }
    if (failedSamples.length > 20) {
      print('... and ${failedSamples.length - 20} more.');
    }
  }
}
