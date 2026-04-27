
import 'dart:convert';
import 'dart:io';

void main() {
  final configFile = File('assets/bank_configs.json');
  final jsonStr = configFile.readAsStringSync();
  final Map<String, dynamic> root = jsonDecode(jsonStr);
  final List<dynamic> banks = root['banks'];

  // Test IDFC SMS
  final testMessages = [
    // Problematic cases (Amount First)
    {
      'sms': 'INR 1,800.00 debited from IDFC FIRST Bank A/c XX1234 on 01-Apr-25. UPI/GooglePay. Avl Bal INR 14,650.00.',
      'expectedAmount': '1,800.00',
      'expectedType': 'debit'
    },
    {
      'sms': 'INR 7,000.00 credited to IDFC FIRST Bank A/c XX1234 on 02-Apr-25. IMPS Ref 512345678901. Avl Bal INR 21,650.00.',
      'expectedAmount': '7,000.00',
      'expectedType': 'credit'
    },
    // Existing supported cases (Keyword First)
    {
      'sms': 'Your IDFC FIRST Bank A/c XX1234 has been debited by INR 500.00 on 01-Apr-25. Info: ATM. Avl Bal: INR 10,000.00',
      'expectedAmount': '500.00',
      'expectedType': 'debit'
    },
    {
      'sms': 'interest of Rs. 45.50 credited to IDFC FIRST Bank A/c XX1234',
      'expectedAmount': '45.50',
      'expectedType': 'credit'
    }
  ];

  final idfcBank = banks.firstWhere(
    (b) => b['bankName'] == 'IDFC First Bank',
    orElse: () => null,
  );

  if (idfcBank == null) {
    print('❌ IDFC First Bank config NOT FOUND');
    return;
  }

  print('--- Testing against IDFC First Bank Templates ---\n');
  
  int passed = 0;
  for (final test in testMessages) {
    final sms = test['sms'] as String;
    final expectedAmount = test['expectedAmount'];
    final expectedType = test['expectedType'];

    print('📨 SMS: $sms');
    bool matched = false;
    
    // Sort templates by priority
    final templates = List<dynamic>.from(idfcBank['templates']);
    templates.sort((a, b) => (a['priority'] as int).compareTo(b['priority'] as int));

    for (final tmpl in templates) {
      final name = tmpl['name'];
      final patternStr = tmpl['pattern'];
      final type = tmpl['type'];
      final priority = tmpl['priority'];

      try {
        final regex = RegExp(patternStr, caseSensitive: false);
        final match = regex.firstMatch(sms);

        if (match != null && tmpl.containsKey('amountGroup')) {
          final amount = match.group(tmpl['amountGroup']);
          
          print('✅ [P$priority] "$name" MATCHED as $type');
          print('   💰 AMOUNT: $amount');
          
          if (amount == expectedAmount && type == expectedType) {
            print('   ✨ SUCCESS: Matched expected amount and type');
            passed++;
          } else {
            print('   ⚠️ MISMATCH: Expected $expectedAmount ($expectedType), got $amount ($type)');
          }
          print('');
          matched = true;
          break; 
        }
      } catch (e) {
        print('⚠️ Error in template "$name": $e');
      }
    }
    
    if (!matched) {
      print('❌ NO MATCH FOUND for this SMS\n');
    }
  }

  print('Summary: $passed/${testMessages.length} tests passed.');
}
