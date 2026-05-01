void main() {
  // Updated fallback pattern (same as app_constants.dart)
  final fallbackPattern = RegExp(
    r'(?:A/c\s*(?:no\.?)?\s*|Acct?\s*(?:No\.?)?\s*|Savings\s*No\s*|ending\s*|[\*X]{2,})[\s\.]*([X\*]*\d{4})',
    caseSensitive: false,
  );

  // CUB test SMS messages
  final testCases = [
    'Your a/c no. X1234 debited for Rs. 1,000.00. Avl Bal 45,000.00. (UPI Ref no 123456789).',
    'Savings No X4321 credited with INR 2,500.00 BY NEFT TRF:REMITTER NAME.',
    'Your a/c no. XX5678 debited for Rs. 500.00. Avl Bal 10,000.00.',
    'A/c XX9999 debited Rs.2000. Bal Rs.5000.', // Standard format (should still work)
    'Acct No. 7890 credited Rs.1000.', // Acct No. format
    'Account ending 3456 credited Rs.5000.', // ending format
  ];

  print('=== CUB Account Fallback Pattern Test ===\n');

  int passed = 0;
  for (final sms in testCases) {
    final match = fallbackPattern.firstMatch(sms);
    if (match != null) {
      final raw = match.group(1)!;
      // Simulate cleanup from hierarchical_engine.dart
      var account = raw.replaceAll(RegExp(r'[^0-9]'), '');
      if (account.length > 4) {
        account = account.substring(account.length - 4);
      }
      account = 'XX$account';
      print('✅ "$sms"');
      print(
        '   Raw: "${match.group(0)}" → Group 1: "$raw" → Display: $account\n',
      );
      passed++;
    } else {
      print('❌ "$sms"');
      print('   FAILED to extract account\n');
    }
  }

  print('---');
  print('Result: $passed/${testCases.length} passed');
}
