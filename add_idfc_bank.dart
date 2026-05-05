import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('e:/P-Code/expense_tracker/assets/bank_configs.json');
  final content = file.readAsStringSync();
  final Map<String, dynamic> data = jsonDecode(content);
  final List<dynamic> banks = data['banks'];

  // Check if IDFC FIRST Bank exists
  final idfcExists = banks.any((b) => b['bankName'] == 'IDFC FIRST Bank');

  if (!idfcExists) {
    banks.add({
      "bankName": "IDFC FIRST Bank",
      "senderIdentifiers": [
        "IDFCFB",
        "IDFCBK",
        "IDFC",
        "FIRST",
        "IDFCPG",
        "IDFCBN",
        "IDFCFT"
      ],
      "templates": [
        {
          "name": "IDFC Card Spent",
          "pattern": "(?:INR|Rs\\.?|USD)\\s*([0-9,]+(?:\\.\\d+)?)\\s+spent\\s+on\\s+IDFC\\s+FIRST\\s+Bank\\s+Card\\s+(?:ending\\s+)?([\\dX*]+)\\s+on\\s+([\\s\\S]*?)\\s+@\\s+([^.]+)",
          "type": "debit",
          "amountGroup": 1,
          "accountGroup": 2,
          "merchantGroup": 4,
          "method": "card",
          "priority": 1
        },
        {
          "name": "IDFC Account Debited",
          "pattern": "A/c\\s+([\\dX*]+)\\s+debited\\s+for\\s+(?:Rs\\.?|INR)\\s*([0-9,]+(?:\\.\\d+)?)\\s+on\\s+([\\s\\S]*?)\\s+via\\s+UPI\\s+to\\s+([^.]+)",
          "type": "debit",
          "amountGroup": 2,
          "accountGroup": 1,
          "merchantGroup": 4,
          "method": "upi",
          "priority": 1
        },
        {
          "name": "IDFC Credit Alert",
          "pattern": "Credit\\s+Alert:\\s+(?:INR|Rs\\.?)\\s*([0-9,]+(?:\\.\\d+)?)\\s+received\\s+in\\s+A/c\\s+([\\dX*]+)\\s+on\\s+([\\s\\S]*?)\\s+from\\s+([^.]+)",
          "type": "credit",
          "amountGroup": 1,
          "accountGroup": 2,
          "merchantGroup": 4,
          "method": "bank",
          "priority": 1
        },
        {
          "name": "IDFC Cash Withdrawal",
          "pattern": "Cash\\s+Wdl\\s+of\\s+(?:Rs\\.?|INR)\\s*([0-9,]+(?:\\.\\d+)?)\\s+from\\s+IDFC\\s+Bank\\s+A/c\\s+([\\dX*]+)\\s+on\\s+([\\s\\S]*?)\\s+at\\s+([^.]+)",
          "type": "debit",
          "amountGroup": 1,
          "accountGroup": 2,
          "merchantGroup": 4,
          "method": "atm",
          "priority": 1
        },
        {
          "name": "IDFC Credited Cashback",
          "pattern": "IDFC\\s+Bank\\s+A/c\\s+([\\dX*]+)\\s+is\\s+credited\\s+with\\s+(?:Rs\\.?|INR)\\s*([0-9,]+(?:\\.\\d+)?)\\s+([^.]+)",
          "type": "credit",
          "amountGroup": 2,
          "accountGroup": 1,
          "merchantGroup": 3,
          "method": "bank",
          "priority": 1
        },
        {
          "name": "IDFC Debited Charge",
          "pattern": "A/c\\s+ending\\s+([\\dX*]+)\\s+is\\s+debited\\s+by\\s+(?:Rs\\.?|INR)\\s*([0-9,]+(?:\\.\\d+)?)\\s+as\\s+it\\s+did\\s+not\\s+have.*?on\\s+([\\s\\S]*?)\\.",
          "type": "debit",
          "amountGroup": 2,
          "accountGroup": 1,
          "method": "bank",
          "priority": 1
        },
        {
          "name": "IDFC Successful Transaction",
          "pattern": "Successful!\\s+(?:USD|INR|Rs\\.?)\\s*([0-9,]+(?:\\.\\d+)?)\\s+spent\\s+on.*?Credit\\s+Card\\s+ending\\s+([\\dX*]+)\\s+at\\s+([^\\s]+)\\s+on\\s+([\\s\\S]*?)\\s+at",
          "type": "debit",
          "amountGroup": 1,
          "accountGroup": 2,
          "merchantGroup": 3,
          "method": "card",
          "priority": 1
        },
        {
          "name": "IDFC Universal Safety Net",
          "pattern": "(?:debited|credited|spent|withdrawn|received)[\\s\\S]*?(?:Rs\\.?|INR|USD)\\s*([0-9,]+(?:\\.\\d{1,2})?)[\\s\\S]*?(?:A/c|account|Card)?\\s*([\\dX*]+)?",
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

  print("Updated bank_configs.json with IDFC FIRST Bank successfully!");
}
