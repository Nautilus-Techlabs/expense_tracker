
import 'package:expense_tracker/domain/parsers/entities/bank_definition.dart';
import 'package:expense_tracker/domain/parsers/hierarchical_engine.dart';
import 'package:expense_tracker/domain/parsers/entities/transaction.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  final jsonString = File('assets/bank_configs.json').readAsStringSync();
  final data = json.decode(jsonString);
  final banks = (data['banks'] as List).map((b) => BankDefinition.fromJson(b)).toList();

  final idbi = banks.firstWhere((b) => b.bankName == 'IDBI Bank');
  final indusind = banks.firstWhere((b) => b.bankName == 'IndusInd Bank');
  final jio = banks.firstWhere((b) => b.bankName == 'Jio Payments Bank');

  final testCases = [
    {
      'bank': 'IDBI',
      'parser': HierarchicalBankParser(idbi),
      'sms': 'IDBI Bank Acct XX1234 debited for Rs. 1500.00 towards Amazon for UPI. RRN 123456789012. Bal Rs. 12000.00.',
      'expectedAmount': 1500.0
    },
    {
      'bank': 'IndusInd',
      'parser': HierarchicalBankParser(indusind),
      'sms': 'INR 4,500.00 has been debited from your IndusInd Bank A/c ending 1234 on 01-Apr-25. Avl Bal: INR 22,100.00.',
      'expectedAmount': 4500.0
    },
     {
      'bank': 'IndusInd 2',
      'parser': HierarchicalBankParser(indusind),
      'sms': 'INR 1,200.00 has been debited from your IndusInd Bank A/c ending 1234. Avl Bal: INR 20,900.00.',
      'expectedAmount': 1200.0
    },
    {
      'bank': 'Jio',
      'parser': HierarchicalBankParser(jio),
      'sms': 'Rs. 50.00 debited with JPB A/c x1234 to Merchant. UPI/DR/123456789012. Avl Bal: Rs. 450.00.',
      'expectedAmount': 50.0
    }
  ];

  for (var tc in testCases) {
    print('Testing ${tc['bank']}...');
    final tx = (tc['parser'] as HierarchicalBankParser).parse(tc['sms'] as String);
    if (tx == null) {
      print('  FAILED: No transaction parsed');
    } else {
      print('  Parsed Amount: ${tx.amount}');
      print('  Template Name: ${tx.templateName}');
      if (tx.amount == tc['expectedAmount']) {
        print('  SUCCESS');
      } else {
        print('  FAILED: Expected ${tc['expectedAmount']}, got ${tx.amount}');
      }
    }
    print('');
  }
}
