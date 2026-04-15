import 'dart:convert';
import 'dart:io';

void main() {
  final configFile = File('assets/bank_configs.json');
  final jsonStr = configFile.readAsStringSync();
  final Map<String, dynamic> root = jsonDecode(jsonStr);
  final List<dynamic> banks = root['banks'];

  // Test HSBC SMS
  const sms = 'Rs.40,000.00 credited to HSBC A/c XX1234 on 02-Apr-25. Avl Bal Rs.71,250.00.';
  print('📨 SMS: $sms\n');

  // Find Generic bank
  final genericBank = banks.firstWhere(
    (b) => b['bankName'] == 'Generic',
    orElse: () => null,
  );

  if (genericBank == null) {
    print('❌ Generic bank config NOT FOUND');
    return;
  }

  print('--- Testing against Generic Templates ---');
  for (final tmpl in genericBank['templates']) {
    final name = tmpl['name'];
    final patternStr = tmpl['pattern'];
    final type = tmpl['type'];
    final priority = tmpl['priority'];

    try {
      final regex = RegExp(patternStr, caseSensitive: false);
      final match = regex.firstMatch(sms);

      if (match != null) {
        print('✅ [P$priority] "$name" MATCHED as $type');
        print('   Pattern: $patternStr');
        for (int i = 0; i <= match.groupCount; i++) {
          print('   Group $i: "${match.group(i)}"');
        }
        print('');
      }
    } catch (e) {
      print('⚠️ Error in template "$name": $e');
    }
  }
}
