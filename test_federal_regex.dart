import 'dart:convert';
import 'dart:io';

void main() {
  final List<String> federalSms = [
    "Dear Customer, Rs.100 credited to your A/c XX2814 on 11SEP2024 15:22:29. BAL-Rs.480.91-Federal Bank",
    "Dear Customer, Rs.443 debited from your A/c XX2814 towards non-maintenance of Average Monthly Balance in your account on 11SEP2024 15:34:11. BAL-Rs.37.91-Federal Bank",
    "Hi, payment of INR 1750.00 for Google Play via e-mandate ID: XzOaZEsoKJ on Federal Bank Debit Card 2014 is processed successfully. To manage, visit: https://www.sihub.in /managesi/federal T&CA - Federal Bank",
    "INR 100.00 sent from your Account XXXXXXXX5721 Mode: UPI  To: paytmqr281005050101pl59klibw 7ux@paytm Date: September 21, 2022 Not done by you? Call 080-47485490-Federal Bank",
    "INR 90.00 sent from your account XXXXXXXX5721 Sent to your beneficiary on September 21, 2022. If this transaction wasn't done by you, call 080-47485490-Federal Bank",
    "Rs.1 debited by ECOM Txn using your card XX0787 at WWW OLACABS COM on 14JUN2019 15:56:42.BAL-Rs. 1877.12.Call 18004251199, if not done by you-Federal Bank"
  ];

  final file = File('e:/P-Code/expense_tracker/assets/bank_configs.json');
  final content = file.readAsStringSync();
  final data = jsonDecode(content);

  for (var bank in data['banks']) {
    if (bank['bankName'] == 'Federal Bank') {
      print("\\n=== Federal Bank Regex Test ===");
      int count = 0;
      for (var sms in federalSms) {
        bool matched = false;
        for (var template in bank['templates']) {
          final regExp = RegExp(template['pattern'], caseSensitive: false);
          final match = regExp.firstMatch(sms);
          if (match != null) {
            print("MATCH: '\${template['name']}' on SMS: \$sms");
            matched = true;
            count++;
            break;
          }
        }
        if (!matched) {
          print("FAIL: \$sms");
        }
      }
      print("Total Matched: \$count / \${federalSms.length}");
    }
  }
}
