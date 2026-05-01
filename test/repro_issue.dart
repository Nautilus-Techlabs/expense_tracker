import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/domain/entities/bank_definition.dart';
import 'package:expense_tracker/domain/parsers/combined_parser.dart';
import 'package:expense_tracker/domain/sms_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  test('Verification for Federal and Dhanlaxmi Banks', () async {
    final configFile = File('assets/bank_configs.json');
    final configString = configFile.readAsStringSync();
    final configJson = jsonDecode(configString);

    final List<BankDefinition> definitions = (configJson['banks'] as List)
        .map((b) => BankDefinition.fromJson(b))
        .toList();

    BankParserFactory.initializeFromDefinitions(definitions);
    final engine = SmsParserEngine();

    print('\n--- Testing All Federal Bank Samples ---');
    final fedSamples = sampleSms
        .where((s) => s.sender.contains('FEDBK'))
        .toList();
    for (var sample in fedSamples) {
      final tx = engine.tryParse(sample.body, sender: sample.sender);
      print('\nSMS: ${sample.body}');
      if (tx != null) {
        print(
          '✅ Parsed -> Amount: ${tx.amount}, Balance: ${tx.availableBalance}, Bank: ${tx.bankName}',
        );
      } else {
        print('❌ FAILED to parse');
      }
    }

    print('\n--- Testing All Dhanlaxmi Bank Samples ---');
    final dlxSamples = sampleSms
        .where((s) => s.sender.contains('DLXBNK'))
        .toList();
    for (var sample in dlxSamples) {
      final tx = engine.tryParse(sample.body, sender: sample.sender);
      print('\nSMS: ${sample.body}');
      if (tx != null) {
        print(
          '✅ Parsed -> Amount: ${tx.amount}, Balance: ${tx.availableBalance}, Bank: ${tx.bankName}',
        );
      } else {
        print('❌ FAILED to parse');
      }
    }
  });
}
