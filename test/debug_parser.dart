import 'package:expense_tracker/logic/sms_parser.dart';
import 'package:expense_tracker/data/sample_data.dart';

void main() {
  final parser = TransactionParser();
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

  for (var sms in goodSamples) {
    final tx = parser.parse(sms, fallbackDate: DateTime.now());
    if (tx == null) {
      print('FAILED: $sms');
    } else {
      print('Parsed: [${tx.method.name.toUpperCase()}] "${tx.merchant ?? "Unknown"}" from: $sms');
    }
  }
}
