import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('e:/P-Code/expense_tracker/assets/bank_configs.json');
  final content = file.readAsStringSync();
  final Map<String, dynamic> data = jsonDecode(content);
  final List<dynamic> banks = data['banks'];

  // Update AU Small Finance Bank
  for (var bank in banks) {
    if (bank['bankName'] == 'AU Small Finance Bank') {
      final templates = bank['templates'] as List<dynamic>;
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

  // Check if Federal Bank exists
  final federalExists = banks.any((b) => b['bankName'] == 'Federal Bank');

  if (!federalExists) {
    banks.add({
      "bankName": "Federal Bank",
      "senderIdentifiers": [
        "FDRL",
        "FEDERAL",
        "FDRLBK",
        "FDLBNK",
        "FEDBNK"
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
          "pattern": "payment\\s+of\\s+(?:INR|Rs\\.?)\\s*([0-9,]+(?:\\.\\d{2})?)\\s+for\\s+(.*?)\\s+via\\s+e-mandate.*?on\\s+Federal\\s+Bank\\s+Debit\\s+Card\\s+(\\d+)\\s+is\\s+processed",
          "type": "debit",
          "amountGroup": 1,
          "merchantGroup": 2,
          "accountGroup": 3,
          "method": "card",
          "priority": 1
        },
        {
          "name": "Federal Sent From Account",
          "pattern": "(?:INR|Rs\\.?)\\s*([0-9,]+(?:\\.\\d{2})?)\\s+sent\\s+from\\s+your\\s+(?:Account|account)\\s+([\\dX*]+).*?To:\\s*([^\\s]+)",
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
          "pattern": "(?:Rs\\.?|INR)\\s*([0-9,]+(?:\\.\\d+)?)\\s+debited\\s+by\\s+ECOM\\s+Txn\\s+using\\s+your\\s+card\\s+([\\dX*]+)\\s+at\\s+(.*?)\\s+on",
          "type": "debit",
          "amountGroup": 1,
          "accountGroup": 2,
          "merchantGroup": 3,
          "method": "card",
          "priority": 2
        },
        {
          "name": "Federal Universal Safety Net",
          "pattern": "(?:debited|credited|sent|payment).*?(?:Rs\\.?|INR)\\s*([0-9,]+(?:\\.\\d{1,2})?).*?(?:A/c|account|Card)?\\s*([\\dX*]+)?",
          "type": "unknown",
          "amountGroup": 1,
          "accountGroup": 2,
          "method": "unknown",
          "priority": 50
        }
      ]
    });
  }

  // Use JsonEncoder with indent for formatting
  final encoder = JsonEncoder.withIndent('    ');
  file.writeAsStringSync(encoder.convert(data));

  print("Updated bank_configs.json successfully!");
}
