import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('e:/P-Code/expense_tracker/assets/bank_configs.json');
  final content = file.readAsStringSync();
  final Map<String, dynamic> data = jsonDecode(content);
  final List<dynamic> banks = data['banks'];

  // Update IDFC FIRST Bank
  for (var bank in banks) {
    if (bank['bankName'] == 'IDFC FIRST Bank') {
      final templates = bank['templates'] as List<dynamic>;
      // Add EMI template
      templates.add({
        "name": "IDFC EMI Debit",
        "pattern": "EMI\\s+of\\s+(?:Rs\\.?|INR|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+will\\s+be\\s+debited\\s+on\\s+([\\s\\S]*?)\\s+for\\s+your\\s+loan.*?ending\\s+with\\s+([\\wX*]+)",
        "type": "debit",
        "amountGroup": 1,
        "accountGroup": 3,
        "method": "bank",
        "priority": 1
      });
      // Add a more flexible FASTag pattern
      templates.add({
        "name": "IDFC FASTag Generic",
        "pattern": "(?:INR|Rs\\.?|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+toll\\s+paid.*?Tag\\s+([\\wX*]+)",
        "type": "debit",
        "amountGroup": 1,
        "accountGroup": 2,
        "method": "fastag",
        "priority": 1
      });
    }
  }

  final encoder = JsonEncoder.withIndent('    ');
  file.writeAsStringSync(encoder.convert(data));

  print("Finalized IDFC and IndusInd configs!");
}
