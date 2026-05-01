import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/domain/entities/bank_definition.dart';
import 'package:expense_tracker/domain/parsers/combined_parser.dart';
import 'package:test/test.dart';

void main() {
  final configFile = File('assets/bank_configs.json');
  final jsonString = configFile.readAsStringSync();
  final data = json.decode(jsonString) as Map<String, dynamic>;
  final banksJson = data['banks'] as List<dynamic>;
  final definitions = banksJson
      .map((b) => BankDefinition.fromJson(b as Map<String, dynamic>))
      .toList();

  BankParserFactory.initializeFromDefinitions(definitions);

  group('SBI Failures Debug', () {
    test('SBI: A/c Debited By', () {
      final parser = BankParserFactory.getParser('SBIINB');
      const sms =
          'Your A/c XX1234 debited by Rs 2,500.00 on 01Apr25. Avl Bal Rs.8,300.00. If not done by you, call 18004253800.';
      final tx = parser.parse(sms);

      print('Template: ${tx?.templateName}');
      print('Account: ${tx?.account}');

      expect(tx, isNotNull);
      expect(tx!.amount, 2500.0);
      expect(tx.account, contains('1234'));
    });

    test('SBI: Credit', () {
      final parser = BankParserFactory.getParser('SBIINB');
      const sms =
          'SBI: Rs1000.0 credited to A/c XX1234 on 05Feb26 by NEFT:REF NO 1234567890. Bal:Rs15000.0';
      final tx = parser.parse(sms);

      print('Template: ${tx?.templateName}');

      expect(tx, isNotNull);
      expect(tx!.amount, 1000.0);
      expect(tx.account, contains('1234'));
    });
  });
}
