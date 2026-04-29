import 'dart:io';
import 'package:expense_tracker/core/utils/date_extractor.dart';

void main() {
  final List<String> samples = [
    "Dear BOB upi user : Ypur account is credited with 200 on 2025-06-08 09:21:13 pm by upi ref no 4342423424432 avlbal: 20000 -BOB",
    "Rs.67 Dr. from a/c xxxxxxx0980 to dmpminoas@okhdfc. Ref:0987654433. AvlBal:Rs878979(2026:03:04 09:09:20)",
    "Rs.3.23 created to a/c .....09876 from:RCR/098874987439. TotalBal:3241(08-03-2022)",
  ];

  final buffer = StringBuffer();
  for (var s in samples) {
    final date = DateExtractor.extract(s);
    buffer.writeln('Input: $s');
    buffer.writeln('Extracted: $date');
    buffer.writeln('---');
  }
  
  File('test_output_multi.txt').writeAsStringSync(buffer.toString());
}
