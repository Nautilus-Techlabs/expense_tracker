
import 'package:expense_tracker/domain/entities/bank_definition.dart';
import 'package:expense_tracker/domain/parsers/hierarchical_engine.dart';
import 'package:expense_tracker/data/sample_data.dart';
import 'dart:io';
import 'dart:convert';

void main() async {
  final file = File('assets/bank_configs.json');
  final jsonStr = await file.readAsString();
  final Map<String, dynamic> jsonData = json.decode(jsonStr);
  final List<dynamic> jsonList = jsonData['banks'];
  final definitions = jsonList.map((j) => BankDefinition.fromJson(j)).toList();

  final bobDef = definitions.firstWhere((d) => d.bankName == 'Bank of Baroda');
  final parser = HierarchicalBankParser(bobDef);

  print('--- BOB FAILURE ANALYSIS ---');
  for (var sms in sampleSms) {
    if (bobDef.canHandle(sms.sender) || sms.body.contains('BOB')) {
       if (!bobDef.canHandle(sms.sender) && !sms.sender.contains('BOB')) continue;
      
      final tx = parser.parse(sms.body);
      if (tx != null) {
        print('SUCCESS: [${sms.sender}] ${sms.body}');
        print('   -> Amt: ${tx.amount}, Acc: ${tx.account}, Merchant: ${tx.merchant}, Type: ${tx.type}');
      } else {
        print('FAILURE: [${sms.sender}] ${sms.body}');
      }
    }
  }
}
