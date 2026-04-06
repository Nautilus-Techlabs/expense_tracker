import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/logic/sms_parser.dart';
import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/models/transaction.dart';

void main() {
  final engine = SmsParserEngine();

  test('Super Parser Accuracy Report', () {
    final goodSamples = sampleSms.where((s) {
      final l = s.toLowerCase();
      final isExcluded = l.contains('otp') || 
                         l.contains('verification code') || 
                         l.contains('password') ||
                         l.contains('failed') || 
                         l.contains('declined') || 
                         l.contains('insufficient fund') ||
                         l.contains('rejected') || 
                         l.contains('limit reached') ||
                         l.contains('cancelled') ||
                         l.contains('offer!') ||
                         (l.contains('balance in') && !l.contains('debited') && !l.contains('credited'));
      return !isExcluded;
    }).toList();
    
    final negativeSamples = sampleSms.where((s) => !goodSamples.contains(s)).toList();

    int totalGood = goodSamples.length;
    int parsedGood = 0;
    int totalNegative = negativeSamples.length;
    int ignoredNegative = 0;

    print('\n--- Super Parser Accuracy Report ---\n');
    
    // Test Good Samples
    for (var sms in goodSamples) {
      final tx = engine.tryParse(sms, fallbackDate: DateTime.now());
      if (tx != null) {
        parsedGood++;
      } else {
        print('🚨 WRONGLY IGNORED (False Negative): $sms');
      }
    }

    // Test Negative Samples
    for (var sms in negativeSamples) {
      final tx = engine.tryParse(sms, fallbackDate: DateTime.now());
      if (tx == null) ignoredNegative++;
      else print('🚨 WRONGLY PARSED (False Positive): $sms');
    }

    double accuracy = (parsedGood / totalGood) * 100;
    double rejectionRate = (ignoredNegative / totalNegative) * 100;

    print('\nResults:');
    print('✅ Transaction Detection: $parsedGood / $totalGood (${accuracy.toStringAsFixed(1)}%)');
    print('🛡️ Spam/Failure Filtering: $ignoredNegative / $totalNegative (${rejectionRate.toStringAsFixed(1)}%)');
    print('-----------------------------\n');

    expect(accuracy, 100.0, reason: 'All valid transactions should be parsed');
    expect(rejectionRate, 100.0, reason: 'All OTPs/Spam/Failures should be ignored');
  });
}
