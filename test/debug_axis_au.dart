import 'dart:convert';
import 'dart:io';
import 'package:expense_tracker/domain/entities/bank_definition.dart';
import 'package:expense_tracker/domain/parsers/hierarchical_engine.dart';
import 'package:expense_tracker/data/sample_data.dart';

void main() {
  final configFile = File('assets/bank_configs.json');
  final jsonString = configFile.readAsStringSync();
  final data = json.decode(jsonString) as Map<String, dynamic>;
  final banksJson = data['banks'] as List<dynamic>;
  
  final axisJson = banksJson.firstWhere((b) => b['bankName'] == 'Axis Bank');
  final auJson = banksJson.firstWhere((b) => b['bankName'] == 'AU Small Finance Bank');
  
  final axisDef = BankDefinition.fromJson(axisJson);
  final auDef = BankDefinition.fromJson(auJson);
  
  final axisParser = HierarchicalBankParser(axisDef);
  final auParser = HierarchicalBankParser(auDef);

  print('--- AXIS BANK TEST ---');
  final axisSamples = sampleSms.where((s) => s.sender.contains('AXIS')).toList();
  for (var sample in axisSamples) {
    final res = axisParser.parse(sample.body);
    print('SMS: ${sample.body}');
    if (res != null) {
      print('✅ SUCCESS: ${res.type.name} - ${res.amount} from ${res.account}');
    } else {
      print('❌ FAILED');
      // Debug individual templates
      for (var t in axisDef.templates) {
        if (t.pattern.hasMatch(sample.body)) {
          print('  Pattern "${t.name}" matched but extraction failed?');
        }
      }
    }
    print('-' * 20);
  }

  print('\n--- AU BANK TEST ---');
  final auSamples = sampleSms.where((s) => s.sender.contains('AUBANK')).toList();
  for (var sample in auSamples) {
    final res = auParser.parse(sample.body);
    print('SMS: ${sample.body}');
    if (res != null) {
      print('✅ SUCCESS: ${res.type.name} - ${res.amount} from ${res.account} Bal: ${res.availableBalance}');
    } else {
      print('❌ FAILED');
    }
    print('-' * 20);
  }
}
