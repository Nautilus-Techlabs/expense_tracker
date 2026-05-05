import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('e:/P-Code/expense_tracker/assets/bank_configs.json');
  final content = file.readAsStringSync();
  final Map<String, dynamic> data = jsonDecode(content);
  final List<dynamic> banks = data['banks'];

  // Ensure AU Small Finance Bank has the patterns
  for (var bank in banks) {
    if (bank['bankName'] == 'AU Small Finance Bank') {
      final templates = bank['templates'] as List<dynamic>;
      // Remove any existing ones we added previously
      templates.removeWhere((t) => t['name'] == 'AU Debited With Pattern' || t['name'] == 'AU Payment Credited Pattern');
      
      templates.insert(0, {
        "name": "AU Debited With Pattern",
        "pattern": "(?:Debited\\s+with|debited\\s+for)\\s+(?:INR|Rs\\.?)\\s*([0-9,]+(?:\\.\\d{2})?)",
        "type": "debit",
        "amountGroup": 1,
        "method": "bank",
        "priority": 1
      });
      templates.insert(0, {
        "name": "AU Payment Credited Pattern",
        "pattern": "(?:Payment\\s+of\\s+)?(?:INR|Rs\\.?)\\s*([0-9,]+(?:\\.\\d{2})?)\\s+(?:was\\s+)?credited",
        "type": "credit",
        "amountGroup": 1,
        "method": "card",
        "priority": 1
      });
    }
  }

  // Remove Federal Bank if it exists to replace it with updated version
  banks.removeWhere((b) => b['bankName'] == 'Federal Bank');

  banks.add({
    "bankName": "Federal Bank",
    "senderIdentifiers": [
      "FDRL",
      "FEDERAL",
      "FDRLBK",
      "FDLBNK",
      "FEDBNK",
      "FEDFI"
    ],
    "templates": [
      {
        "name": "Federal Credit Pattern",
        "pattern": "(?:Rs\\.?|INR)\\s*([0-9,]+(?:\\.\\d{2})?)\\s+credited\\s+to\\s+(?:your\\s+)?A/c\\s+([\\dX*]+)",
        "type": "credit",
        "amountGroup": 1,
        "accountGroup": 2,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "Federal Debit From Pattern",
        "pattern": "(?:Rs\\.?|INR)\\s*([0-9,]+(?:\\.\\d{2})?)\\s+debited\\s+from\\s+(?:your\\s+)?A/c\\s+([\\dX*]+)",
        "type": "debit",
        "amountGroup": 1,
        "accountGroup": 2,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "Federal E-Mandate Processed",
        "pattern": "payment\\s+of\\s+(?:INR|Rs\\.?)\\s*([0-9,]+(?:\\.\\d{2})?)\\s+for\\s+([\\s\\S]*?)\\s+via\\s+e-mandate[\\s\\S]*?on\\s+Federal\\s+Bank\\s+Debit\\s+Card\\s+(\\d+)\\s+is\\s+processed",
        "type": "debit",
        "amountGroup": 1,
        "merchantGroup": 2,
        "accountGroup": 3,
        "method": "card",
        "priority": 1
      },
      {
        "name": "Federal Sent From Account",
        "pattern": "(?:INR|Rs\\.?)\\s*([0-9,]+(?:\\.\\d{2})?)\\s+sent\\s+from\\s+your\\s+(?:Account|account)\\s+([\\dX*]+)[\\s\\S]*?To:\\s*([^\\s]+)",
        "type": "debit",
        "amountGroup": 1,
        "accountGroup": 2,
        "merchantGroup": 3,
        "method": "upi",
        "priority": 2
      },
      {
        "name": "Federal Sent From Account Generic",
        "pattern": "(?:INR|Rs\\.?)\\s*([0-9,]+(?:\\.\\d{2})?)\\s+sent\\s+from\\s+your\\s+(?:Account|account)\\s+([\\dX*]+)",
        "type": "debit",
        "amountGroup": 1,
        "accountGroup": 2,
        "method": "bank",
        "priority": 3
      },
      {
        "name": "Federal ECOM Debit",
        "pattern": "(?:Rs\\.?|INR)\\s*([0-9,]+(?:\\.\\d+)?)\\s*debited\\s*by\\s*ECOM\\s*Txn\\s*using\\s*your\\s*card\\s*([\\dX*]+)\\s*at\\s*([\\s\\S]*?)\\s*on",
        "type": "debit",
        "amountGroup": 1,
        "accountGroup": 2,
        "merchantGroup": 3,
        "method": "card",
        "priority": 2
      },
      {
        "name": "Federal Universal Safety Net",
        "pattern": "(?:debited|credited|sent|payment)[\\s\\S]*?(?:Rs\\.?|INR)\\s*([0-9,]+(?:\\.\\d{1,2})?)[\\s\\S]*?(?:A/c|account|Card)?\\s*([\\dX*]+)?",
        "type": "unknown",
        "amountGroup": 1,
        "accountGroup": 2,
        "method": "unknown",
        "priority": 50
      }
    ]
  });

  // Write back formatted
  final encoder = JsonEncoder.withIndent('    ');
  file.writeAsStringSync(encoder.convert(data));

  print("Updated bank_configs.json successfully!");
}
