import 'package:expense_tracker/core/utils/balance_extractor.dart';

void main() {
  final sms = 'Rs.100.00 credited to your A/c XXXXXX4387 by UPI with Ref No 425501861730 on 11-09-2024. Total Avl Bal: Rs.480.91.';
  final balance = BalanceExtractor.extract(sms);
  print('Extracted balance: $balance');
}
