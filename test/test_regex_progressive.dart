void main() {
  final sms =
      'INR 2,000.00 debited from Axis Bank A/c ending 1234 on 01-Apr-25. UPI Ref: 123456789012. Avl Bal INR 18,400.00.';

  // Part 1: Initial match
  final p1 = RegExp(
    r"(?:INR|Rs\.?)\s*([0-9,]+(?:\.\d+)?)\s+debited\s+from\s+",
    caseSensitive: false,
  );
  print('Part 1 match: ${p1.hasMatch(sms)}');

  // Part 2: Up to Account
  final p2 = RegExp(
    r"(?:INR|Rs\.?)\s*([0-9,]+(?:\.\d+)?)\s+debited\s+from\s+.*?A/c\s+(?:no\.\s+)?(?:ending\s+)?([\dX*]+)",
    caseSensitive: false,
  );
  print('Part 2 match: ${p2.hasMatch(sms)}');
  if (p2.hasMatch(sms)) {
    final m = p2.firstMatch(sms)!;
    print('G1: ${m.group(1)}');
    print('G2: ${m.group(2)}');
  }

  // Part 3: Full
  final p3 = RegExp(
    r"(?:INR|Rs\.?)\s*([0-9,]+(?:\.\d+)?)\s+debited\s+from\s+.*?A/c\s+(?:no\.\s+)?(?:ending\s+)?([\dX*]+).*?UPI Ref:",
    caseSensitive: false,
  );
  print('Part 3 match: ${p3.hasMatch(sms)}');
}
