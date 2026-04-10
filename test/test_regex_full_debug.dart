import 'dart:convert';
import 'dart:io';

void main() {
  final sms = 'INR 2,000.00 debited from Axis Bank A/c ending 1234 on 01-Apr-25. UPI Ref: 123456789012. Avl Bal INR 18,400.00.';
  
  // Full Regex
  final pattern = r"(?:Debit\s+)?(?:INR|Rs\.?)\s*([0-9,]+(?:\.\d+)?)\s+debited\s+from\s+.*?A/c\s+(?:no\.\s+)?(?:ending\s+)?([\dX*]+).*?(?:UPI/|UPI Ref:|for\s+)([^\s\.;]+)";
  final regex = RegExp(pattern, caseSensitive: false);
  
  final match = regex.firstMatch(sms);
  if (match == null) {
    print('Full Regex failed!');
    // Try to find why by relaxing the last part
    final relaxed = RegExp(r"(?:INR|Rs\.?)\s*([0-9,]+(?:\.\d+)?)\s+debited\s+from\s+.*?A/c\s+(?:no\.\s+)?(?:ending\s+)?([\dX*]+).*?UPI Ref:", caseSensitive: false);
    print('Relaxed match: ${relaxed.hasMatch(sms)}');
  } else {
    print('Match found!');
    for (var i = 0; i <= match.groupCount; i++) {
      print('Group $i: ${match.group(i)}');
    }
  }
}
