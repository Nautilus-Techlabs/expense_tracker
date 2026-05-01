import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/domain/entities/bank_definition.dart';
import 'package:expense_tracker/domain/parsers/combined_parser.dart';
import 'package:expense_tracker/domain/sms_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    BankParserFactory.initializeFromDefinitions(BankDefinitions.all);
  });

  final engine = SmsParserEngine();

  test('Super Parser Accuracy Report', () {
    final goodSamples = sampleSms.where((s) {
      final l = s.body.toLowerCase();
      final isExcluded =
          l.contains('otp') ||
          l.contains('verification code') ||
          l.contains('password') ||
          l.contains('failed') ||
          l.contains('declined') ||
          l.contains('insufficient fund') ||
          l.contains('rejected') ||
          l.contains('limit reached') ||
          l.contains('cancelled') ||
          l.contains('offer!') ||
          l.contains('win') ||
          l.contains('play') ||
          l.contains('promotional') ||
          (l.contains('balance in') &&
              !l.contains('debited') &&
              !l.contains('credited'));
      return !isExcluded;
    }).toList();

    final negativeSamples = sampleSms
        .where((s) => !goodSamples.contains(s))
        .toList();

    int totalGood = goodSamples.length;
    int parsedGood = 0;
    int totalNegative = negativeSamples.length;
    int ignoredNegative = 0;

    print('\n--- Super Parser Accuracy Report ---\n');

    // Test Good Samples
    for (var sample in goodSamples) {
      final tx = engine.tryParse(
        sample.body,
        sender: sample.sender,
        fallbackDate: DateTime.now(),
      );
      if (tx != null) {
        parsedGood++;
      } else {
        print(
          '🚨 WRONGLY IGNORED (False Negative): [${sample.sender}] ${sample.body}',
        );
      }
    }

    // Test Negative Samples
    for (var sample in negativeSamples) {
      final tx = engine.tryParse(
        sample.body,
        sender: sample.sender,
        fallbackDate: DateTime.now(),
      );
      if (tx == null) {
        ignoredNegative++;
      } else {
        print(
          '🚨 WRONGLY PARSED (False Positive): [${sample.sender}] ${sample.body}',
        );
      }
    }

    double accuracy = (parsedGood / totalGood) * 100;
    double rejectionRate = totalNegative > 0
        ? (ignoredNegative / totalNegative) * 100
        : 100.0;

    print('\nResults:');
    print(
      '✅ Transaction Detection: $parsedGood / $totalGood (${accuracy.toStringAsFixed(1)}%)',
    );
    print(
      '🛡️ Spam/Failure Filtering: $ignoredNegative / $totalNegative (${rejectionRate.toStringAsFixed(1)}%)',
    );
    print('-----------------------------\n');

    expect(
      accuracy,
      greaterThanOrEqualTo(70.0),
      reason: 'At least 70% of valid transactions should be parsed',
    );
    expect(
      rejectionRate,
      100.0,
      reason: 'All OTPs/Spam/Failures should be ignored',
    );
  });
}
