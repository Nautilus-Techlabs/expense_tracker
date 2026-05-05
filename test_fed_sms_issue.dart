
void main() {
  final sms = "INR 100.00 sent from your Account XXXXXXXX5721 Mode: UPI ö To: paytmqr281005050101pl59klibw 7ux@paytm Date: September 21, 2022 Not done by you? Call 080-47485490-Federal Bank";
  
  final regex1 = RegExp(
    r'(?:INR|Rs\.?)\s*([0-9,]+(?:\.\d{2})?)\s+sent\s+from\s+your\s+(?:Account|account)\s+([\dX*]+)[\s\S]*?To:\s*([^\s]+)',
    caseSensitive: false,
  );
  
  print('Regex match: ');
  print(regex1.hasMatch(sms));

  // Test Date
  final dateRegex = RegExp(
    r'\b(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|January|February|March|April|June|July|August|September|October|November|December)\s+(\d{1,2}),\s+(\d{4})\b',
    caseSensitive: false,
  );
  print('Date regex match: ');
  print(dateRegex.hasMatch(sms));
}
