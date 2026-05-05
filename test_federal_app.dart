import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/domain/sms_service.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/core/utils/date_extractor.dart';

void main() async {
  final service = SmsService();
  
  // We need to initialize the parser with bank definitions
  // But wait, SmsService creates SmsParserEngine, which relies on BankParserFactory being initialized.
  // We can just run a quick dummy sync to trigger it if it's not initialized, or test directly.
  
  final samples = sampleSms.where((s) {
    final sender = s.sender.toUpperCase();
    return sender.contains('FED');
  }).toList();
  
  print('Found \${samples.length} Federal samples');
  int parsedCount = 0;
  for (var s in samples) {
    print('--------------------------');
    print('SENDER: \${s.sender}');
    print('BODY: \${s.body}');
    
    // Test date
    final extractedDate = DateExtractor.extract(s.body);
    print('DATE EXTRACTED: \$extractedDate');
    
    // We can't easily call parseSmsToTransaction if it's private, wait SmsService has syncTransactions.
    // Let's use the SmsParserEngine directly if possible, or we can just run the test file.
  }
}
