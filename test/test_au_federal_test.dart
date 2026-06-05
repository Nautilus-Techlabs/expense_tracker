import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/domain/sms_service.dart';

void main() {
  test('AU and Federal Bank test', () async {
    final service = SmsService();
    await service.initialize();

    final samples = SmsSampleData.getSampleSms();
    final targetSamples = samples.where((s) {
      final sender = s.sender.toUpperCase();
      return sender.contains('AU') || sender.contains('FDRL') || sender.contains('FEDERAL');
    }).toList();

    print('Found \${targetSamples.length} samples for AU / Federal');
    int matched = 0;
    for (var s in targetSamples) {
      print('-----------------------------------------');
      print('SENDER: \${s.sender}');
      print('BODY: \${s.body}');
      final tx = service.parseSmsToTransaction(s);
      matched++;
      print('PARSED: \${tx.type} | Amount: \${tx.amount} | Merchant: \${tx.merchant} | Bank: \${tx.bankName}');
    }
    print('\\nMatched \$matched out of \${targetSamples.length} AU/Federal samples');
  });
}
