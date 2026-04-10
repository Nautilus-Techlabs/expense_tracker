import 'dart:convert';
import 'dart:io';
import 'package:expense_tracker/domain/sms_parser.dart';
import 'package:expense_tracker/domain/parsers/combined_parser.dart';
import 'package:expense_tracker/domain/parsers/entities/bank_definition.dart';

void main() {
  final configFile = File('assets/bank_configs.json');
  final jsonString = configFile.readAsStringSync();
  final data = json.decode(jsonString) as Map<String, dynamic>;
  final banksJson = data['banks'] as List<dynamic>;
  final definitions = banksJson
      .map((b) => BankDefinition.fromJson(b as Map<String, dynamic>))
      .toList();

  BankParserFactory.initializeFromDefinitions(definitions);
  final engine = SmsParserEngine();

  print('--- ICICI IMPS ---');
  const smsI =
      'A/c XX1234 debited for Rs 3,000.00 on 02-Apr-25. IMPS/1234567890/Zomato/. Avl Bal INR 9,200.00.';
  final txI = engine.tryParse(smsI, sender: 'ICICIB');
  print(
    'Template: ${txI?.templateName}, Amount: ${txI?.amount}, Merchant: ${txI?.merchant}',
  );

  print('\n--- SBI IMPS ---');
  const smsS =
      'Rs 2,500.00 debited from a/c XX1234. IMPS:1234567890/Transfer/Ref. If not done by you, call 1800...';
  final txS = engine.tryParse(smsS, sender: 'SBIINB');
  print(
    'Template: ${txS?.templateName}, Amount: ${txS?.amount}, Merchant: ${txS?.merchant}',
  );
}
