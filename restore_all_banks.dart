import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('e:/P-Code/expense_tracker/assets/bank_configs.json');
  final content = file.readAsStringSync();
  final Map<String, dynamic> data = jsonDecode(content);
  final List<dynamic> banks = data['banks'];

  // Clean up
  banks.removeWhere((b) => [
    'Federal Bank', 'AU Small Finance Bank', 'IDFC FIRST Bank', 'IndusInd Bank'
  ].contains(b['bankName']));

  // AU Small Finance Bank
  banks.add({
    "bankName": "AU Small Finance Bank",
    "senderIdentifiers": ["AUBNK", "AUBANK", "AUSBK"],
    "templates": [
      {
        "name": "AU Credit",
        "pattern": r"(?:Payment\s+of\s+)?(?:INR|Rs\.?|INF)\s*([0-9,]+(?:\.\d{2})?)\s+(?:was\s+)?credited",
        "type": "credit",
        "amountGroup": 1,
        "method": "card",
        "priority": 1
      },
      {
        "name": "AU Debit",
        "pattern": r"(?:Debited|debited)\s+(?:with|for|INF|INR|Rs\.?)\s*(?:INR|Rs\.?|INF)?\s*([0-9,]+(?:\.\d{2})?)",
        "type": "debit",
        "amountGroup": 1,
        "method": "bank",
        "priority": 1
      }
    ]
  });

  // Federal Bank
  banks.add({
    "bankName": "Federal Bank",
    "senderIdentifiers": ["FDRL", "FEDERAL", "FDRLBK", "FDLBNK", "FEDBNK", "FEDFI"],
    "templates": [
      {
        "name": "Federal Credit",
        "pattern": r"(?:Rs\.?|INR)\s*([0-9,]+(?:\.\d{2})?)\s+credited",
        "type": "credit",
        "amountGroup": 1,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "Federal Debit",
        "pattern": r"(?:Rs\.?|INR)\s*([0-9,]+(?:\.\d{2})?)\s+(?:debited|sent)",
        "type": "debit",
        "amountGroup": 1,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "Federal Universal",
        "pattern": r"(?:debited|credited|sent|payment)[\s\S]*?(?:Rs\.?|INR)\s*([0-9,]+(?:\.\d{1,2})?)",
        "type": "unknown",
        "amountGroup": 1,
        "priority": 50
      }
    ]
  });

  // IDFC FIRST Bank
  banks.add({
    "bankName": "IDFC FIRST Bank",
    "senderIdentifiers": ["IDFCFB", "IDFCBK", "IDFC", "FIRST", "IDFCPG", "IDFCBN", "IDFCFT"],
    "templates": [
      {
        "name": "IDFC Debit",
        "pattern": r"(?:INR|Rs\.?|USD|₹)\s*([0-9,]+(?:\.\d+)?)\s+(?:spent|debited|paid|toll)",
        "type": "debit",
        "amountGroup": 1,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "IDFC Credit",
        "pattern": r"(?:Credit|credited).*?(?:INR|Rs\.?|₹)\s*([0-9,]+(?:\.\d+)?)",
        "type": "credit",
        "amountGroup": 1,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "IDFC Universal",
        "pattern": r"(?:debited|credited|spent|withdrawn|received|paid)[\s\S]*?(?:Rs\.?|INR|₹|USD)\s*([0-9,]+(?:\.\d{1,2})?)",
        "type": "unknown",
        "amountGroup": 1,
        "priority": 50
      }
    ]
  });

  // IndusInd Bank
  banks.add({
    "bankName": "IndusInd Bank",
    "senderIdentifiers": ["INDUSB", "INDUSI", "INDSIN", "INDSB", "INDBNK", "INDUS"],
    "templates": [
      {
        "name": "IndusInd Debit",
        "pattern": r"(?:INR|Rs\.?|₹)\s*([0-9,]+(?:\.\d+)?)\s+(?:spent|debited|paid)",
        "type": "debit",
        "amountGroup": 1,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "IndusInd Credit",
        "pattern": r"credited\s+by\s+(?:Rs\.?|INR|₹)\s*([0-9,]+(?:\.\d+)?)",
        "type": "credit",
        "amountGroup": 1,
        "method": "bank",
        "priority": 1
      },
      {
        "name": "IndusInd Universal",
        "pattern": r"(?:debited|credited|spent|withdrawn|received|paid)[\s\S]*?(?:Rs\.?|INR|₹|USD)\s*([0-9,]+(?:\.\d{1,2})?)",
        "type": "unknown",
        "amountGroup": 1,
        "priority": 50
      }
    ]
  });

  final encoder = JsonEncoder.withIndent('    ');
  file.writeAsStringSync(encoder.convert(data));

  print("All bank configs simplified and restored successfully!");
}
