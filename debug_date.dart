import 'package:expense_tracker/core/utils/date_extractor.dart';

void main() {
  final sms = 'INR 185 toll paid from IDFC FIRST Bank Tag 3XXX5B00 for vehicle no. UP14FJ8020 at Gharonda Toll Plaza on 20/02/25 15:56. Avbl. Bal.: INR229.11:53 AM';
  final date = DateExtractor.extract(sms);
  print('Extracted date: $date');
}
