import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/domain/entities/bank_definition.dart';
import 'package:expense_tracker/domain/parsers/combined_parser.dart';

void main(List<String> args) {
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

  // 2. Initialize the factory with these definitions
  BankParserFactory.initializeFromDefinitions(definitions);

  // 3. Handle single SMS input via command line if provided
  if (args.isNotEmpty) {
    final rawSms = args.join(' ');
    _debugSms(rawSms, 'MANUAL');
    return;
  }

  // 4. Run on sample data
  print('\n${'=' * 80}');
  print('PARSER DEBUGGER REPORT');
  print('=' * 80);
  print(
    '${"SENDER".padRight(12)} | ${"CONF".padRight(4)} | ${"BANK".padRight(15)} | ${"AMT".padRight(10)} | ${"MERCHANT"}',
  );
  print('-' * 80);

  int total = 0;
  int verified = 0;
  int generic = 0;
  int failed = 0;

  for (var sample in sampleSms) {
    total++;
    final parser = BankParserFactory.getParser(sample.sender);
    final tx = parser.parse(sample.body);

    if (tx == null) {
      failed++;
      final senderSub = sample.sender.substring(
        0,
        sample.sender.length > 12 ? 12 : sample.sender.length,
      );
      final bodySub = sample.body.substring(
        0,
        sample.body.length > 30 ? 30 : sample.body.length,
      );
      print(
        '${senderSub.padRight(12)} | ERR  | ${"FAILED".padRight(15)} | ${"0.0".padRight(10)} | $bodySub...',
      );
      continue;
    }

    if (tx.isVerified) {
      verified++;
    } else {
      generic++;
    }

    final confStr = tx.isVerified ? '✅' : '⚠️';
    final bankStr = tx.bankName.length > 15
        ? tx.bankName.substring(0, 15)
        : tx.bankName;
    final amtStr = tx.amount.toStringAsFixed(2);
    final merchStr = tx.merchant ?? 'Unknown';

    final senderSub = sample.sender.substring(
      0,
      sample.sender.length > 12 ? 12 : sample.sender.length,
    );
    print(
      '${senderSub.padRight(12)} |  $confStr  | ${bankStr.padRight(15)} | ${amtStr.padRight(10)} | $merchStr',
    );
  }

  print('=' * 80);
  print('SUMMARY:');
  print('Total Samples: $total');
  print('Verified (✅): $verified');
  print('Estimated (⚠️): $generic');
  print('Failed   (ERR): $failed');
  print(
    'Accuracy: ${((verified + generic) / total * 100).toStringAsFixed(1)}%',
  );
  print('=' * 80 + '\n');
}

void _debugSms(String sms, String sender) {
  final parser = BankParserFactory.getParser(sender);
  final tx = parser.parse(sms);

  print('\n--- SMS DEBUG INFO ---');
  print('Raw: $sms');
  if (tx == null) {
    print('STATUS: FAILED TO PARSE');
  } else {
    print(
      'STATUS:   ${tx.isVerified ? "VERIFIED ✅" : "ESTIMATED ⚠️ (Generic Fallback)"}',
    );
    print('BANK:     ${tx.bankName}');
    print('TEMPLATE: ${tx.templateName ?? "None"}');
    print('AMOUNT:   ${tx.amount}');
    print('TYPE:     ${tx.type.name.toUpperCase()}');
    print('METHOD:   ${tx.method.name.toUpperCase()}');
    print('MERCHANT: ${tx.merchant}');
    print('ACCOUNT:  ${tx.account}');
    print('BALANCE:  ${tx.availableBalance}');
  }
}
