import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/domain/sms_parser.dart';
import 'package:expense_tracker/domain/parsers/combined_parser.dart';
import 'package:expense_tracker/domain/parsers/entities/bank_definition.dart';
import 'package:expense_tracker/data/sample_data.dart';
import 'package:expense_tracker/domain/parsers/entities/transaction.dart';

void main() {
  setUpAll(() {
    // 1. Load the JSON configuration from the assets directory
    final configFile = File('assets/bank_configs.json');
    final jsonString = configFile.readAsStringSync();
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final banksJson = data['banks'] as List<dynamic>;
    final definitions = banksJson
        .map((b) => BankDefinition.fromJson(b as Map<String, dynamic>))
        .toList();

    // 2. Initialize factory from JSON definitions
    BankParserFactory.initializeFromDefinitions(definitions);
  });

  final engine = SmsParserEngine();

  group('Hierarchical Parser: Bank Specific Tests', () {
    test('HDFC: Card Debited', () {
      const sms =
          'Alert: Your HDFC Bank Card ending 1234 has been debited for Rs. 5000.00 at AMAZON on 05-02-26. Avl Bal: Rs. 15000.00.';
      final tx = engine.tryParse(sms, sender: 'HDFCBK');

      expect(tx, isNotNull);
      expect(tx!.amount, 5000.0);
      expect(tx.merchant, 'AMAZON');
      expect(tx.account, contains('1234'));
      expect(tx.type, TransactionType.debit);
      expect(tx.method, PaymentMethod.card);
    });

    test('HDFC: UPI Debit', () {
      const sms =
          'UPI debit of Rs.99 to Swiggy from your A/C 1234 on 05-02-26.';
      final tx = engine.tryParse(sms, sender: 'HDFCBK');

      expect(tx, isNotNull);
      expect(tx!.amount, 99.0);
      expect(tx.merchant, contains('Swiggy'));
      expect(tx.type, TransactionType.debit);
      expect(tx.method, PaymentMethod.upi);
    });

    test('ICICI: Account debited with Info', () {
      const sms =
          'ICICI Bank Acct XX1234 debited for Rs 3,000.00 on 02-Apr-2025. Info: UPI/Zomato. Avl Bal INR 9,200.00. Dispute? Call 18001080.';
      final tx = engine.tryParse(sms, sender: 'ICICIB');

      expect(tx, isNotNull);
      expect(tx!.amount, 3000.0);
      expect(tx.merchant, contains('Zomato'));
      expect(tx.type, TransactionType.debit);
    });

    test('ICICI: VPA Debit', () {
      const sms =
          'Your ICICI Bank A/c XX4567 debited for INR 1,200.00 on 05-Feb-26; VPA swiggy@upi. Avl Bal: INR 8,500.00.';
      final tx = engine.tryParse(sms, sender: 'ICICIB');

      expect(tx, isNotNull);
      expect(tx!.amount, 1200.0);
      expect(tx.merchant, contains('swiggy'));
      expect(tx.type, TransactionType.debit);
      expect(tx.method, PaymentMethod.upi);
    });

    test('SBI: A/c Debited By', () {
      const sms =
          'Your A/c XX1234 debited by Rs 2,500.00 on 01Apr25. Avl Bal Rs.8,300.00. If not done by you, call 18004253800.';
      final tx = engine.tryParse(sms, sender: 'SBIINB');

      expect(tx, isNotNull);
      expect(tx!.amount, 2500.0);
      expect(tx.account, contains('1234'));
      expect(tx.type, TransactionType.debit);
    });

    test('SBI: Credit', () {
      const sms =
          'SBI: Rs1000.0 credited to A/c XX1234 on 05Feb26 by NEFT:REF NO 1234567890. Bal:Rs15000.0';
      final tx = engine.tryParse(sms, sender: 'SBIINB');

      expect(tx, isNotNull);
      expect(tx!.amount, 1000.0);
      expect(tx.account, contains('1234'));
      expect(tx.type, TransactionType.credit);
    });

    test('Axis: Card Spent', () {
      const sms =
          'INR 1,150.00 spent at ZOMATO on Axis Bank Card XX5678. Bal INR 28,850.00.';
      final tx = engine.tryParse(sms, sender: 'AXISBK');

      expect(tx, isNotNull);
      expect(tx!.amount, 1150.0);
      expect(tx.merchant, contains('ZOMATO'));
      expect(tx.account, contains('5678'));
      expect(tx.type, TransactionType.debit);
      expect(tx.method, PaymentMethod.card);
    });

    test('Axis: General Debit', () {
      const sms =
          'INR 2,000.00 debited from Axis Bank A/c ending 1234 on 01-Apr-25. UPI Ref: 123456789012. Avl Bal INR 18,400.00.';
      final tx = engine.tryParse(sms, sender: 'AXISBK');

      expect(tx, isNotNull);
      expect(tx!.amount, 2000.0);
      expect(tx.account, contains('1234'));
      expect(tx.type, TransactionType.debit);
    });

    test('Kotak: UPI Debit', () {
      const sms =
          'Rs.950.00 debited from your A/c XX2345 to VPA swiggy@upi on 06-Apr. Bal Rs.19,050.00.';
      final tx = engine.tryParse(sms, sender: 'KOTAKB');

      expect(tx, isNotNull);
      expect(tx!.amount, 950.0);
      expect(tx.merchant, contains('swiggy'));
      expect(tx.type, TransactionType.debit);
      expect(tx.method, PaymentMethod.upi);
    });

    test('Kotak: Card Spent', () {
      const sms =
          'Alert: INR 1,199.00 spent on Kotak Credit Card XX5678 at NETFLIX on 02-Apr-2025. Avl Limit: INR 78,801.00.';
      final tx = engine.tryParse(sms, sender: 'KOTAKB');

      expect(tx, isNotNull);
      expect(tx!.amount, 1199.0);
      expect(tx.merchant, contains('NETFLIX'));
      expect(tx.type, TransactionType.debit);
      expect(tx.method, PaymentMethod.card);
    });

    test('PNB: UPI Debit', () {
      const sms =
          'Your A/c XX1234 debited Rs.5,000.00 on 01-04-2025 by UPI. Avl Bal Rs.11,230.00. For dispute call 18001802222.';
      final tx = engine.tryParse(sms, sender: 'PNBSMS');

      expect(tx, isNotNull);
      expect(tx!.amount, 5000.0);
      expect(tx.account, contains('1234'));
      expect(tx.type, TransactionType.debit);
    });

    test('BOB: Debit', () {
      const sms =
          'Your BOB A/c XX1234 debited INR 3,500.00 on 01-Apr-25 via UPI. Avl Bal INR 6,700.00. Not done by you? Call 18005700.';
      final tx = engine.tryParse(sms, sender: 'BOBTXN');

      expect(tx, isNotNull);
      expect(tx!.amount, 3500.0);
      expect(tx.account, contains('1234'));
      expect(tx.type, TransactionType.debit);
      expect(tx.method, PaymentMethod.upi);
    });

    test('ICICI: IMPS Debit', () {
      const sms =
          'A/c XX1234 debited for Rs 3,000.00 on 02-Apr-25. IMPS/1234567890/Zomato/. Avl Bal INR 9,200.00.';
      final tx = engine.tryParse(sms, sender: 'ICICIB');

      expect(tx, isNotNull);
      expect(tx!.amount, 3000.0);
      expect(tx.method, PaymentMethod.imps);
      expect(tx.merchant, contains('Zomato'));
    });

    test('SBI: IMPS Debit', () {
      const sms =
          'Rs 2,500.00 debited from a/c XX1234. IMPS:1234567890/Transfer/Ref. If not done by you, call 1800...';
      final tx = engine.tryParse(sms, sender: 'SBIINB');

      expect(tx, isNotNull);
      expect(tx!.amount, 2500.0);
      expect(tx.method, PaymentMethod.imps);
      expect(tx.merchant, contains('Transfer'));
    });
  });

  group('Hierarchical Parser: Filtering Tests', () {
    test('Should filter out OTPs', () {
      const sms =
          '123456 is your OTP for transaction of Rs. 1000.00 at AMAZON. Do not share.';
      final tx = engine.tryParse(sms, sender: 'HDFCBK');
      expect(tx, isNull);
    });

    test('Should filter out promotional', () {
      const sms =
          'Win Rs. 1 Crore! Play now at MegaLotto.com. This is a promotional message.';
      final tx = engine.tryParse(sms, sender: 'SPAM');
      expect(tx, isNull);
    });
  });

  group('Bulk Sample Validation', () {
    test('Verify all supported banks against sample data', () {
      int successCount = 0;
      int totalTransactions = 0;

      for (var sample in sampleSms) {
        if (sample.sender == 'SPAM') continue;
        if (sample.body.toLowerCase().contains('otp')) continue;
        if (sample.body.toLowerCase().contains('win')) continue;
        if (sample.body.toLowerCase().contains('promotional')) continue;

        totalTransactions++;
        final tx = engine.tryParse(sample.body, sender: sample.sender);
        if (tx != null) successCount++;
      }

      final accuracy = (successCount / totalTransactions) * 100;
      print(
        'Matched $successCount / $totalTransactions samples (${accuracy.toStringAsFixed(1)}%).',
      );
      expect(
        accuracy,
        greaterThanOrEqualTo(70.0),
        reason: 'Should parse at least 70% of valid transaction SMS',
      );
    });
  });
}
