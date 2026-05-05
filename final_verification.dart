import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/domain/sms_parser.dart';
import 'package:expense_tracker/domain/parsers/combined_parser.dart';
import 'package:expense_tracker/domain/entities/bank_definition.dart';
import 'package:expense_tracker/core/utils/date_extractor.dart';
import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('e:/P-Code/expense_tracker/assets/bank_configs.json');
  final content = file.readAsStringSync();
  final data = jsonDecode(content);
  
  final defs = (data['banks'] as List).map((json) => BankDefinition.fromJson(json)).toList();
  BankParserFactory.initializeFromDefinitions(defs);
  
  final engine = SmsParserEngine();
  
  final banksToTest = ['FED', 'IDFC', 'INDUS', 'AU', 'UCO'];
  
  int totalSamples = 0;
  int totalParsed = 0;

  for (var bankPrefix in banksToTest) {
    final samples = sampleSms.where((s) => s.sender.toUpperCase().contains(bankPrefix)).toList();
    print('\nFound ${samples.length} $bankPrefix samples');
    totalSamples += samples.length;
    
    int parsed = 0;
    for (var s in samples) {
      final tx = engine.tryParse(s.body, sender: s.sender, fallbackDate: s.date);
      if (tx != null) {
        print('PARSED: ${tx.type} | Amount: ${tx.amount} | Balance: ${tx.availableBalance} | Template: ${tx.templateName}');
        parsed++;
        totalParsed++;
      } else {
        print('FAILED to parse $bankPrefix: ${s.body}');
      }
    }
    print('Matched $parsed / ${samples.length} $bankPrefix samples');
  }
  
  print('\nOVERALL MATCHED: $totalParsed / $totalSamples');
}
