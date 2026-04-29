import 'dart:io';
import 'package:expense_tracker/core/utils/date_extractor.dart';

void main() {
  final text = "Dear BOB upi user : Ypur account is credited with 200 on 2025-06-08 09:21:13 pm by upi ref no 4342423424432 avlbal: 20000 -BOB";
  final date = DateExtractor.extract(text);
  File('test_output.txt').writeAsStringSync('Extracted date: $date');
}
