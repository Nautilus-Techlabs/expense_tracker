import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('e:/P-Code/expense_tracker/assets/bank_configs.json');
  final content = file.readAsStringSync();
  final Map<String, dynamic> data = jsonDecode(content);
  final List<dynamic> banks = data['banks'];

  // Remove IndusInd if it exists
  banks.removeWhere((b) => b['bankName'] == 'IndusInd Bank');

  // Add IndusInd Bank
  banks.add({
    "bankName": "IndusInd Bank",
    "senderIdentifiers": ["INDUSB", "INDUSI", "INDSIN", "INDSB", "INDBNK", "INDUS"],
    "templates": [
      {
        "name": "IndusInd Spent Card",
        "pattern": "(?:INR|Rs\\.?|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+spent\\s+on\\s+indusind\\s+Card\\s+([\\dX*]+)[\\s\\S]*?at\\s+([^.]+?)\\s*\\.",
        "type": "debit",
        "amountGroup": 1,
        "accountGroup": 2,
        "merchantGroup": 3,
        "method": "card",
        "priority": 1
      },
      {
        "name": "IndusInd Account Debited",
        "pattern": "(?:A/C|account|A/c)\\s+([\\dX*]+)\\s+debited\\s+with\\s+(?:Rs\\.?|INR|₹)\\s*([0-9,]+(?:\\.\\d+)?)[\\s\\S]*?and\\s+account\\s+([^\\s]+)\\s+will\\s+be\\s+credited",
        "type": "debit",
        "amountGroup": 2,
        "accountGroup": 1,
        "merchantGroup": 3,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "IndusInd Account Credited",
        "pattern": "(?:A/C|account|A/c)\\s+([\\dX*]+|\\*\\*\\d+)\\s+credited\\s+by\\s+(?:Rs\\.?|INR|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+from\\s+([^\\s]+)",
        "type": "credit",
        "amountGroup": 2,
        "accountGroup": 1,
        "merchantGroup": 3,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "IndusInd Charge Debit",
        "pattern": "Indusind\\s+(?:A/C|account|A/c)\\s+([\\dX*]+)\\s+Debited;\\s+(?:INR|Rs\\.?|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+Ref-To\\s+([^.]+)",
        "type": "debit",
        "amountGroup": 2,
        "accountGroup": 1,
        "merchantGroup": 3,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "IndusInd Universal Safety Net",
        "pattern": "(?:debited|credited|spent|withdrawn|received|paid)[\\s\\S]*?(?:Rs\\.?|INR|₹|USD)\\s*([0-9,]+(?:\\.\\d{1,2})?)[\\s\\S]*?(?:A/c|account|Card|A/C)?\\s*([\\dX*]+)?",
        "type": "unknown",
        "amountGroup": 1,
        "accountGroup": 2,
        "method": "unknown",
        "priority": 50
      }
    ]
  });

  // Use JsonEncoder with indent for formatting
  final encoder = JsonEncoder.withIndent('    ');
  file.writeAsStringSync(encoder.convert(data));

  print("Updated bank_configs.json with IndusInd Bank successfully!");
}
