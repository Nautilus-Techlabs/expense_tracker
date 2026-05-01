void main() {
  final parser = HDFCBankParser();
  const hdfcSms =
      'Alert: Your HDFC Bank Card ending 1234 has been debited for Rs. 5000.00 at AMAZON on 05-02-26. Avl Bal: Rs. 15000.00.';

  print('--- HDFC Parser Debug ---');
  print('SMS: $hdfcSms');
  print('isTransactionMessage: ${parser.isTransactionMessage(hdfcSms)}');
  print('Amount: ${parser.extractAmount(hdfcSms)}');
  print('Type: ${parser.extractTransactionType(hdfcSms)}');
  print('Account: ${parser.extractAccountLast4(hdfcSms)}');
  print('Merchant: ${parser.extractMerchant(hdfcSms, "")}');
  print('Method: ${parser.extractMethod(hdfcSms)}');
  print('-------------------------');
}
