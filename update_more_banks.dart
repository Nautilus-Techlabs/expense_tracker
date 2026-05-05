import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('e:/P-Code/expense_tracker/assets/bank_configs.json');
  final content = file.readAsStringSync();
  final Map<String, dynamic> data = jsonDecode(content);
  final List<dynamic> banks = data['banks'];

  // Remove IDFC and IndusInd if they exist
  banks.removeWhere((b) => b['bankName'] == 'IDFC FIRST Bank' || b['bankName'] == 'IndusInd Bank');

  // Add IDFC FIRST Bank
  banks.add({
    "bankName": "IDFC FIRST Bank",
    "senderIdentifiers": ["IDFCFB", "IDFCBK", "IDFC", "FIRST", "IDFCPG", "IDFCBN", "IDFCFT"],
    "templates": [
      {
        "name": "IDFC Spent Card",
        "pattern": "(?:INR|Rs\\.?|USD|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+spent\\s+on\\s+(?:your\\s+)?IDFC\\s+FIRST\\s+Bank\\s+Card\\s+(?:ending\\s+)?([\\dX*]+)(?:\\s+at\\s+([^\\s]+))?",
        "type": "debit",
        "amountGroup": 1,
        "accountGroup": 2,
        "merchantGroup": 3,
        "method": "card",
        "priority": 1
      },
      {
        "name": "IDFC Debited For",
        "pattern": "(?:A/c|account)\\s+(?:ending\\s+)?([\\dX*]+)\\s+debited\\s+for\\s+(?:Rs\\.?|INR|₹)\\s*([0-9,]+(?:\\.\\d+)?)(?:\\s+via\\s+([^.]+?))?(?:\\.|Bal|$)",
        "type": "debit",
        "amountGroup": 2,
        "accountGroup": 1,
        "merchantGroup": 3,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "IDFC Credit Received",
        "pattern": "(?:Credit\\s+Alert:|credited\\s+with)\\s*(?:INR|Rs\\.?|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+(?:received\\s+in|in)\\s+A/c\\s+([\\dX*]+)(?:\\s+from\\s+([^.]+))?",
        "type": "credit",
        "amountGroup": 1,
        "accountGroup": 2,
        "merchantGroup": 3,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "IDFC Cash Withdrawal",
        "pattern": "Cash\\s+Wdl\\s+of\\s+(?:Rs\\.?|INR|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+from\\s+IDFC\\s+Bank\\s+A/c\\s+([\\dX*]+)\\s+at\\s+([^.]+)",
        "type": "debit",
        "amountGroup": 1,
        "accountGroup": 2,
        "merchantGroup": 3,
        "method": "atm",
        "priority": 1
      },
      {
        "name": "IDFC Generic Credit",
        "pattern": "(?:IDFC\\s+Bank\\s+)?A/c\\s+(?:ending\\s+)?([\\dX*]+)\\s+is\\s+credited\\s+with\\s+(?:Rs\\.?|INR|₹)\\s*([0-9,]+(?:\\.\\d+)?)(?:\\s+from\\s+([^.]+))?",
        "type": "credit",
        "amountGroup": 2,
        "accountGroup": 1,
        "merchantGroup": 3,
        "method": "bank",
        "priority": 2
      },
      {
        "name": "IDFC FASTag Debit",
        "pattern": "(?:INR|Rs\\.?|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+toll\\s+paid\\s+from\\s+IDFC\\s+FIRST\\s+Bank\\s+Tag\\s+([\\dX*]+)",
        "type": "debit",
        "amountGroup": 1,
        "accountGroup": 2,
        "method": "fastag",
        "priority": 1
      },
      {
        "name": "IDFC FASTag Credit",
        "pattern": "FASTag\\s+([\\dX*]+)\\s+Credited\\s+with\\s+(?:Rs\\.?|INR|₹)\\s*([0-9,]+(?:\\.\\d+)?).",
        "type": "credit",
        "amountGroup": 2,
        "accountGroup": 1,
        "method": "fastag",
        "priority": 1
      },
      {
        "name": "IDFC Universal Safety Net",
        "pattern": "(?:debited|credited|spent|withdrawn|received|paid)[\\s\\S]*?(?:Rs\\.?|INR|₹|USD)\\s*([0-9,]+(?:\\.\\d{1,2})?)[\\s\\S]*?(?:A/c|account|Card|Tag)?\\s*([\\dX*]+)?",
        "type": "unknown",
        "amountGroup": 1,
        "accountGroup": 2,
        "method": "unknown",
        "priority": 50
      }
    ]
  });

  // Add IndusInd Bank
  banks.add({
    "bankName": "IndusInd Bank",
    "senderIdentifiers": ["INDUSB", "INDUSI", "INDSIN", "INDSB", "INDBNK"],
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
        "pattern": "(?:A/C|account)\\s+([\\dX*]+)\\s+debited\\s+with\\s+(?:Rs\\.?|INR|₹)\\s*([0-9,]+(?:\\.\\d+)?)[\\s\\S]*?and\\s+account\\s+([^\\s]+)\\s+will\\s+be\\s+credited",
        "type": "debit",
        "amountGroup": 2,
        "accountGroup": 1,
        "merchantGroup": 3,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "IndusInd Account Credited",
        "pattern": "(?:A/C|account)\\s+([\\dX*]+)\\s+credited\\s+by\\s+(?:Rs\\.?|INR|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+from\\s+([^\\s]+)",
        "type": "credit",
        "amountGroup": 2,
        "accountGroup": 1,
        "merchantGroup": 3,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "IndusInd Charge Debit",
        "pattern": "Indusind\\s+(?:A/C|account)\\s+([\\dX*]+)\\s+Debited;\\s+(?:INR|Rs\\.?|₹)\\s*([0-9,]+(?:\\.\\d+)?)\\s+Ref-To\\s+([^.]+)",
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

  print("Updated bank_configs.json with IDFC and IndusInd successfully!");
}
