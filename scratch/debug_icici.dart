
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

  final iciciDef = definitions.firstWhere((d) => d.bankName == 'ICICI Bank');
  final parser = HierarchicalBankParser(iciciDef);

  print('--- ICICI FAILURE ANALYSIS ---');
  int total = 0;
  int success = 0;

  for (var sms in sampleSms) {
    if (iciciDef.senderIdentifiers.any((id) => sms.sender.toUpperCase().contains(id.toUpperCase()))) {
      total++;
      final tx = parser.parse(sms.body);
      if (tx != null) {
        success++;
        print('SUCCESS: [${sms.sender}] ${sms.body}');
        print('   -> Amt: ${tx.amount}, Acc: ${tx.account}, Merchant: ${tx.merchant}, Type: ${tx.type}');
      } else {
        print('FAILURE: [${sms.sender}] ${sms.body}');
      }
    }
  }
  print('Total: $total, Success: $success');
}
