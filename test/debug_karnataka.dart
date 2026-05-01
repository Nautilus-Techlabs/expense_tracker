import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/domain/entities/bank_definition.dart';
import 'package:expense_tracker/domain/parsers/hierarchical_engine.dart';

void main() {
  final file = File('assets/bank_configs.json');
  final jsonStr = file.readAsStringSync();
  final data = json.decode(jsonStr);

  final karnatakaJson = (data['banks'] as List).firstWhere(
    (b) => b['bankName'] == 'Karnataka Bank',
  );

  // Apply the proposed fix to the JSON data in memory
  for (var t in karnatakaJson['templates']) {
    if (t['name'] == 'Karnataka Bank Universal Safety Net') {
      t['pattern'] =
          "(?:DEBITED|credited)[^.]*?Rs\\.?\\s*([0-9,]+(?:\\.\\d{1,2})?)";
    }
  }

  final definition = BankDefinition.fromJson(karnatakaJson);
  final parser = HierarchicalBankParser(definition);

  final smsList = [
    'Your A/c XX1234 is DEBITED for Rs 1,000.00 on 27-04-26. Total Avl Bal is Rs 5,000.00. -KARNATAKA BANK',
    'A/c XX1234 is DEBITED Rs 100.00 on 27-04-26. Balance is Rs 5000.00',
    'Your A/c XX1234 is DEBITED. Available Balance is Rs 5,000.00',
  ];

  for (var sms in smsList) {
    print('--- SMS: $sms ---');
    final tx = parser.parse(sms);
    if (tx != null) {
      print('Template: ${tx.templateName}');
      print('Amount: ${tx.amount}');
      print('Type: ${tx.type}');
      print('Account: ${tx.account}');
      print('Balance: ${tx.availableBalance}');
    } else {
      print('NO MATCH (Safe!)');
    }
    print('');
  }
}
