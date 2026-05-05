import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/domain/sms_parser.dart';
import 'package:expense_tracker/domain/parsers/combined_parser.dart';
import 'package:expense_tracker/domain/entities/bank_definition.dart';
import 'package:expense_tracker/core/utils/date_extractor.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  test('Federal Bank Full Test', () async {
    final file = File('e:/P-Code/expense_tracker/assets/bank_configs.json');
    final content = file.readAsStringSync();
    final data = jsonDecode(content);
    
    final defs = (data['banks'] as List).map((json) => BankDefinition.fromJson(json)).toList();
    BankParserFactory.initializeFromDefinitions(defs);
    
    final engine = SmsParserEngine();
    
    final samples = sampleSms.where((s) => s.sender.toUpperCase().contains('FED')).toList();
    print('Found \${samples.length} Federal samples');
    
    int parsed = 0;
    for (var s in samples) {
      print('--------------------------');
      print('SENDER: \${s.sender}');
      print('BODY: \${s.body}');
      final date = DateExtractor.extract(s.body);
      print('DATE EXTRACTED: \$date');
      
      final tx = engine.tryParse(s.body, sender: s.sender, fallbackDate: s.date);
      if (tx != null) {
        print('PARSED: \${tx.type} | Amount: \${tx.amount} | Bank: \${tx.bankName} | Template: \${tx.templateName}');
        parsed++;
      } else {
        print('PARSED: NULL');
      }
    }
    print('\\nMatched \$parsed / \${samples.length}');
  });
}
