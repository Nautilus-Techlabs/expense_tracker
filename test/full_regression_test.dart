
import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/domain/parsers/entities/bank_definition.dart';
import 'package:expense_tracker/domain/parsers/hierarchical_engine.dart';
import 'package:expense_tracker/domain/parsers/combined_parser.dart';
import 'package:expense_tracker/domain/parsers/entities/transaction.dart';
import 'dart:convert';
import 'dart:io';

void main() async {
  final jsonString = File('assets/bank_configs.json').readAsStringSync();
  final data = json.decode(jsonString);
  final definitions = (data['banks'] as List).map((b) => BankDefinition.fromJson(b)).toList();
  
  BankParserFactory.initializeFromDefinitions(definitions);

  int total = sampleSms.length;
  int parsed = 0;
  List<String> failures = [];

  for (var i = 0; i < sampleSms.length; i++) {
    final sms = sampleSms[i];
    final parser = BankParserFactory.getParser(sms.sender);
    final tx = parser.parse(sms.body);

    if (tx != null) {
      parsed++;
    } else {
      failures.add('Sample $i: ${sms.sender} - ${sms.body}');
    }
  }

  print('--- REGRESSION TEST RESULTS ---');
  print('Total Samples: $total');
  print('Successfully Parsed: $parsed (${(parsed/total*100).toStringAsFixed(1)}%)');
  print('Failures: ${total - parsed}');
  
  if (failures.isNotEmpty) {
     print('\nTop 10 Failures:');
     failures.take(10).forEach(print);
  }
}
