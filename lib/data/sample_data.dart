class SampleSms {
  final String body;
  final String sender;
  final DateTime? date;

  const SampleSms({required this.body, required this.sender, this.date});
}

final List<SampleSms> sampleSms = [  // ── HDFC Bank ─────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'INR 2,500.00 debited from HDFC Bank A/c XX1234 on 01-Apr-25. UPI/PhonePe. Avl Bal INR 15,240.00. Not you? Call 18002676161.',
    sender: 'VM-HDFCBK',
  ),

  SampleSms(
    body:
        'INR 1,200.00 debited from HDFC Bank A/c XX1234 on 02-Apr-25. UPI/GooglePay. Avl Bal INR 14,040.00.',
    sender: 'VM-HDFCBK',
  ),

  SampleSms(
    body:
        'INR 30,000.00 credited to HDFC Bank A/c XX1234 on 01-Apr-25. Salary. Avl Bal INR 45,240.00.',
    sender: 'VM-HDFCBK',
  ),

  SampleSms(
    body:
        'INR 1,999.00 spent on HDFC Bank Credit Card **5678 at SWIGGY on 03-Apr-2025. Available Limit: INR 43,002.00.',
    sender: 'VM-HDFCBK',
  ),

  SampleSms(
    body:
        'INR 10,000.00 credited to HDFC Bank Credit Card **5678 on 04-Apr-2025. Total Amt Due: INR 3,450.00.',
    sender: 'VM-HDFCBK',
  ),

  // ── SBI ───────────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Your A/c XX1234 debited by Rs 2,500.00 on 01Apr25. Avl Bal Rs.8,300.00. If not done by you, call 18004253800.',
    sender: 'VM-SBIINB',
  ),

  SampleSms(
    body:
        'Your A/c XX1234 debited by Rs 750.00 on 02Apr25. Avl Bal Rs.7,550.00. If not done by you, call 18004253800.',
    sender: 'VM-SBIINB',
  ),

  SampleSms(
    body:
        'Your A/c XX1234 credited by Rs 50,000.00 on 01Apr25. Avl Bal Rs.57,550.00. -SBI',
    sender: 'VM-SBIINB',
  ),

  SampleSms(
    body:
        'Your A/c XX1234 credited by Rs 15,000.00 on 03Apr25. Avl Bal Rs.72,550.00. -SBI',
    sender: 'VM-SBIINB',
  ),

  SampleSms(
    body:
        'Dear Customer, your A/c XX1234 is debited with Rs.10,000.00 on 02-Apr-25 by NEFT. Avl Bal Rs.62,550.00.',
    sender: 'VM-SBIINB',
  ),

  // ── ICICI Bank ────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'ICICI Bank Acct XX1234 debited for Rs 3,000.00 on 02-Apr-2025. Info: UPI/Zomato. Avl Bal INR 9,200.00. Dispute? Call 18001080.',
    sender: 'VM-ICICIB',
  ),

  SampleSms(
    body:
        'ICICI Bank Acct XX1234 debited for Rs 500.00 on 03-Apr-2025. Info: UPI/PhonePe. Avl Bal INR 8,700.00. Dispute? Call 18001080.',
    sender: 'VM-ICICIB',
  ),

  SampleSms(
    body:
        'ICICI Bank Acct XX1234 credited with INR 15,160.00 on 01-Apr-2025 by A/c linked to mobile XXXXXX79. Avl Bal INR 23,860.00.',
    sender: 'VM-ICICIB',
  ),

  SampleSms(
    body:
        'ICICI Bank Acct XX1234 credited with INR 8,000.00 on 03-Apr-2025. IMPS Ref 411234567890. Avl Bal INR 31,860.00.',
    sender: 'VM-ICICIB',
  ),

  SampleSms(
    body:
        'Dear Customer, INR 1,500.00 debited from ICICI Bank A/C XX1234 on 04-Apr-2025. Info: UPI/Swiggy. Avl Bal INR 30,360.00.',
    sender: 'VM-ICICIB',
  ),

  // ── Axis Bank ─────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'INR 2,000.00 debited from Axis Bank A/c ending 1234 on 01-Apr-25. UPI Ref: 123456789012. Avl Bal INR 18,400.00.',
    sender: 'VM-AXISBK',
  ),

  SampleSms(
    body:
        'INR 450.00 debited from Axis Bank A/c ending 1234 on 02-Apr-25. UPI Ref: 234567890123. Avl Bal INR 17,950.00.',
    sender: 'VM-AXISBK',
  ),

  SampleSms(
    body:
        'INR 30,000.00 credited to Axis Bank A/c ending 1234 on 01-Apr-25. NEFT Ref: AXIB25091234567. Avl Bal INR 47,950.00.',
    sender: 'VM-AXISBK',
  ),

  SampleSms(
    body:
        'INR 5,500.00 credited to Axis Bank A/c ending 1234 on 03-Apr-25. IMPS Ref: 345678901234. Avl Bal INR 53,450.00.',
    sender: 'VM-AXISBK',
  ),

  // ── Kotak Mahindra Bank ───────────────────────────────────────────────────
  SampleSms(
    body:
        'Rs.3,200.00 has been debited from your Kotak A/c XX1234 on 01-Apr-25. Available Bal: Rs.16,800.00. Call 18002740110 if not done by you.',
    sender: 'VM-KOTAKB',
  ),

  SampleSms(
    body:
        'Rs.600.00 has been debited from your Kotak A/c XX1234 on 02-Apr-25. Available Bal: Rs.16,200.00. Call 18002740110 if not done by you.',
    sender: 'VM-KOTAKB',
  ),

  SampleSms(
    body:
        'Rs.20,000.00 has been credited to your Kotak A/c XX1234 on 01-Apr-25. Available Bal: Rs.36,200.00.',
    sender: 'VM-KOTAKB',
  ),

  SampleSms(
    body:
        'Alert: INR 1,199.00 spent on Kotak Credit Card XX5678 at NETFLIX on 02-Apr-2025. Avl Limit: INR 78,801.00.',
    sender: 'VM-KOTAKB',
  ),

  // ── IndusInd Bank (Old) ─────────────────────────────────────────────────────
  SampleSms(
    body:
        'INR 4,500.00 has been debited from your IndusInd Bank A/c ending 1234 on 01-Apr-25. Avl Bal: INR 22,100.00.',
    sender: 'VM-INDUSB',
  ),

  SampleSms(
    body:
        'INR 12,000.00 has been credited to your IndusInd Bank A/c ending 1234 on 02-Apr-25. Avl Bal: INR 34,100.00.',
    sender: 'VM-INDUSB',
  ),

  // ── IDFC FIRST Bank ───────────────────────────────────────────────────────
  SampleSms(
    body:
        'INR 1,800.00 debited from IDFC FIRST Bank A/c XX1234 on 01-Apr-25. UPI/GooglePay. Avl Bal INR 14,650.00. Not you? Call 18008899.',
    sender: 'VM-IDFCFB',
  ),

  SampleSms(
    body:
        'INR 7,000.00 credited to IDFC FIRST Bank A/c XX1234 on 02-Apr-25. IMPS Ref 512345678901. Avl Bal INR 21,650.00.',
    sender: 'VM-IDFCFB',
  ),

  // ── PNB ───────────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Your A/c XX1234 debited Rs.5,000.00 on 01-04-2025 by UPI. Avl Bal Rs.11,230.00. For dispute call 18001802222.',
    sender: 'VM-PNBSMS',
  ),

  SampleSms(
    body:
        'Your A/c XX1234 credited Rs.18,000.00 on 01-04-2025. Avl Bal Rs.29,230.00. -Punjab National Bank',
    sender: 'VM-PNBSMS',
  ),

  // ── Canara Bank ───────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Dear Customer, A/c No XX1234 is debited with INR 2,000.00 on 01-04-2025. Avl Bal: INR 9,540.00. -Canara Bank.',
    sender: 'VM-CANBK',
  ),

  SampleSms(
    body:
        'Dear Customer, A/c No XX1234 is credited with INR 10,000.00 on 02-04-2025. Avl Bal: INR 19,540.00. -Canara Bank.',
    sender: 'VM-CANBK',
  ),

  // ── Bank of Baroda ────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Your BOB A/c XX1234 debited INR 3,500.00 on 01-Apr-25 via UPI. Avl Bal INR 6,700.00. Not done by you? Call 18005700.',
    sender: 'VM-BOBTXN',
  ),

  SampleSms(
    body:
        'Your BOB A/c XX1234 credited INR 22,000.00 on 02-Apr-25. Avl Bal INR 28,700.00. -Bank of Baroda.',
    sender: 'VM-BOBTXN',
  ),

  // ── Federal Bank ──────────────────────────────────────────────────────────
  SampleSms(
    body:
        'INR 1,100.00 debited from Federal Bank A/c XX1234 on 01-Apr-2025. UPI Txn. Avl Bal: INR 5,430.00.',
    sender: 'VM-FEDBK',
  ),

  SampleSms(
    body:
        'INR 9,000.00 credited to Federal Bank A/c XX1234 on 02-Apr-2025. NEFT. Avl Bal: INR 14,430.00.',
    sender: 'VM-FEDBK',
  ),

  // ── HSBC ──────────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Rs.2,750.00 debited from HSBC A/c XX1234 on 01-Apr-25. Avl Bal Rs.31,250.00. Queries? Call 18002676161.',
    sender: 'VM-HSBCIN',
  ),

  SampleSms(
    body:
        'Rs.40,000.00 credited to HSBC A/c XX1234 on 02-Apr-25. Avl Bal Rs.71,250.00.',
    sender: 'VM-HSBCIN',
  ),

  // --- INDUSIND BANK ---
  SampleSms(
    body:
        'Debited INR 1,500.00 from your IndusInd Bank A/c ending 1234 on 15-May-26. Avl Bal: INR 45,600.00.',
    sender: 'INDUSB',
  ),
  SampleSms(
    body:
        'INR 25,000.00 has been credited to your IndusInd Bank A/c ending 1234 on 16-May-26. Avl Bal: INR 70,600.00.',
    sender: 'INDUSB',
  ),
  SampleSms(
    body: 'purchase of Rs. 1,250.00 at AMAZON using IndusInd Bank Card.',
    sender: 'INDUSB',
  ),
  SampleSms(
    body:
        'Avl BAL of INR 68,350.00 after debit of INR 2,250.00 in account XX1234.',
    sender: 'INDUSB',
  ),
  SampleSms(
    body:
        'INR 500.00 has been debited from your IndusInd Bank A/c ending 1234 for UPI. Avl Bal: INR 67,850.00.',
    sender: 'INDUSB',
  ),

  // --- JK BANK ---
  SampleSms(
    body:
        'A/c XX1234 debited by INR 3,500.00 on 12-Apr-26 towards Electricity Bill. Available Bal is INR 21,500.00.',
    sender: 'JKBANK',
  ),
  SampleSms(
    body: 'A/c XX1234 credited by INR 15,000.00 via NEFT from EMPLOYER.',
    sender: 'JKBANK',
  ),
  SampleSms(
    body: 'transferred INR 4,200.00 to A/C XX5678. Avl Bal Rs. 17,300.00.',
    sender: 'JKBANK',
  ),
  SampleSms(
    body:
        'A/c XX1234 debited by INR 800.00 on 14-Apr-26 at POS. Available Bal is INR 16,500.00.',
    sender: 'JKBANK',
  ),
  SampleSms(
    body:
        'credited INR 5,000.00 to A/C XX1234 via IMPS. Avl Bal Rs. 21,500.00.',
    sender: 'JKBANK',
  ),

  // --- JIOPAY ---
  SampleSms(
    body:
        'Recharge successful to Jio Number: 9876543210. Rs. 749.00. Transaction ID: 1122334455.',
    sender: 'JIOPAY',
  ),
  SampleSms(
    body:
        'payment successful to Zomato. Rs. 350.00. Transaction ID: 5566778899.',
    sender: 'JIOPAY',
  ),
  SampleSms(
    body: 'bill payment successful. Rs. 1,250.00. Transaction ID: 9988776655.',
    sender: 'JIOPAY',
  ),
  SampleSms(
    body:
        'Recharge successful to Jio Number: 8765432109. Rs. 199.00. Transaction ID: 2233445566.',
    sender: 'JIOPAY',
  ),
  SampleSms(
    body:
        'payment successful to Swiggy. Rs. 420.00. Transaction ID: 3344556677.',
    sender: 'JIOPAY',
  ),

  // --- JIO PAYMENTS BANK ---
  SampleSms(
    body:
        'Rs. 850.00 debited with JPB A/c x1234 to Merchant. UPI/DR/112233445566.',
    sender: 'JIOPBS',
  ),
  SampleSms(
    body: 'Rs. 12,000.00 credited with JPB A/c x1234. Avl Bal: Rs. 15,450.00.',
    sender: 'JIOPBS',
  ),
  SampleSms(
    body: 'Sent from x1234 to Ramesh. Rs. 1,500.00. Avl Bal: Rs. 13,950.00.',
    sender: 'JIOPBS',
  ),
  SampleSms(
    body: 'Rs. 320.00 debited with JPB A/c x1234 to Uber. UPI/DR/998877665544.',
    sender: 'JIOPBS',
  ),
  SampleSms(
    body:
        'Rs. 2,000.00 credited with JPB A/c x1234 via IMPS. Avl Bal: Rs. 15,630.00.',
    sender: 'JIOPBS',
  ),

  // --- AMAZON PAY ---
  SampleSms(
    body:
        'Rs. 500.00 added to your Amazon Pay balance. Transaction ID: AMZ123456.',
    sender: 'AMZPAY',
  ),
  SampleSms(
    body:
        'Paid Rs. 1,200.00 using Amazon Pay balance at BigBazaar. Txn ID: AMZ987654.',
    sender: 'AMZPAY',
  ),
  SampleSms(
    body: 'Cashback of Rs. 50.00 credited to your Amazon Pay balance.',
    sender: 'AMZPAY',
  ),
  SampleSms(
    body: 'Rs. 350.00 paid for mobile recharge using Amazon Pay balance.',
    sender: 'AMZPAY',
  ),
  SampleSms(
    body: 'Refund of Rs. 899.00 credited to your Amazon Pay balance.',
    sender: 'AMZPAY',
  ),

  // --- KARNATAKA BANK ---
  SampleSms(
    body:
        'Dear Customer, your A/c XX1234 is debited with Rs. 2,500.00 on 20-May-26. Avl Bal: Rs. 34,500.00.',
    sender: 'KARBK',
  ),
  SampleSms(
    body:
        'Dear Customer, your A/c XX1234 is credited with Rs. 18,000.00 on 21-May-26 via NEFT. Avl Bal: Rs. 52,500.00.',
    sender: 'KARBK',
  ),
  SampleSms(
    body:
        'Rs. 850.00 debited from A/c XX1234 for UPI payment. Avl Bal: Rs. 51,650.00.',
    sender: 'KARBK',
  ),
  SampleSms(
    body:
        'Cash withdrawal of Rs. 5,000.00 from A/c XX1234 at ATM. Avl Bal: Rs. 46,650.00.',
    sender: 'KARBK',
  ),
  SampleSms(
    body:
        'credited Rs. 2,000.00 to A/c XX1234 via IMPS. Avl Bal: Rs. 48,650.00.',
    sender: 'KARBK',
  ),

  // --- KERALA GRAMIN BANK ---
  SampleSms(
    body:
        'Your A/C XX1234 has been debited by Rs. 1,000.00 on 10-Jun-26. Avl Bal: Rs. 12,500.00.',
    sender: 'KGBANK',
  ),
  SampleSms(
    body:
        'Your A/C XX1234 has been credited by Rs. 5,000.00 on 11-Jun-26. Avl Bal: Rs. 17,500.00.',
    sender: 'KGBANK',
  ),
  SampleSms(
    body: 'Rs. 350.00 debited from A/C XX1234 via UPI. Avl Bal: Rs. 17,150.00.',
    sender: 'KGBANK',
  ),
  SampleSms(
    body:
        'Rs. 8,000.00 credited to A/C XX1234 via NEFT. Avl Bal: Rs. 25,150.00.',
    sender: 'KGBANK',
  ),
  SampleSms(
    body:
        'withdrawn Rs. 2,000.00 from A/C XX1234 at ATM. Avl Bal: Rs. 23,150.00.',
    sender: 'KGBANK',
  ),

  // --- SARASWAT CO-OPERATIVE BANK ---
  SampleSms(
    body:
        'A/c XX1234 debited for Rs. 4,500.00 on 01-Jul-26. Avl Bal: Rs. 45,000.00.',
    sender: 'SRSWTB',
  ),
  SampleSms(
    body:
        'A/c XX1234 credited for Rs. 20,000.00 on 02-Jul-26. Avl Bal: Rs. 65,000.00.',
    sender: 'SRSWTB',
  ),
  SampleSms(
    body:
        'Rs. 1,200.00 debited from A/c XX1234 for POS txn. Avl Bal: Rs. 63,800.00.',
    sender: 'SRSWTB',
  ),
  SampleSms(
    body:
        'Rs. 3,500.00 credited to A/c XX1234 via IMPS. Avl Bal: Rs. 67,300.00.',
    sender: 'SRSWTB',
  ),
  SampleSms(
    body: 'Rs. 500.00 debited from A/c XX1234 via UPI. Avl Bal: Rs. 66,800.00.',
    sender: 'SRSWTB',
  ),

  // --- SOUTH INDIAN BANK ---
  SampleSms(
    body:
        'Rs. 2,800.00 debited from your A/c XX1234 on 15-Aug-26. Avl Bal: Rs. 28,500.00.',
    sender: 'SIBNK',
  ),
  SampleSms(
    body:
        'Rs. 15,000.00 credited to your A/c XX1234 on 16-Aug-26 via NEFT. Avl Bal: Rs. 43,500.00.',
    sender: 'SIBNK',
  ),
  SampleSms(
    body:
        'UPI txn of Rs. 650.00 debited from A/c XX1234. Avl Bal: Rs. 42,850.00.',
    sender: 'SIBNK',
  ),
  SampleSms(
    body: 'IMPS credit of Rs. 4,000.00 to A/c XX1234. Avl Bal: Rs. 46,850.00.',
    sender: 'SIBNK',
  ),
  SampleSms(
    body:
        'ATM withdrawal of Rs. 3,000.00 from A/c XX1234. Avl Bal: Rs. 43,850.00.',
    sender: 'SIBNK',
  ),

  // --- STANDARD CHARTERED BANK ---
  SampleSms(
    body:
        'INR 5,500.00 debited from your A/c XX1234 on 05-Sep-26. Avl Bal: INR 1,55,000.00.',
    sender: 'STANCB',
  ),
  SampleSms(
    body:
        'INR 85,000.00 credited to your A/c XX1234 on 06-Sep-26. Avl Bal: INR 2,40,000.00.',
    sender: 'STANCB',
  ),
  SampleSms(
    body:
        'spent INR 2,500.00 on your Credit Card XX9999. Avl limit: INR 1,47,500.00.',
    sender: 'STANCB',
  ),
  SampleSms(
    body:
        'INR 1,200.00 debited from A/c XX1234 via UPI. Avl Bal: INR 2,38,800.00.',
    sender: 'STANCB',
  ),
  SampleSms(
    body:
        'INR 12,000.00 credited to A/c XX1234 via NEFT. Avl Bal: INR 2,50,800.00.',
    sender: 'STANCB',
  ),

  // --- UCO BANK ---
  SampleSms(
    body:
        'A/c XX1234 is debited with Rs. 1,500.00 on 10-Oct-26. Available Balance Rs. 18,500.00.',
    sender: 'UCOBNK',
  ),
  SampleSms(
    body:
        'A/c XX1234 is credited with Rs. 10,000.00 on 11-Oct-26. Available Balance Rs. 28,500.00.',
    sender: 'UCOBNK',
  ),
  SampleSms(
    body:
        'Rs. 450.00 debited from A/c XX1234 via UPI. Available Balance Rs. 28,050.00.',
    sender: 'UCOBNK',
  ),
  SampleSms(
    body:
        'Rs. 5,000.00 credited to A/c XX1234 via IMPS. Available Balance Rs. 33,050.00.',
    sender: 'UCOBNK',
  ),
  SampleSms(
    body:
        'ATM withdrawal of Rs. 2,000.00 from A/c XX1234. Available Balance Rs. 31,050.00.',
    sender: 'UCOBNK',
  ),

  // --- UNION BANK OF INDIA ---
  SampleSms(
    body:
        'Rs. 3,200.00 debited from your A/c XX1234 on 20-Nov-26. Avl Bal: Rs. 42,500.00.',
    sender: 'UNIONB',
  ),
  SampleSms(
    body:
        'Rs. 25,000.00 credited to your A/c XX1234 on 21-Nov-26 via NEFT. Avl Bal: Rs. 67,500.00.',
    sender: 'UNIONB',
  ),
  SampleSms(
    body:
        'UPI payment of Rs. 850.00 debited from A/c XX1234. Avl Bal: Rs. 66,650.00.',
    sender: 'UNIONB',
  ),
  SampleSms(
    body: 'IMPS credit of Rs. 8,000.00 to A/c XX1234. Avl Bal: Rs. 74,650.00.',
    sender: 'UNIONB',
  ),
  SampleSms(
    body:
        'Cash withdrawal of Rs. 4,000.00 from A/c XX1234 at ATM. Avl Bal: Rs. 70,650.00.',
    sender: 'UNIONB',
  ),

  // --- YES BANK ---
  SampleSms(
    body:
        'INR 4,500.00 debited from your YES BANK A/c XX1234 on 05-Dec-26. Avl Bal: INR 55,000.00.',
    sender: 'YESBNK',
  ),
  SampleSms(
    body:
        'INR 35,000.00 credited to your YES BANK A/c XX1234 on 06-Dec-26. Avl Bal: INR 90,000.00.',
    sender: 'YESBNK',
  ),
  SampleSms(
    body:
        'spent INR 1,500.00 on your YES BANK Credit Card XX8888. Avl limit: INR 73,500.00.',
    sender: 'YESBNK',
  ),
  SampleSms(
    body: 'INR 650.00 debited from A/c XX1234 via UPI. Avl Bal: INR 89,350.00.',
    sender: 'YESBNK',
  ),
  SampleSms(
    body:
        'INR 15,000.00 credited to A/c XX1234 via NEFT. Avl Bal: INR 1,04,350.00.',
    sender: 'YESBNK',
  ),

  // =========================
  // INDUSIND BANK
  // =========================
  SampleSms(
    body:
        'Rs.2,450.00 debited from A/c XX4512 on 24-04-26 towards BIG BAZAAR. Avl Bal: Rs.56,781.90',
    sender: 'INDUSB',
  ),
  SampleSms(
    body:
        'Your IndusInd Credit Card xx7821 used for INR 9,999.00 at AMAZON PAY INDIA on 24/04/26 18:14. Avl Limit: INR 1,20,001.00',
    sender: 'INDUSB',
  ),
  SampleSms(
    body:
        'UPI txn of Rs.1,250.00 from A/c **4512 to priya@okhdfcbank successful. Ref: 611492784221',
    sender: 'INDUSB',
  ),
  SampleSms(
    body:
        'Cash withdrawal of Rs.10,000 from ATM using Debit Card xx4512 at MUMBAI. Avl Bal Rs.46,781.90',
    sender: 'INDUSB',
  ),
  SampleSms(
    body:
        'Salary of INR 75,000.00 credited to A/c XX4512 via NEFT from INFOSOFT PVT LTD.',
    sender: 'INDUSB',
  ),
  SampleSms(
    body:
        'OTP 662191 for online transaction of Rs.4,800 on your IndusInd card. Valid 5 mins.',
    sender: 'INDUSB',
  ),

  // =========================
  // JK BANK
  // =========================
  SampleSms(
    body:
        'A/c XX8831 debited by Rs.3,200.00 on 24APR26 at RELIANCE SMART. Bal: Rs.18,220.50',
    sender: 'JKBANK',
  ),
  SampleSms(
    body:
        'Credit of INR 48,500.00 in A/c **8831 by SALARY transfer. Available Balance Rs.66,720.50',
    sender: 'JKBANK',
  ),
  SampleSms(
    body:
        'UPI transfer of Rs.850 to amit@ybl from A/c XX8831. UTR 611482938211',
    sender: 'JKBANK',
  ),
  SampleSms(
    body: 'ATM WDL Rs.5,000 from A/c **8831 at Srinagar ATM. Bal Rs.13,220.50',
    sender: 'JKBANK',
  ),
  SampleSms(
    body: 'Txn declined on card xx8831 due to daily withdrawal limit exceeded.',
    sender: 'JKBANK',
  ),
  SampleSms(
    body: 'OTP for J&K Bank txn is 104228. Do not share.',
    sender: 'JKBANK',
  ),

  // =========================
  // JIOPAY
  // =========================
  SampleSms(
    body:
        'Rs.399.00 paid via JioPay to MYJIO RECHARGE. Txn ID: JP611492001. Wallet Bal Rs.1,220.00',
    sender: 'JIOPAY',
  ),
  SampleSms(
    body: 'Money added Rs.2,000.00 to JioPay wallet using UPI. Ref 1182011',
    sender: 'JIOPAY',
  ),
  SampleSms(
    body:
        'Payment of Rs.799 to AJIO successful via JioPay QR. Merchant: AJIO STORE',
    sender: 'JIOPAY',
  ),
  SampleSms(
    body: 'Refund of Rs.399 initiated to JioPay Wallet. Will reflect in 2 hrs.',
    sender: 'JIOPAY',
  ),
  SampleSms(
    body: 'OTP 928441 for JioPay login. Valid 10 min.',
    sender: 'JIOPAY',
  ),
  SampleSms(
    body: 'Txn failed for Rs.1,250 at Merchant due to network timeout.',
    sender: 'JIOPAY',
  ),

  // =========================
  // JIO PAYMENTS BANK
  // =========================
  SampleSms(
    body:
        'Rs.1,000.00 credited to Jio Payments Bank A/c XX9912 via IMPS. Bal: Rs.5,600.00',
    sender: 'JIOPBK',
  ),
  SampleSms(
    body: 'UPI payment Rs.250 to tea@oksbi from A/c **9912 successful.',
    sender: 'JIOPBK',
  ),
  SampleSms(
    body: 'Cashback of Rs.50 received in Jio Payments Bank account.',
    sender: 'JIOPBK',
  ),
  SampleSms(
    body: 'Debit alert: Rs.799 towards recharge from A/c XX9912. Bal Rs.4,801',
    sender: 'JIOPBK',
  ),
  SampleSms(
    body: 'OTP 229911 for transaction authentication.',
    sender: 'JIOPBK',
  ),
  SampleSms(
    body:
        'Low balance alert: Available balance in your Jio PB account is Rs.95 only.',
    sender: 'JIOPBK',
  ),

  // =========================
  // AMAZON PAY
  // =========================
  SampleSms(
    body:
        'Amazon Pay: Rs.1,499 paid to ZOMATO using balance. Order Ref APY6112991',
    sender: 'AMZPAY',
  ),
  SampleSms(
    body: 'Refund of Rs.799 processed to Amazon Pay balance.',
    sender: 'AMZPAY',
  ),
  SampleSms(
    body: 'Wallet load successful: Rs.2,000 added via UPI.',
    sender: 'AMZPAY',
  ),
  SampleSms(
    body: 'Payment failed for Rs.350 at Merchant QR. Please retry.',
    sender: 'AMZPAY',
  ),
  SampleSms(
    body: 'OTP 442211 for Amazon Pay txn. Valid 15 min.',
    sender: 'AMZPAY',
  ),
  SampleSms(
    body: 'Cashback Rs.25 credited to your Amazon Pay balance.',
    sender: 'AMZPAY',
  ),

  // =========================
  // KARNATAKA BANK
  // =========================
  SampleSms(
    body:
        'Rs.3,450 debited from A/c XX7711 at POS D-MART BENGALURU. Avl Bal Rs.22,111',
    sender: 'KTKBANK',
  ),
  SampleSms(
    body: 'Salary credit INR 55,000 in A/c **7711 by NEFT.',
    sender: 'KTKBANK',
  ),
  SampleSms(
    body: 'UPI payment Rs.980 to shop@upi successful. Ref 61129111',
    sender: 'KTKBANK',
  ),
  SampleSms(
    body: 'ATM withdrawal Rs.2,000 from A/c XX7711. Bal Rs.20,111',
    sender: 'KTKBANK',
  ),
  SampleSms(body: 'OTP 118822 for txn verification.', sender: 'KTKBANK'),
  SampleSms(body: 'Cheque no 881221 cleared for Rs.12,500.', sender: 'KTKBANK'),

  // =========================
  // KERALA GRAMIN BANK
  // =========================
  SampleSms(
    body: 'A/c XX2234 debited Rs.750.00 via UPI. Ref 61199822',
    sender: 'KGBANK',
  ),
  SampleSms(
    body: 'Deposit of Rs.5,000 in A/c **2234. Avl Bal Rs.12,340',
    sender: 'KGBANK',
  ),
  SampleSms(
    body: 'Interest of Rs.42.11 credited to A/c XX2234',
    sender: 'KGBANK',
  ),
  SampleSms(body: 'ATM WDL Rs.1,000 from card ending 2234', sender: 'KGBANK'),
  SampleSms(body: 'OTP 331122 for secure banking.', sender: 'KGBANK'),
  SampleSms(
    body: 'Low balance: Your balance is below Rs.500',
    sender: 'KGBANK',
  ),

  // =========================
  // SARASWAT CO-OPERATIVE BANK
  // =========================
  SampleSms(
    body: 'Rs.1,850 DR from A/c XX9122 towards utility payment. Bal Rs.18,400',
    sender: 'SARASW',
  ),
  SampleSms(body: 'Salary credit Rs.38,000 in A/c **9122', sender: 'SARASW'),
  SampleSms(body: 'Cheque no 229911 passed for Rs.9,500', sender: 'SARASW'),
  SampleSms(
    body: 'UPI txn Rs.400 to vendor@oksbi successful.',
    sender: 'SARASW',
  ),
  SampleSms(body: 'OTP 991122 for card txn.', sender: 'SARASW'),
  SampleSms(body: 'Txn failed due to technical issue.', sender: 'SARASW'),

  // =========================
  // SOUTH INDIAN BANK
  // =========================
  SampleSms(
    body: 'Rs.2,999 debited from A/c XX6621 at AMAZON.IN. Bal Rs.11,220',
    sender: 'SIBANK',
  ),
  SampleSms(body: 'Cash deposit Rs.8,000 in A/c **6621.', sender: 'SIBANK'),
  SampleSms(
    body: 'UPI payment Rs.250 successful. Ref 61122331',
    sender: 'SIBANK',
  ),
  SampleSms(body: 'Interest Rs.65.21 credited.', sender: 'SIBANK'),
  SampleSms(body: 'OTP 229988 for transaction.', sender: 'SIBANK'),
  SampleSms(body: 'Low balance alert.', sender: 'SIBANK'),

  // =========================
  // STANDARD CHARTERED BANK
  // =========================
  SampleSms(
    body:
        'INR 12,500 spent on SCB Credit Card xx5511 at TAJ HOTELS. Avl Limit INR 2,10,000',
    sender: 'SCBANK',
  ),
  SampleSms(body: 'Salary credit INR 1,25,000 to A/c XX5511', sender: 'SCBANK'),
  SampleSms(
    body: 'International txn USD 250 at NETFLIX USA approved.',
    sender: 'SCBANK',
  ),
  SampleSms(body: 'OTP 778811 for secure txn.', sender: 'SCBANK'),
  SampleSms(body: 'Refund INR 1,250 to card xx5511.', sender: 'SCBANK'),
  SampleSms(
    body: 'Fraud alert: unusual transaction detected.',
    sender: 'SCBANK',
  ),

  // =========================
  // UCO BANK
  // =========================
  SampleSms(
    body: 'A/c XX1144 debited by Rs.450.00 at POS MEDICAL STORE',
    sender: 'UCOBNK',
  ),
  SampleSms(body: 'Salary Rs.22,000 credited in A/c **1144', sender: 'UCOBNK'),
  SampleSms(body: 'UPI txn Rs.199 to recharge@upi', sender: 'UCOBNK'),
  SampleSms(body: 'ATM withdrawal Rs.1,500', sender: 'UCOBNK'),
  SampleSms(body: 'OTP 221144', sender: 'UCOBNK'),
  SampleSms(body: 'Interest Rs.21 credited', sender: 'UCOBNK'),

  // =========================
  // UNION BANK OF INDIA
  // =========================
  SampleSms(
    body:
        'Cash withdrawal of Rs.4,000.00 from A/c XX1234 at ATM. Avl Bal: Rs.70,650.00.',
    sender: 'UNIONB',
  ),
  SampleSms(
    body: 'UPI transfer Rs.880 to kirana@oksbi successful.',
    sender: 'UNIONB',
  ),
  SampleSms(body: 'Salary credit Rs.52,000 in A/c **1234', sender: 'UNIONB'),
  SampleSms(body: 'Loan EMI Rs.6,200 deducted.', sender: 'UNIONB'),
  SampleSms(body: 'OTP 992211 for verification.', sender: 'UNIONB'),
  SampleSms(body: 'Cheque cleared for Rs.11,000', sender: 'UNIONB'),

  // =========================
  // YES BANK
  // =========================
  SampleSms(
    body:
        'INR 1,250 spent on YES BANK Card xx4411 @UPI_MERCHANT 24APR26 10:22. Avl Lmt INR 98,750',
    sender: 'YESBNK',
  ),
  SampleSms(
    body: 'UPI txn Rs.500 to food@paytm successful. Ref 61100221',
    sender: 'YESBNK',
  ),
  SampleSms(body: 'Salary credit Rs.65,000 in A/c **4411', sender: 'YESBNK'),
  SampleSms(body: 'Refund INR 799 to Card xx4411', sender: 'YESBNK'),
  SampleSms(body: 'OTP 118899 for secure purchase.', sender: 'YESBNK'),
  SampleSms(body: 'Low balance alert: Avl Bal Rs.99.50', sender: 'YESBNK'),
];
