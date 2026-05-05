import 'dart:io';

void main() {
  final sms = "Rs.1 debited by ECOM Txn using your card XX0787 at WWW OLACABS COM on 14JUN2019 15:56:42.BAL-Rs. 1877.12.Call 18004251199, if not done by you-Federal Bank";
  
  final regex1 = RegExp(r'(?:Rs\.?|INR)\s*([0-9,]+(?:\.\d+)?)\s+debited\s+by\s+ECOM\s+Txn\s+using\s+your\s+card\s+([\dX*]+)\s+at\s+(.*?)\s+on', caseSensitive: false);
  final regex2 = RegExp(r'(?:debited|credited|sent|payment).*?(?:Rs\.?|INR)\s*([0-9,]+(?:\.\d{1,2})?).*?(?:A/c|account|Card)?\s*([\dX*]+)?', caseSensitive: false);
  
  print('Regex1 (ECOM) matches: \${regex1.hasMatch(sms)}');
  print('Regex2 (Fallback) matches: \${regex2.hasMatch(sms)}');
}
