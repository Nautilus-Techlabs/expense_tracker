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
      templates.removeWhere((t) => t['name'] == 'IDFC FASTag Debit');
      templates.add({
        "name": "IDFC FASTag Debit",
        "pattern": "(?:INR|Rs\\.?|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+toll\\s+paid\\s+from\\s+IDFC\\s+FIRST\\s+Bank\\s+Tag\\s+([\\wX*]+)",
        "type": "debit",
        "amountGroup": 1,
        "accountGroup": 2,
        "method": "fastag",
        "priority": 1
      });
    }
    
    if (bank['bankName'] == 'IndusInd Bank') {
      final templates = bank['templates'] as List<dynamic>;
      // Add a more generic pattern for IndusInd
      templates.insert(0, {
        "name": "IndusInd Alphanumeric Account Credit",
        "pattern": "(?:A/C|account|A/c)\\s+(\\*\\*[\\d]+|[\\w]+)\\s+credited\\s+by\\s+(?:Rs\\.?|INR|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+from\\s+([^\\s]+)",
        "type": "credit",
        "amountGroup": 2,
        "accountGroup": 1,
        "merchantGroup": 3,
        "method": "bank",
        "priority": 1
      });
    }
  }

  final encoder = JsonEncoder.withIndent('    ');
  file.writeAsStringSync(encoder.convert(data));

  print("Refined IDFC and IndusInd configs successfully!");
}
