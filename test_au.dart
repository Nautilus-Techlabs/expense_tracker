import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/domain/sms_service.dart';
import 'package:expense_tracker/core/models/sms_message.dart';

void main() async {
  final service = SmsService();
  await service.initialize();
  
  final List<SmsMessage> samples = SmsSampleData.getSampleSms();
  final auSamples = samples.where((s) => s.sender.toUpperCase().contains('AU')).toList();
  
  print('Found \${auSamples.length} AU samples');
  for (var s in auSamples) {
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
