import 'package:expense_tracker/core/utils/date_extractor.dart';

void main() {
  final text = "your account is credited with 100 rs on 2025-06-08";
  final date = DateExtractor.extract(text);
  print('Extracted date: $date');
}
