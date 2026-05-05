
import 'package:expense_tracker/domain/entities/bank_definition.dart';
import 'package:expense_tracker/domain/parsers/hierarchical_engine.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/data/sample_data.dart';
import 'dart:io';
import 'dart:convert';

void main() async {
  final file = File('assets/bank_configs.json');
  final jsonStr = await file.readAsString();
  final Map<String, dynamic> jsonData = json.decode(jsonStr);
  final List<dynamic> jsonList = jsonData['banks'];
  final definitions = jsonList.map((j) => BankDefinition.fromJson(j)).toList();

  final sbiDef = definitions.firstWhere((d) => d.bankName == 'SBI Bank');
  final parser = HierarchicalBankParser(sbiDef);

  print('--- SBI FAILURE ANALYSIS ---');
  int total = 0;
  int success = 0;

  for (var sms in sampleSms) {
    if (sbiDef.senderIdentifiers.any((id) => sms.sender.toUpperCase().contains(id.toUpperCase()))) {
      total++;
      final tx = parser.parse(sms.body);
      if (tx != null) {
        success++;
      } else {
        print('FAILURE: [${sms.sender}] ${sms.body}');
      }
    }
  }
  print('Total: $total, Success: $success');

  print('\n--- SBYONO SPECIFIC TEST ---');
  final sbyonoMsg = 'Your account No: XXXX4861 is debited with Rs. 4000.00 on 01-May-26 towards ATM cash withdrawal. Available balance is Rs. 70650.00';
  final tx = parser.parse(sbyonoMsg);
  if (tx != null) {
    print('SBYONO SUCCESS!');
    print('Amount: ${tx.amount}');
    print('Account: ${tx.account}');
    print('Type: ${tx.type}');
  } else {
    print('SBYONO FAILED');
  }
}
