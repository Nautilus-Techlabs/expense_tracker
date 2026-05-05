void main() {
  // Simulating JSON decoding
  final jsonPattern = r'(?:Rs\.?|INR)\s*([0-9,]+(?:\.\d{2})?)\s+credited\s+to\s+(?:your\s+)?A/c\s+([\dX*]+)[\s\S]*?(?:[Bb]al(?:ance)?|BAL)[^0-9]*?([0-9,]+(?:\.\d{2})?)';
  
  try {
    final pattern = RegExp(jsonPattern, caseSensitive: false);
    print('Pattern compiled successfully');
    final sms = 'Rs.100.00 credited to your A/c XXXXXX4387 by UPI with Ref No 425501861730 on 11-09-2024. Total Avl Bal: Rs.480.91.';
    final match = pattern.firstMatch(sms);
    if (match != null) {
      print('Match found! Balance: ${match.group(3)}');
    } else {
      print('No match found');
    }
  } catch (e) {
    print('Compilation error: $e');
  }
}
