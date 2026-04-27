import 'dart:io';

void main() {
  final file = File(r'e:\P-Code\expense_tracker\lib\data\sample_data.dart');
  final lines = file.readAsLinesSync();

  int startIdx = -1;
  int endIdx = -1;

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].trim() == 'final List<SampleSms> sampleSms = [') {
      startIdx = i;
    }
    if (lines[i].trim() == '];') {
      endIdx = i;
    }
  }

  if (startIdx != -1 && endIdx != -1) {
    lines.insert(startIdx + 1, '  /*');
    lines.insert(endIdx + 1, '  */');
    
    final newData = '''
  // --- INDUSIND BANK ---
  SampleSms(body: 'Debited INR 1,500.00 from your IndusInd Bank A/c ending 1234 on 15-May-26. Avl Bal: INR 45,600.00.', sender: 'INDUSB'),
  SampleSms(body: 'INR 25,000.00 has been credited to your IndusInd Bank A/c ending 1234 on 16-May-26. Avl Bal: INR 70,600.00.', sender: 'INDUSB'),
  SampleSms(body: 'purchase of Rs. 1,250.00 at AMAZON using IndusInd Bank Card.', sender: 'INDUSB'),
  SampleSms(body: 'Avl BAL of INR 68,350.00 after debit of INR 2,250.00 in account XX1234.', sender: 'INDUSB'),
  SampleSms(body: 'INR 500.00 has been debited from your IndusInd Bank A/c ending 1234 for UPI. Avl Bal: INR 67,850.00.', sender: 'INDUSB'),

  // --- JK BANK ---
  SampleSms(body: 'A/c XX1234 debited by INR 3,500.00 on 12-Apr-26 towards Electricity Bill. Available Bal is INR 21,500.00.', sender: 'JKBANK'),
  SampleSms(body: 'A/c XX1234 credited by INR 15,000.00 via NEFT from EMPLOYER.', sender: 'JKBANK'),
  SampleSms(body: 'transferred INR 4,200.00 to A/C XX5678. Avl Bal Rs. 17,300.00.', sender: 'JKBANK'),
  SampleSms(body: 'A/c XX1234 debited by INR 800.00 on 14-Apr-26 at POS. Available Bal is INR 16,500.00.', sender: 'JKBANK'),
  SampleSms(body: 'credited INR 5,000.00 to A/C XX1234 via IMPS. Avl Bal Rs. 21,500.00.', sender: 'JKBANK'),

  // --- JIOPAY ---
  SampleSms(body: 'Recharge successful to Jio Number: 9876543210. Rs. 749.00. Transaction ID: 1122334455.', sender: 'JIOPAY'),
  SampleSms(body: 'payment successful to Zomato. Rs. 350.00. Transaction ID: 5566778899.', sender: 'JIOPAY'),
  SampleSms(body: 'bill payment successful. Rs. 1,250.00. Transaction ID: 9988776655.', sender: 'JIOPAY'),
  SampleSms(body: 'Recharge successful to Jio Number: 8765432109. Rs. 199.00. Transaction ID: 2233445566.', sender: 'JIOPAY'),
  SampleSms(body: 'payment successful to Swiggy. Rs. 420.00. Transaction ID: 3344556677.', sender: 'JIOPAY'),

  // --- JIO PAYMENTS BANK ---
  SampleSms(body: 'Rs. 850.00 debited with JPB A/c x1234 to Merchant. UPI/DR/112233445566.', sender: 'JIOPBS'),
  SampleSms(body: 'Rs. 12,000.00 credited with JPB A/c x1234. Avl Bal: Rs. 15,450.00.', sender: 'JIOPBS'),
  SampleSms(body: 'Sent from x1234 to Ramesh. Rs. 1,500.00. Avl Bal: Rs. 13,950.00.', sender: 'JIOPBS'),
  SampleSms(body: 'Rs. 320.00 debited with JPB A/c x1234 to Uber. UPI/DR/998877665544.', sender: 'JIOPBS'),
  SampleSms(body: 'Rs. 2,000.00 credited with JPB A/c x1234 via IMPS. Avl Bal: Rs. 15,630.00.', sender: 'JIOPBS'),

  // --- AMAZON PAY ---
  SampleSms(body: 'Rs. 500.00 added to your Amazon Pay balance. Transaction ID: AMZ123456.', sender: 'AMZPAY'),
  SampleSms(body: 'Paid Rs. 1,200.00 using Amazon Pay balance at BigBazaar. Txn ID: AMZ987654.', sender: 'AMZPAY'),
  SampleSms(body: 'Cashback of Rs. 50.00 credited to your Amazon Pay balance.', sender: 'AMZPAY'),
  SampleSms(body: 'Rs. 350.00 paid for mobile recharge using Amazon Pay balance.', sender: 'AMZPAY'),
  SampleSms(body: 'Refund of Rs. 899.00 credited to your Amazon Pay balance.', sender: 'AMZPAY'),

  // --- KARNATAKA BANK ---
  SampleSms(body: 'Dear Customer, your A/c XX1234 is debited with Rs. 2,500.00 on 20-May-26. Avl Bal: Rs. 34,500.00.', sender: 'KARBK'),
  SampleSms(body: 'Dear Customer, your A/c XX1234 is credited with Rs. 18,000.00 on 21-May-26 via NEFT. Avl Bal: Rs. 52,500.00.', sender: 'KARBK'),
  SampleSms(body: 'Rs. 850.00 debited from A/c XX1234 for UPI payment. Avl Bal: Rs. 51,650.00.', sender: 'KARBK'),
  SampleSms(body: 'Cash withdrawal of Rs. 5,000.00 from A/c XX1234 at ATM. Avl Bal: Rs. 46,650.00.', sender: 'KARBK'),
  SampleSms(body: 'credited Rs. 2,000.00 to A/c XX1234 via IMPS. Avl Bal: Rs. 48,650.00.', sender: 'KARBK'),

  // --- KERALA GRAMIN BANK ---
  SampleSms(body: 'Your A/C XX1234 has been debited by Rs. 1,000.00 on 10-Jun-26. Avl Bal: Rs. 12,500.00.', sender: 'KGBANK'),
  SampleSms(body: 'Your A/C XX1234 has been credited by Rs. 5,000.00 on 11-Jun-26. Avl Bal: Rs. 17,500.00.', sender: 'KGBANK'),
  SampleSms(body: 'Rs. 350.00 debited from A/C XX1234 via UPI. Avl Bal: Rs. 17,150.00.', sender: 'KGBANK'),
  SampleSms(body: 'Rs. 8,000.00 credited to A/C XX1234 via NEFT. Avl Bal: Rs. 25,150.00.', sender: 'KGBANK'),
  SampleSms(body: 'withdrawn Rs. 2,000.00 from A/C XX1234 at ATM. Avl Bal: Rs. 23,150.00.', sender: 'KGBANK'),

  // --- SARASWAT CO-OPERATIVE BANK ---
  SampleSms(body: 'A/c XX1234 debited for Rs. 4,500.00 on 01-Jul-26. Avl Bal: Rs. 45,000.00.', sender: 'SRSWTB'),
  SampleSms(body: 'A/c XX1234 credited for Rs. 20,000.00 on 02-Jul-26. Avl Bal: Rs. 65,000.00.', sender: 'SRSWTB'),
  SampleSms(body: 'Rs. 1,200.00 debited from A/c XX1234 for POS txn. Avl Bal: Rs. 63,800.00.', sender: 'SRSWTB'),
  SampleSms(body: 'Rs. 3,500.00 credited to A/c XX1234 via IMPS. Avl Bal: Rs. 67,300.00.', sender: 'SRSWTB'),
  SampleSms(body: 'Rs. 500.00 debited from A/c XX1234 via UPI. Avl Bal: Rs. 66,800.00.', sender: 'SRSWTB'),

  // --- SOUTH INDIAN BANK ---
  SampleSms(body: 'Rs. 2,800.00 debited from your A/c XX1234 on 15-Aug-26. Avl Bal: Rs. 28,500.00.', sender: 'SIBNK'),
  SampleSms(body: 'Rs. 15,000.00 credited to your A/c XX1234 on 16-Aug-26 via NEFT. Avl Bal: Rs. 43,500.00.', sender: 'SIBNK'),
  SampleSms(body: 'UPI txn of Rs. 650.00 debited from A/c XX1234. Avl Bal: Rs. 42,850.00.', sender: 'SIBNK'),
  SampleSms(body: 'IMPS credit of Rs. 4,000.00 to A/c XX1234. Avl Bal: Rs. 46,850.00.', sender: 'SIBNK'),
  SampleSms(body: 'ATM withdrawal of Rs. 3,000.00 from A/c XX1234. Avl Bal: Rs. 43,850.00.', sender: 'SIBNK'),

  // --- STANDARD CHARTERED BANK ---
  SampleSms(body: 'INR 5,500.00 debited from your A/c XX1234 on 05-Sep-26. Avl Bal: INR 1,55,000.00.', sender: 'STANCB'),
  SampleSms(body: 'INR 85,000.00 credited to your A/c XX1234 on 06-Sep-26. Avl Bal: INR 2,40,000.00.', sender: 'STANCB'),
  SampleSms(body: 'spent INR 2,500.00 on your Credit Card XX9999. Avl limit: INR 1,47,500.00.', sender: 'STANCB'),
  SampleSms(body: 'INR 1,200.00 debited from A/c XX1234 via UPI. Avl Bal: INR 2,38,800.00.', sender: 'STANCB'),
  SampleSms(body: 'INR 12,000.00 credited to A/c XX1234 via NEFT. Avl Bal: INR 2,50,800.00.', sender: 'STANCB'),

  // --- UCO BANK ---
  SampleSms(body: 'A/c XX1234 is debited with Rs. 1,500.00 on 10-Oct-26. Available Balance Rs. 18,500.00.', sender: 'UCOBNK'),
  SampleSms(body: 'A/c XX1234 is credited with Rs. 10,000.00 on 11-Oct-26. Available Balance Rs. 28,500.00.', sender: 'UCOBNK'),
  SampleSms(body: 'Rs. 450.00 debited from A/c XX1234 via UPI. Available Balance Rs. 28,050.00.', sender: 'UCOBNK'),
  SampleSms(body: 'Rs. 5,000.00 credited to A/c XX1234 via IMPS. Available Balance Rs. 33,050.00.', sender: 'UCOBNK'),
  SampleSms(body: 'ATM withdrawal of Rs. 2,000.00 from A/c XX1234. Available Balance Rs. 31,050.00.', sender: 'UCOBNK'),

  // --- UNION BANK OF INDIA ---
  SampleSms(body: 'Rs. 3,200.00 debited from your A/c XX1234 on 20-Nov-26. Avl Bal: Rs. 42,500.00.', sender: 'UNIONB'),
  SampleSms(body: 'Rs. 25,000.00 credited to your A/c XX1234 on 21-Nov-26 via NEFT. Avl Bal: Rs. 67,500.00.', sender: 'UNIONB'),
  SampleSms(body: 'UPI payment of Rs. 850.00 debited from A/c XX1234. Avl Bal: Rs. 66,650.00.', sender: 'UNIONB'),
  SampleSms(body: 'IMPS credit of Rs. 8,000.00 to A/c XX1234. Avl Bal: Rs. 74,650.00.', sender: 'UNIONB'),
  SampleSms(body: 'Cash withdrawal of Rs. 4,000.00 from A/c XX1234 at ATM. Avl Bal: Rs. 70,650.00.', sender: 'UNIONB'),

  // --- YES BANK ---
  SampleSms(body: 'INR 4,500.00 debited from your YES BANK A/c XX1234 on 05-Dec-26. Avl Bal: INR 55,000.00.', sender: 'YESBNK'),
  SampleSms(body: 'INR 35,000.00 credited to your YES BANK A/c XX1234 on 06-Dec-26. Avl Bal: INR 90,000.00.', sender: 'YESBNK'),
  SampleSms(body: 'spent INR 1,500.00 on your YES BANK Credit Card XX8888. Avl limit: INR 73,500.00.', sender: 'YESBNK'),
  SampleSms(body: 'INR 650.00 debited from A/c XX1234 via UPI. Avl Bal: INR 89,350.00.', sender: 'YESBNK'),
  SampleSms(body: 'INR 15,000.00 credited to A/c XX1234 via NEFT. Avl Bal: INR 1,04,350.00.', sender: 'YESBNK'),
''';
    lines.insert(endIdx + 2, newData);

    file.writeAsStringSync(lines.join('\\n'));
    print('Done');
  } else {
    print('Could not find start or end index.');
  }
}
