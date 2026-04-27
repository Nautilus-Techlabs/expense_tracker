import 'dart:convert';
import 'dart:io';

void main() {
  final configFile = File('assets/bank_configs.json');
  final jsonString = configFile.readAsStringSync();
  final data = json.decode(jsonString) as Map<String, dynamic>;
  final banksJson = data['banks'] as List<dynamic>;
  
  bool modified = false;
  
  for (var b in banksJson) {
    if (b['bankName'] == 'Standard Chartered Bank') {
      List<dynamic> templates = b['templates'];
      
      final newTemplates = [
        {
          "name": "SCB Amount First Debit",
          "pattern": "(?:INR|Rs\\.?)[\\s:]*([0-9,]+(?:\\.\\d{2})?)\\s+(?:spent|debited|paid|withdrawn)",
          "type": "debit",
          "amountGroup": 1,
          "method": "bank",
          "priority": 1
        },
        {
          "name": "SCB Keyword First Credit",
          "pattern": "(?:[Cc]redit|[Rr]efund|[Cc]redited).*?(?:INR|Rs\\.?)[\\s:]*([0-9,]+(?:\\.\\d{2})?)",
          "type": "credit",
          "amountGroup": 1,
          "method": "bank",
          "priority": 2
        },
        {
          "name": "SCB USD Txn",
          "pattern": "(?:txn|spent|paid).*?USD\\s*([0-9,]+(?:\\.\\d{2})?)",
          "type": "debit",
          "amountGroup": 1,
          "method": "bank",
          "priority": 3
        }
      ];
      
      for (var t in templates) {
        if (t['priority'] != null && t['priority'] < 10) {
          t['priority'] += 10;
        } else if (t['name'] == 'SCB Universal Safety Net') {
          t['priority'] = 50;
        }
      }
      
      templates.insertAll(0, newTemplates);
      modified = true;
    }
  }
  
  if (modified) {
    final encoder = JsonEncoder.withIndent('  ');
    configFile.writeAsStringSync(encoder.convert(data) + '\n');
    print('Successfully updated Standard Chartered Bank config');
  } else {
    print('No changes made to Standard Chartered Bank config');
  }
}
