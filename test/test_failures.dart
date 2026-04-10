import 'package:expense_tracker/logic/parsers/combined_parser.dart';
import 'package:expense_tracker/data/sample_data.dart';
import 'dart:io';

void main() {
  final file = File('test/failures.txt');
  final sink = file.openWrite();
  sink.writeln('--- UNPARSED SAMPLES ---');

  for (var sample in sampleSms) {
    if (sample.sender == 'SPAM') continue;
    if (sample.body.toLowerCase().contains('otp') ||
        sample.body.toLowerCase().contains('code'))
      continue;

    final parser = BankParserFactory.getParser(sample.sender);
    final resH = parser.parse(sample.body);

    if (resH == null) {
      sink.writeln('SENDER: ${sample.sender}');
      sink.writeln('BODY: ${sample.body}');
      sink.writeln('---------------------------');
    } else if (resH.merchant == null) {
      sink.writeln('NO MERCHANT SENDER: ${sample.sender}');
      sink.writeln('BODY: ${sample.body}');
      sink.writeln('---------------------------');
    }
  }
  sink.close();
}
