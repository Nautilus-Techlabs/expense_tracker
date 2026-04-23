import 'dart:convert';
import 'dart:io';

void main() {
  try {
    jsonDecode(File('assets/bank_configs.json').readAsStringSync());
    print('Valid JSON');
  } on FormatException catch (e) {
    print('Error at offset ${e.offset}: ${e.message}');
  } catch (e) {
    print('Error: $e');
  }
}
