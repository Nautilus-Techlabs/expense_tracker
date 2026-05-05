import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('e:/P-Code/expense_tracker/assets/bank_configs.json');
  final content = file.readAsStringSync();
  final data = jsonDecode(content);
  final banks = data['banks'] as List;
  
  for (var bank in banks) {
    final name = bank['bankName'].toString().toLowerCase();
    if (name.contains('au') || name.contains('ausmall')) {
      print('Found bank: \${bank["bankName"]}');
      print(jsonEncode(bank));
    }
  }
}
