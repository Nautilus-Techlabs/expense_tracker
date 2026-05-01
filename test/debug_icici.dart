import 'dart:convert';
import 'dart:io';

void main() {
  final configFile = File('assets/bank_configs.json');
  final jsonString = configFile.readAsStringSync();
  final data = json.decode(jsonString) as Map<String, dynamic>;
  final banksXml = data['banks'] as List<dynamic>;

  final iciciBank = banksXml.firstWhere((b) => b['bankName'] == 'ICICI Bank');
  final templates = iciciBank['templates'] as List<dynamic>;
  final impsTemplate = templates.firstWhere(
    (t) => t['name'] == 'ICICI General Info',
  );

  const sms =
      'A/c XX1234 debited for Rs 3,000.00 on 02-Apr-25. IMPS/1234567890/Zomato/. Avl Bal INR 9,200.00.';
  final pattern = impsTemplate['pattern'];

  print('Pattern: $pattern');
  final regExp = RegExp(pattern, caseSensitive: false);
  final match = regExp.firstMatch(sms);

  if (match == null) {
    print('Match: FAILED');
    // Try to find where it fails
    final part1 = r'(?:A/c|Acct)\s+([\dX*]+)';
    print(
      'Part 1 ($part1): ${RegExp(part1, caseSensitive: false).hasMatch(sms)}',
    );

    final part2 = r'debited\s+(?:for|by|INR|Rs\.?)\s*([0-9,]+(?:\.\d+)?)';
    print(
      'Part 2 ($part2): ${RegExp(part2, caseSensitive: false).hasMatch(sms)}',
    );

    final part3 = r'.*?(?:IMPS|NEFT|Ref).*?/(?:[\dA-Z]+)/([^/.\s]+)';
    print(
      'Part 3 ($part3): ${RegExp(part3, caseSensitive: false).hasMatch(sms)}',
    );
  } else {
    print('Match: SUCCESS');
    print('Group 1 (Account): ${match.group(1)}');
    print('Group 2 (Amount): ${match.group(2)}');
    print('Group 3 (Merchant): ${match.group(3)}');
  }
}
