import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/domain/sms_service.dart';
import 'package:expense_tracker/core/models/sms_message.dart';

void main() async {
  final service = SmsService();
  await service.initialize();
  
  final List<SmsMessage> samples = SmsSampleData.getSampleSms();
  final targetSamples = samples.where((s) {
    final sender = s.sender.toUpperCase();
    return sender.contains('AU') || sender.contains('FDRL') || sender.contains('FEDERAL');
  }).toList();
  
  print('Found \${targetSamples.length} samples for AU / Federal');
  for (var s in targetSamples) {
    print('-----------------------------------------');
    print('SENDER: \${s.sender}');
    print('BODY: \${s.body}');
    final tx = service.parseSmsToTransaction(s);
    if (tx != null) {
      print('PARSED: \${tx.type} | Amount: \${tx.amount} | Merchant: \${tx.merchant} | Bank: \${tx.bankName}');
    } else {
      print('PARSED: NULL');
    }
  }
}
