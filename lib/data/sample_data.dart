class SampleSms {
  final String body;
  final String sender;
  final DateTime? date;

  const SampleSms({required this.body, required this.sender, this.date});
}

final List<SampleSms> sampleSms = [
  //  ── HDFC Bank ─────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'INR 2,500.00 debited from HDFC Bank A/c XX1234 on 01-Apr-25. UPI/PhonePe. Avl Bal INR 15,240.00. Not you? Call 18002676161.',
    sender: 'VM-HDFCBK-S',
  ),

  SampleSms(
    body:
        'INR 1,200.00 debited from HDFC Bank A/c XX1234 on 02-Apr-25. UPI/GooglePay. Avl Bal INR 14,040.00.',
    sender: 'AD-HDFCBANK-S',
  ),

  SampleSms(
    body:
        'INR 30,000.00 credited to HDFC Bank A/c XX1234 on 01-Apr-25. Salary. Avl Bal INR 45,240.00.',
    sender: 'JM-HDFCBN-S',
  ),

  SampleSms(
    body:
        'INR 1,999.00 spent on HDFC Bank Credit Card **5678 at SWIGGY on 03-Apr-2025. Available Limit: INR 43,002.00.',
    sender: 'BW-HDFCBK-S',
  ),

  SampleSms(
    body:
        'INR 10,000.00 credited to HDFC Bank Credit Card **5678 on 04-Apr-2025. Total Amt Due: INR 3,450.00.',
    sender: 'JM-HDFCBK-S',
  ),
  SampleSms(
    body:
        'OTP for your HDFC Bank transaction is 882911. Do not share it with anyone.',
    sender: 'AD-HDFCBK-S',
  ),
  SampleSms(
    body:
        'Your HDFC Bank Personal Loan of Rs. 2,00,000 is ready for disbursal. Click to apply.',
    sender: 'VM-HDFCBK-S',
  ),
  SampleSms(
    body:
        'Transaction of INR 1,250.00 failed on your HDFC Bank A/c XX1234. Insufficient Balance.',
    sender: 'BW-HDFCBK-S',
  ),
  SampleSms(
    body:
        'Grab 10% Cashback on HDFC Bank Cards at Flipkart Big Billion Days! Shop now.',
    sender: 'JM-HDFCBK-S',
  ),

  // ── SBI ───────────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Your A/c XX1234 debited by Rs 2,500.00 on 01Apr25. Avl Bal Rs.8,300.00. If not done by you, call 18004253800.',
    sender: 'VK-SBIINB',
  ),

  SampleSms(
    body:
        'Your A/c XX1234 debited by Rs 750.00 on 02Apr25. Avl Bal Rs.7,550.00. If not done by you, call 18004253800.',
    sender: 'JM-SBIINB-S',
  ),

  SampleSms(
    body:
        'Your A/c XX1234 credited by Rs 50,000.00 on 01Apr25. Avl Bal Rs.57,550.00. -SBI',
    sender: 'AD-SBIINB-S',
  ),

  SampleSms(
    body:
        'Your A/c XX1234 credited by Rs 15,000.00 on 03Apr25. Avl Bal Rs.72,550.00. -SBI',
    sender: 'BZ-SBIUPI-S',
  ),

  SampleSms(
    body:
        'Dear Customer, your A/c XX1234 is debited with Rs.10,000.00 on 02-Apr-25 by NEFT. Avl Bal Rs.62,550.00.',
    sender: 'BW-SBISMS-S',
  ),
  SampleSms(
    body: '662911 is the OTP for your SBI login. Do not disclose to anyone.',
    sender: 'AD-SBIINB-S',
  ),
  SampleSms(
    body:
        'Transaction of Rs. 500.00 on SBI Card ending 5678 declined due to technical error.',
    sender: 'VK-SBICRD-S',
  ),
  SampleSms(
    body:
        'Congratulations! You are eligible for an SBI Home Loan with interest starting at 8.5%.',
    sender: 'JM-SBISMS-S',
  ),
  SampleSms(
    body:
        'Enjoy zero processing fee on SBI Car Loans this festive season. Apply on YONO.',
    sender: 'BZ-SBIPOS-S',
  ),

  // ── ICICI Bank ────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'ICICI Bank Acct XX1234 debited for Rs 3,000.00 on 02-Apr-2025. Info: UPI/Zomato. Avl Bal INR 9,200.00. Dispute? Call 18001080.',
    sender: 'VK-ICICIB-S',
  ),

  SampleSms(
    body:
        'ICICI Bank Acct XX1234 debited for Rs 500.00 on 03-Apr-2025. Info: UPI/PhonePe. Avl Bal INR 8,700.00. Dispute? Call 18001080.',
    sender: 'JM-ICICIBANK-S',
  ),

  SampleSms(
    body:
        'ICICI Bank Acct XX1234 credited with INR 15,160.00 on 01-Apr-2025 by A/c linked to mobile XXXXXX79. Avl Bal INR 23,860.00.',
    sender: 'BZ-ICICIP-S',
  ),

  SampleSms(
    body:
        'ICICI Bank Acct XX1234 credited with INR 8,000.00 on 03-Apr-2025. IMPS Ref 411234567890. Avl Bal INR 31,860.00.',
    sender: 'BW-ICICIB-S',
  ),

  SampleSms(
    body:
        'Dear Customer, INR 1,500.00 debited from ICICI Bank A/C XX1234 on 04-Apr-2025. Info: UPI/Swiggy. Avl Bal INR 30,360.00.',
    sender: 'AD-ICICIB-S',
  ),
  SampleSms(
    body: '8829 is the OTP for your ICICI Bank net banking txn. Do not share.',
    sender: 'JM-ICICIB-S',
  ),
  SampleSms(
    body:
        'Transaction of INR 2,500.00 on ICICI Bank Card failed due to incorrect PIN.',
    sender: 'VK-ICICIB-S',
  ),
  SampleSms(
    body:
        'Pre-approved Personal Loan of Rs. 5 Lakhs for you! Apply on iMobile app.',
    sender: 'JM-ICICIBANK-S',
  ),

  // ── Axis Bank ─────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'INR 2,000.00 debited from Axis Bank A/c ending 1234 on 01-Apr-25. UPI Ref: 123456789012. Avl Bal INR 18,400.00.',
    sender: 'VM-AXISBK-S',
  ),

  SampleSms(
    body:
        'INR 450.00 debited from Axis Bank A/c ending 1234 on 02-Apr-25. UPI Ref: 234567890123. Avl Bal INR 17,950.00.',
    sender: 'JM-AXISBN-S',
  ),

  SampleSms(
    body:
        'INR 30,000.00 credited to Axis Bank A/c ending 1234 on 01-Apr-25. NEFT Ref: AXIB25091234567. Avl Bal INR 47,950.00.',
    sender: 'BZ-AXISBT-S',
  ),

  SampleSms(
    body:
        'INR 5,500.00 credited to Axis Bank A/c ending 1234 on 03-Apr-25. IMPS Ref: 345678901234. Avl Bal INR 53,450.00.',
    sender: 'BW-AXISBK-S',
  ),
  SampleSms(
    body: 'OTP for your Axis Bank transaction is 221099. Do not share.',
    sender: 'AD-AXISBK-S',
  ),
  SampleSms(
    body:
        'Your Axis Bank Credit Card payment is due. Pay now to avoid late fees.',
    sender: 'JM-AXISBN-S',
  ),
  SampleSms(
    body:
        'Declined: Txn of INR 1,000.00 at Amazon on Axis Bank Card XX1234. Exceeds limit.',
    sender: 'VK-AXISBK-S',
  ),

  // ── Kotak Mahindra Bank ───────────────────────────────────────────────────
  SampleSms(
    body:
        'Rs.3,200.00 has been debited from your Kotak A/c XX1234 on 01-Apr-25. Available Bal: Rs.16,800.00. Call 18002740110 if not done by you.',
    sender: 'VK-KOTAKB-S',
  ),

  SampleSms(
    body:
        'Rs.600.00 has been debited from your Kotak A/c XX1234 on 02-Apr-25. Available Bal: Rs.16,200.00. Call 18002740110 if not done by you.',
    sender: 'JM-KOTAKM-S',
  ),

  SampleSms(
    body:
        'Rs.20,000.00 has been credited to your Kotak A/c XX1234 on 01-Apr-25. Available Bal: Rs.36,200.00.',
    sender: 'BZ-KOTAKB-S',
  ),
  SampleSms(
    body: 'OTP for Kotak Bank mobile banking is 6652. Valid for 2 mins.',
    sender: 'JM-KOTAKM-S',
  ),
  SampleSms(
    body:
        'Failed: Rs. 200.00 debited from Kotak A/c XX1234 but reversed due to timeout.',
    sender: 'VK-KOTAKB-S',
  ),
  SampleSms(
    body: 'Check out the new Kotak 811 app for zero balance savings account.',
    sender: 'BW-KOTAKM-S',
  ),

  SampleSms(
    body:
        'Alert: INR 1,199.00 spent on Kotak Credit Card XX5678 at NETFLIX on 02-Apr-2025. Avl Limit: INR 78,801.00.',
    sender: 'BW-KOTAKM-S',
  ),

  // ── IndusInd Bank (Old) ─────────────────────────────────────────────────────
  SampleSms(
    body:
        'INR 4,500.00 has been debited from your IndusInd Bank A/c ending 1234 on 01-Apr-25. Avl Bal: INR 22,100.00.',
    sender: 'VK-INDUSB-S',
  ),

  SampleSms(
    body:
        'INR 12,000.00 has been credited to your IndusInd Bank A/c ending 1234 on 02-Apr-25. Avl Bal: INR 34,100.00.',
    sender: 'JM-INDSIN-S',
  ),
  SampleSms(
    body: 'OTP for IndusInd Bank net banking login is 2210. Valid for 5 mins.',
    sender: 'AD-INDUSB-S',
  ),
  SampleSms(
    body:
        'Failed: INR 500.00 debited from IndusInd Bank A/c XX1234 but rejected by merchant.',
    sender: 'VK-INDUSB-S',
  ),

  // ── IDFC FIRST Bank ───────────────────────────────────────────────────────
  SampleSms(
    body:
        'INR 1,800.00 debited from IDFC FIRST Bank A/c XX1234 on 01-Apr-25. UPI/GooglePay. Avl Bal INR 14,650.00. Not you? Call 18008899.',
    sender: 'VK-IDFCFB-S',
  ),

  SampleSms(
    body:
        'INR 7,000.00 credited to IDFC FIRST Bank A/c XX1234 on 02-Apr-25. IMPS Ref 512345678901. Avl Bal INR 21,650.00.',
    sender: 'JM-IDFCFS-S',
  ),
  SampleSms(
    body: 'OTP for IDFC FIRST Bank transaction is 8821. Do not share.',
    sender: 'AD-IDFCFB-S',
  ),
  SampleSms(
    body:
        'Your IDFC FIRST Bank Loan statement for Mar-25 is available for download.',
    sender: 'VK-IDFCFB-S',
  ),

  // ── PNB ───────────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Your A/c XX1234 debited Rs.5,000.00 on 01-04-2025 by UPI. Avl Bal Rs.11,230.00. For dispute call 18001802222.',
    sender: 'VK-PNBSMS-S',
  ),

  SampleSms(
    body:
        'Your A/c XX1234 credited Rs.18,000.00 on 01-04-2025. Avl Bal Rs.29,230.00. -Punjab National Bank',
    sender: 'JM-PNBBNK-S',
  ),
  SampleSms(
    body: '882191 is your OTP for PNB net banking. Do not disclose.',
    sender: 'AD-PNBSMS-S',
  ),
  SampleSms(
    body:
        'Transaction of Rs. 1,000.00 on PNB A/c XX1234 failed. Network issue.',
    sender: 'VK-PNBSMS-S',
  ),

  // ── Canara Bank ───────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Dear Customer, A/c No XX1234 is debited with INR 2,000.00 on 01-04-2025. Avl Bal: INR 9,540.00. -Canara Bank.',
    sender: 'VK-CANBK-S',
  ),

  SampleSms(
    body:
        'Dear Customer, A/c No XX1234 is credited with INR 10,000.00 on 02-04-2025. Avl Bal: INR 19,540.00. -Canara Bank.',
    sender: 'VM-CANARA-S',
  ),
  SampleSms(
    body: 'OTP for Canara Bank transaction is 6629. Valid for 180 seconds.',
    sender: 'AD-CANBK-S',
  ),
  SampleSms(
    body:
        'Get a Canara Bank Gold Loan at attractive interest rates. Visit branch.',
    sender: 'VK-CANBK-S',
  ),

  // ── Bank of Baroda ────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Your BOB A/c XX1234 debited INR 3,500.00 on 01-Apr-25 via UPI. Avl Bal INR 6,700.00. Not done by you? Call 18005700.',
    sender: 'VK-BOBTXN-S',
  ),

  SampleSms(
    body:
        'Your BOB A/c XX1234 credited INR 22,000.00 on 02-Apr-25. Avl Bal INR 28,700.00. -Bank of Baroda.',
    sender: 'JM-BOBBNK-S',
  ),
  SampleSms(
    body: '8821 is the OTP for your Bank of Baroda UPI registration.',
    sender: 'AD-BOBTXN-S',
  ),
  SampleSms(
    body: 'Your BOB Home Loan account XX5678 has been credited with subsidy.',
    sender: 'VK-BOBTXN-S',
  ),

  // ── Federal Bank ──────────────────────────────────────────────────────────
  SampleSms(
    body:
        'INR 1,100.00 debited from Federal Bank A/c XX1234 on 01-Apr-2025. UPI Txn. Avl Bal: INR 5,430.00.',
    sender: 'VK-FEDBK-S',
  ),

  SampleSms(
    body:
        'INR 9,000.00 credited to Federal Bank A/c XX1234 on 02-Apr-2025. NEFT. Avl Bal: INR 14,430.00.',
    sender: 'JM-FEDBNK-S',
  ),
  SampleSms(
    body: 'OTP for Federal Bank txn is 221088. Valid for 5 mins.',
    sender: 'AD-FEDBK-S',
  ),
  SampleSms(
    body: 'Your Federal Bank Gold Loan interest is due. Pay on FedMobile.',
    sender: 'VK-FEDBK-S',
  ),

  // ── HSBC ──────────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Rs.2,750.00 debited from HSBC A/c XX1234 on 01-Apr-25. Avl Bal Rs.31,250.00. Queries? Call 18002676161.',
    sender: 'VK-HSBCIN-S',
  ),

  SampleSms(
    body:
        'Rs.40,000.00 credited to HSBC A/c XX1234 on 02-Apr-25. Avl Bal Rs.71,250.00.',
    sender: 'JM-HSBCIN-S',
  ),
  SampleSms(
    body: 'OTP for your HSBC transaction is 9982. Do not share.',
    sender: 'AD-HSBCIN-S',
  ),
  SampleSms(
    body: 'Your HSBC Credit Card XX5678 is overlimit. Pay now.',
    sender: 'VK-HSBCIN-S',
  ),

  // --- INDUSIND BANK ---
  SampleSms(
    body:
        'Debited INR 1,500.00 from your IndusInd Bank A/c ending 1234 on 15-May-26. Avl Bal: INR 45,600.00.',
    sender: 'VK-INDUSB-S',
  ),
  SampleSms(
    body:
        'INR 25,000.00 has been credited to your IndusInd Bank A/c ending 1234 on 16-May-26. Avl Bal: INR 70,600.00.',
    sender: 'JM-INDUSB-S',
  ),
  SampleSms(
    body: 'purchase of Rs. 1,250.00 at AMAZON using IndusInd Bank Card.',
    sender: 'BZ-INDUSB-S',
  ),
  SampleSms(
    body:
        'Avl BAL of INR 68,350.00 after debit of INR 2,250.00 in account XX1234.',
    sender: 'BW-INDUSB-S',
  ),
  SampleSms(
    body:
        'INR 500.00 has been debited from your IndusInd Bank A/c ending 1234 for UPI. Avl Bal: INR 67,850.00.',
    sender: 'AD-INDUSB-S',
  ),
  SampleSms(
    body: 'OTP for IndusInd Bank transaction is 6621. Do not share.',
    sender: 'JM-INDUSB-S',
  ),
  SampleSms(
    body: 'Your IndusInd Bank Loan A/c XX5678 is pre-approved for top-up.',
    sender: 'VK-INDUSB-S',
  ),

  // --- JK BANK ---
  SampleSms(
    body:
        'A/c XX1234 debited by INR 3,500.00 on 12-Apr-26 towards Electricity Bill. Available Bal is INR 21,500.00.',
    sender: 'VK-JKBANK-S',
  ),
  SampleSms(
    body: 'A/c XX1234 credited by INR 15,000.00 via NEFT from EMPLOYER.',
    sender: 'JM-JKBANK-S',
  ),
  SampleSms(
    body: 'transferred INR 4,200.00 to A/C XX5678. Avl Bal Rs. 17,300.00.',
    sender: 'BW-JKBANK-S',
  ),
  SampleSms(
    body:
        'A/c XX1234 debited by INR 800.00 on 14-Apr-26 at POS. Available Bal is INR 16,500.00.',
    sender: 'AD-JKBANK-S',
  ),
  SampleSms(
    body:
        'credited INR 5,000.00 to A/C XX1234 via IMPS. Avl Bal Rs. 21,500.00.',
    sender: 'JM-JKBANK-S',
  ),
  SampleSms(
    body: 'OTP for J&K Bank net banking is 1109. Valid for 10 mins.',
    sender: 'AD-JKBANK-S',
  ),
  SampleSms(
    body: 'Your J&K Bank KCC loan interest is due. Visit branch.',
    sender: 'VK-JKBANK-S',
  ),

  // --- JIOPAY ---
  SampleSms(
    body:
        'Recharge successful to Jio Number: 9876543210. Rs. 749.00. Transaction ID: 1122334455.',
    sender: 'VK-JIOPAY-S',
  ),
  SampleSms(
    body:
        'payment successful to Zomato. Rs. 350.00. Transaction ID: 5566778899.',
    sender: 'JM-JIOPAY-S',
  ),
  SampleSms(
    body: 'bill payment successful. Rs. 1,250.00. Transaction ID: 9988776655.',
    sender: 'BZ-JIOPAY-S',
  ),
  SampleSms(
    body:
        'Recharge successful to Jio Number: 8765432109. Rs. 199.00. Transaction ID: 2233445566.',
    sender: 'BW-JIOPAY-S',
  ),
  SampleSms(
    body:
        'payment successful to Swiggy. Rs. 420.00. Transaction ID: 3344556677.',
    sender: 'JM-JIOPAY-S',
  ),
  SampleSms(
    body: 'OTP for JioPay login is 665211. Do not share.',
    sender: 'AD-JIOPAY-S',
  ),
  SampleSms(
    body:
        'Failed: JioPay payment of Rs. 350.00 at Zomato failed. Amt will be reversed.',
    sender: 'VK-JIOPAY-S',
  ),
  SampleSms(
    body: 'Get flat Rs. 50 cashback on your next JioPay recharge of Rs. 299.',
    sender: 'JM-JIOPAY-S',
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
    sender: 'JM-KGBANK-S',
  ),
  SampleSms(
    body: 'Rs. 350.00 debited from A/C XX1234 via UPI. Avl Bal: Rs. 17,150.00.',
    sender: 'BZ-KGBANK-S',
  ),
  SampleSms(
    body:
        'Rs. 8,000.00 credited to A/C XX1234 via NEFT. Avl Bal: Rs. 25,150.00.',
    sender: 'BW-KGBANK-S',
  ),
  SampleSms(
    body:
        'withdrawn Rs. 2,000.00 from A/C XX1234 at ATM. Avl Bal: Rs. 23,150.00.',
    sender: 'AD-KGBANK-S',
  ),

  // --- SARASWAT CO-OPERATIVE BANK ---
  SampleSms(
    body:
        'A/c XX1234 debited for Rs. 4,500.00 on 01-Jul-26. Avl Bal: Rs. 45,000.00.',
    sender: 'VK-SRSWTB-S',
  ),
  SampleSms(
    body:
        'A/c XX1234 credited for Rs. 20,000.00 on 02-Jul-26. Avl Bal: Rs. 65,000.00.',
    sender: 'JM-SRSWTB-S',
  ),
  SampleSms(
    body:
        'Rs. 1,200.00 debited from A/c XX1234 for POS txn. Avl Bal: Rs. 63,800.00.',
    sender: 'BZ-SRSWTB-S',
  ),
  SampleSms(
    body:
        'Rs. 3,500.00 credited to A/c XX1234 via IMPS. Avl Bal: Rs. 67,300.00.',
    sender: 'BW-SRSWTB-S',
  ),
  SampleSms(
    body: 'Rs. 500.00 debited from A/c XX1234 via UPI. Avl Bal: Rs. 66,800.00.',
    sender: 'AD-SRSWTB-S',
  ),

  // --- SOUTH INDIAN BANK ---
  SampleSms(
    body:
        'Rs. 2,800.00 debited from your A/c XX1234 on 15-Aug-26. Avl Bal: Rs. 28,500.00.',
    sender: 'VK-SIBNK-S',
  ),
  SampleSms(
    body:
        'Rs. 15,000.00 credited to your A/c XX1234 on 16-Aug-26 via NEFT. Avl Bal: Rs. 43,500.00.',
    sender: 'JM-SIBNK-S',
  ),
  SampleSms(
    body:
        'UPI txn of Rs. 650.00 debited from A/c XX1234. Avl Bal: Rs. 42,850.00.',
    sender: 'BZ-SIBNK-S',
  ),
  SampleSms(
    body: 'IMPS credit of Rs. 4,000.00 to A/c XX1234. Avl Bal: Rs. 46,850.00.',
    sender: 'BW-SIBNK-S',
  ),
  SampleSms(
    body:
        'ATM withdrawal of Rs. 3,000.00 from A/c XX1234. Avl Bal: Rs. 43,850.00.',
    sender: 'AD-SIBNK-S',
  ),

  // --- STANDARD CHARTERED BANK ---
  SampleSms(
    body:
        'INR 5,500.00 debited from your A/c XX1234 on 05-Sep-26. Avl Bal: INR 1,55,000.00.',
    sender: 'VK-STANCB-S',
  ),
  SampleSms(
    body:
        'INR 85,000.00 credited to your A/c XX1234 on 06-Sep-26. Avl Bal: INR 2,40,000.00.',
    sender: 'JM-STANCB-S',
  ),
  SampleSms(
    body:
        'spent INR 2,500.00 on your Credit Card XX9999. Avl limit: INR 1,47,500.00.',
    sender: 'BZ-STANCB-S',
  ),
  SampleSms(
    body:
        'INR 1,200.00 debited from A/c XX1234 via UPI. Avl Bal: INR 2,38,800.00.',
    sender: 'BW-STANCB-S',
  ),
  SampleSms(
    body:
        'INR 12,000.00 credited to A/c XX1234 via NEFT. Avl Bal: INR 2,50,800.00.',
    sender: 'AD-STANCB-S',
  ),

  // --- UCO BANK ---
  SampleSms(
    body:
        'A/c XX1234 is debited with Rs. 1,500.00 on 10-Oct-26. Available Balance Rs. 18,500.00.',
    sender: 'VK-UCOBNK-S',
  ),
  SampleSms(
    body:
        'A/c XX1234 is credited with Rs. 10,000.00 on 11-Oct-26. Available Balance Rs. 28,500.00.',
    sender: 'JM-UCOBNK-S',
  ),
  SampleSms(
    body:
        'Rs. 450.00 debited from A/c XX1234 via UPI. Available Balance Rs. 28,050.00.',
    sender: 'BZ-UCOBNK-S',
  ),
  SampleSms(
    body:
        'Rs. 5,000.00 credited to A/c XX1234 via IMPS. Available Balance Rs. 33,050.00.',
    sender: 'BW-UCOBNK-S',
  ),
  SampleSms(
    body:
        'ATM withdrawal of Rs. 2,000.00 from A/c XX1234. Available Balance Rs. 31,050.00.',
    sender: 'AD-UCOBNK-S',
  ),

  // --- UNION BANK OF INDIA ---
  SampleSms(
    body:
        'Rs. 3,200.00 debited from your A/c XX1234 on 20-Nov-26. Avl Bal: Rs. 42,500.00.',
    sender: 'VK-UNIONB-S',
  ),
  SampleSms(
    body:
        'Rs. 25,000.00 credited to your A/c XX1234 on 21-Nov-26 via NEFT. Avl Bal: Rs. 67,500.00.',
    sender: 'JM-UNIONB-S',
  ),
  SampleSms(
    body:
        'UPI payment of Rs. 850.00 debited from A/c XX1234. Avl Bal: Rs. 66,650.00.',
    sender: 'BZ-UNIONB-S',
  ),
  SampleSms(
    body: 'IMPS credit of Rs. 8,000.00 to A/c XX1234. Avl Bal: Rs. 74,650.00.',
    sender: 'BW-UNIONB-S',
  ),
  SampleSms(
    body:
        'Cash withdrawal of Rs. 4,000.00 from A/c XX1234 at ATM. Avl Bal: Rs. 70,650.00.',
    sender: 'AD-UNIONB-S',
  ),

  // --- YES BANK ---
  SampleSms(
    body:
        'INR 4,500.00 debited from your YES BANK A/c XX1234 on 05-Dec-26. Avl Bal: INR 55,000.00.',
    sender: 'VK-YESBNK-S',
  ),
  SampleSms(
    body:
        'INR 35,000.00 credited to your YES BANK A/c XX1234 on 06-Dec-26. Avl Bal: INR 90,000.00.',
    sender: 'JM-YESBNK-S',
  ),
  SampleSms(
    body:
        'spent INR 1,500.00 on your YES BANK Credit Card XX8888. Avl limit: INR 73,500.00.',
    sender: 'BZ-YESBNK-S',
  ),
  SampleSms(
    body: 'INR 650.00 debited from A/c XX1234 via UPI. Avl Bal: INR 89,350.00.',
    sender: 'BW-YESBNK-S',
  ),
  SampleSms(
    body:
        'INR 15,000.00 credited to A/c XX1234 via NEFT. Avl Bal: INR 1,04,350.00.',
    sender: 'AD-YESBNK-S',
  ),

  // =========================
  // INDUSIND BANK
  // =========================
  SampleSms(
    body:
        'Rs.2,450.00 debited from A/c XX4512 on 24-04-26 towards BIG BAZAAR. Avl Bal: Rs.56,781.90',
    sender: 'VK-INDUSB-S',
  ),
  SampleSms(
    body:
        'Your IndusInd Credit Card xx7821 used for INR 9,999.00 at AMAZON PAY INDIA on 24/04/26 18:14. Avl Limit: INR 1,20,001.00',
    sender: 'JM-INDUSB-S',
  ),
  SampleSms(
    body:
        'UPI txn of Rs.1,250.00 from A/c **4512 to priya@okhdfcbank successful. Ref: 611492784221',
    sender: 'BZ-INDUSB-S',
  ),
  SampleSms(
    body:
        'Cash withdrawal of Rs.10,000 from ATM using Debit Card xx4512 at MUMBAI. Avl Bal Rs.46,781.90',
    sender: 'INDUSB',
  ),
  SampleSms(
    body:
        'Salary of INR 75,000.00 credited to A/c XX4512 via NEFT from INFOSOFT PVT LTD.',
    sender: 'JM-INDUSB-S',
  ),
  SampleSms(
    body:
        'OTP 662191 for online transaction of Rs.4,800 on your IndusInd card. Valid 5 mins.',
    sender: 'BZ-INDUSB-S',
  ),

  // =========================
  // JK BANK
  // =========================
  SampleSms(
    body:
        'A/c XX8831 debited by Rs.3,200.00 on 24APR26 at RELIANCE SMART. Bal: Rs.18,220.50',
    sender: 'VK-JKBANK-S',
  ),
  SampleSms(
    body:
        'Credit of INR 48,500.00 in A/c **8831 by SALARY transfer. Available Balance Rs.66,720.50',
    sender: 'JM-JKBANK-S',
  ),
  SampleSms(
    body:
        'UPI transfer of Rs.850 to amit@ybl from A/c XX8831. UTR 611482938211',
    sender: 'BZ-JKBANK-S',
  ),
  SampleSms(
    body: 'ATM WDL Rs.5,000 from A/c **8831 at Srinagar ATM. Bal Rs.13,220.50',
    sender: 'BW-JKBANK-S',
  ),
  SampleSms(
    body: 'Txn declined on card xx8831 due to daily withdrawal limit exceeded.',
    sender: 'AD-JKBANK-S',
  ),
  SampleSms(
    body: 'OTP for J&K Bank txn is 104228. Do not share.',
    sender: 'JD-JKBANK-S',
  ),

  // =========================
  // JIOPAY
  // =========================
  SampleSms(
    body:
        'Rs.399.00 paid via JioPay to MYJIO RECHARGE. Txn ID: JP611492001. Wallet Bal Rs.1,220.00',
    sender: 'JM-JIOPAY-S',
  ),
  SampleSms(
    body: 'Money added Rs.2,000.00 to JioPay wallet using UPI. Ref 1182011',
    sender: 'BZ-JIOPAY-S',
  ),
  SampleSms(
    body:
        'Payment of Rs.799 to AJIO successful via JioPay QR. Merchant: AJIO STORE',
    sender: 'BW-JIOPAY-S',
  ),
  SampleSms(
    body: 'Refund of Rs.399 initiated to JioPay Wallet. Will reflect in 2 hrs.',
    sender: 'AD-JIOPAY-S',
  ),
  SampleSms(
    body: 'OTP 928441 for JioPay login. Valid 10 min.',
    sender: 'JD-JIOPAY-S',
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
    sender: 'JM-JIOPBK-S',
  ),
  SampleSms(
    body: 'UPI payment Rs.250 to tea@oksbi from A/c **9912 successful.',
    sender: 'BZ-JIOPBK-S',
  ),
  SampleSms(
    body: 'Cashback of Rs.50 received in Jio Payments Bank account.',
    sender: 'BW-JIOPBK-S',
  ),
  SampleSms(
    body: 'Debit alert: Rs.799 towards recharge from A/c XX9912. Bal Rs.4,801',
    sender: 'AD-JIOPBK-S',
  ),
  SampleSms(
    body: 'OTP 229911 for transaction authentication.',
    sender: 'JD-JIOPBK-S',
  ),
  SampleSms(
    body:
        'Low balance alert: Available balance in your Jio PB account is Rs.95 only.',
    sender: 'BZ-JIOPBK-S',
  ),

  // =========================
  // AMAZON PAY
  // =========================
  SampleSms(
    body:
        'Amazon Pay: Rs.1,499 paid to ZOMATO using balance. Order Ref APY6112991',
    sender: 'JM-AMZPAY-S',
  ),
  SampleSms(
    body: 'Refund of Rs.799 processed to Amazon Pay balance.',
    sender: 'BZ-AMZPAY-S',
  ),
  SampleSms(
    body: 'Wallet load successful: Rs.2,000 added via UPI.',
    sender: 'BW-AMZPAY-S',
  ),
  SampleSms(
    body: 'Payment failed for Rs.350 at Merchant QR. Please retry.',
    sender: 'AD-AMZPAY-S',
  ),
  SampleSms(
    body: 'Cashback Rs.25 credited to your Amazon Pay balance.',
    sender: 'JM-AMZPAY-S',
  ),
  SampleSms(
    body: 'OTP for Amazon Pay login is 112299. Do not share.',
    sender: 'AD-AMZPAY-S',
  ),
  SampleSms(
    body: 'Load your Amazon Pay wallet and get 5% back on utility bills.',
    sender: 'VK-AMZPAY-S',
  ),

  // =========================
  // KARNATAKA BANK
  // =========================
  SampleSms(
    body:
        'Rs.3,450 debited from A/c XX7711 at POS D-MART BENGALURU. Avl Bal Rs.22,111',
    sender: 'VK-KTKBANK-S',
  ),
  SampleSms(
    body: 'Salary credit INR 55,000 in A/c **7711 by NEFT.',
    sender: 'JM-KTKBANK-S',
  ),
  SampleSms(
    body: 'UPI payment Rs.980 to shop@upi successful. Ref 61129111',
    sender: 'BZ-KTKBANK-S',
  ),
  SampleSms(
    body: 'ATM withdrawal Rs.2,000 from A/c XX7711. Bal Rs.20,111',
    sender: 'BW-KTKBANK-S',
  ),
  SampleSms(body: 'OTP 118822 for txn verification.', sender: 'JD-KTKBANK-S'),
  SampleSms(
    body: 'Cheque no 881221 cleared for Rs.12,500.',
    sender: 'JM-KTKBANK-S',
  ),
  SampleSms(
    body: 'OTP for Karnataka Bank transaction is 6621. Do not share.',
    sender: 'AD-KTKBANK-S',
  ),
  SampleSms(
    body: 'Your Karnataka Bank Loan A/c XX5678 interest is due.',
    sender: 'VK-KTKBANK-S',
  ),

  // =========================
  // KERALA GRAMIN BANK
  // =========================
  SampleSms(
    body: 'A/c XX2234 debited Rs.750.00 via UPI. Ref 61199822',
    sender: 'VK-KGBANK-S',
  ),
  SampleSms(
    body: 'Deposit of Rs.5,000 in A/c **2234. Avl Bal Rs.12,340',
    sender: 'JM-KGBANK-S',
  ),
  SampleSms(
    body: 'Interest of Rs.42.11 credited to A/c XX2234',
    sender: 'BZ-KGBANK-S',
  ),
  SampleSms(
    body: 'ATM WDL Rs.1,000 from card ending 2234',
    sender: 'BW-KGBANK-S',
  ),
  SampleSms(body: 'OTP 331122 for secure banking.', sender: 'JD-KGBANK-S'),
  SampleSms(
    body: 'Low balance: Your balance is below Rs.500',
    sender: 'JM-KGBANK-S',
  ),
  SampleSms(
    body: 'OTP for Kerala Gramin Bank is 8829. Valid for 5 mins.',
    sender: 'AD-KGBANK-S',
  ),
  SampleSms(
    body: 'Visit Kerala Gramin Bank for attractive Gold Loan schemes.',
    sender: 'VK-KGBANK-S',
  ),

  // =========================
  // SARASWAT CO-OPERATIVE BANK
  // =========================
  SampleSms(
    body: 'Rs.1,850 DR from A/c XX9122 towards utility payment. Bal Rs.18,400',
    sender: 'VK-SARASW-S',
  ),
  SampleSms(
    body: 'Salary credit Rs.38,000 in A/c **9122',
    sender: 'JM-SARASW-S',
  ),
  SampleSms(
    body: 'Cheque no 229911 passed for Rs.9,500',
    sender: 'BZ-SARASW-S',
  ),
  SampleSms(
    body: 'UPI txn Rs.400 to vendor@oksbi successful.',
    sender: 'BW-SARASW-S',
  ),
  SampleSms(body: 'OTP 991122 for card txn.', sender: 'JD-SARASW-S'),
  SampleSms(body: 'Txn failed due to technical issue.', sender: 'JM-SARASW-S'),
  SampleSms(
    body: 'OTP for Saraswat Bank txn is 2210. Do not share.',
    sender: 'AD-SARASW-S',
  ),
  SampleSms(
    body: 'Your Saraswat Bank Home Loan interest rate has been revised.',
    sender: 'VK-SARASW-S',
  ),

  // =========================
  // SOUTH INDIAN BANK
  // =========================
  SampleSms(
    body: 'Rs.2,999 debited from A/c XX6621 at AMAZON.IN. Bal Rs.11,220',
    sender: 'VK-SIBNK-S',
  ),
  SampleSms(body: 'Cash deposit Rs.8,000 in A/c **6621.', sender: 'JM-SIBNK-S'),
  SampleSms(
    body: 'UPI payment Rs.250 successful. Ref 61122331',
    sender: 'BZ-SIBNK-S',
  ),
  SampleSms(body: 'Interest Rs.65.21 credited.', sender: 'BW-SIBNK-S'),
  SampleSms(body: 'OTP 229988 for transaction.', sender: 'JD-SIBNK-S'),
  SampleSms(body: 'Low balance alert.', sender: 'BZ-SIBNK-S'),
  SampleSms(
    body: 'OTP for South Indian Bank txn is 9982. Do not share.',
    sender: 'AD-SIBNK-S',
  ),
  SampleSms(
    body: 'Get a SIB Personal Loan at just 10.5% interest. Apply now.',
    sender: 'VK-SIBNK-S',
  ),

  // =========================
  // STANDARD CHARTERED BANK
  // =========================
  SampleSms(
    body:
        'INR 12,500 spent on SCB Credit Card xx5511 at TAJ HOTELS. Avl Limit INR 2,10,000',
    sender: 'VK-SCBANK-S',
  ),
  SampleSms(
    body: 'Salary credit INR 1,25,000 to A/c XX5511',
    sender: 'JM-SCBANK-S',
  ),
  SampleSms(
    body: 'International txn USD 250 at NETFLIX USA approved.',
    sender: 'BZ-SCBANK-S',
  ),
  SampleSms(body: 'OTP 778811 for secure txn.', sender: 'JD-SCBANK-S'),
  SampleSms(body: 'Refund INR 1,250 to card xx5511.', sender: 'BW-SCBANK-S'),
  SampleSms(
    body: 'Fraud alert: unusual transaction detected.',
    sender: 'AD-SCBANK-S',
  ),
  SampleSms(
    body: 'OTP for your Standard Chartered txn is 6621. Do not share.',
    sender: 'AD-SCBANK-S',
  ),
  SampleSms(
    body: 'Your SCB Credit Card XX5678 statement for Mar-25 is ready.',
    sender: 'VK-SCBANK-S',
  ),

  // =========================
  // UCO BANK
  // =========================
  SampleSms(
    body: 'A/c XX1144 debited by Rs.450.00 at POS MEDICAL STORE',
    sender: 'VK-UCOBNK-S',
  ),
  SampleSms(
    body: 'Salary Rs.22,000 credited in A/c **1144',
    sender: 'JM-UCOBNK-S',
  ),
  SampleSms(body: 'UPI txn Rs.199 to recharge@upi', sender: 'BZ-UCOBNK-S'),
  SampleSms(body: 'ATM withdrawal Rs.1,500', sender: 'BW-UCOBNK-S'),
  SampleSms(body: 'OTP 221144', sender: 'JD-UCOBNK-S'),
  SampleSms(body: 'Interest Rs.21 credited', sender: 'JM-UCOBNK-S'),
  SampleSms(
    body: 'OTP for UCO Bank net banking is 8821. Valid for 5 mins.',
    sender: 'AD-UCOBNK-S',
  ),
  SampleSms(
    body: 'Pre-approved UCO Bank Personal Loan of Rs. 1 Lakh for you.',
    sender: 'VK-UCOBNK-S',
  ),

  // =========================
  // UNION BANK OF INDIA
  // =========================
  SampleSms(
    body:
        'Cash withdrawal of Rs.4,000.00 from A/c XX1234 at ATM. Avl Bal: Rs.70,650.00.',
    sender: 'VK-UNIONB-S',
  ),
  SampleSms(
    body: 'UPI transfer Rs.880 to kirana@oksbi successful.',
    sender: 'JM-UNIONB-S',
  ),
  SampleSms(
    body: 'Salary credit Rs.52,000 in A/c **1234',
    sender: 'BZ-UNIONB-S',
  ),
  SampleSms(body: 'Loan EMI Rs.6,200 deducted.', sender: 'BW-UNIONB-S'),
  SampleSms(body: 'OTP 992211 for verification.', sender: 'JD-UNIONB-S'),
  SampleSms(body: 'Cheque cleared for Rs.11,000', sender: 'JM-UNIONB-S'),
  SampleSms(
    body: 'OTP for Union Bank of India txn is 221088. Do not share.',
    sender: 'AD-UNIONB-S',
  ),
  SampleSms(
    body: 'Your Union Bank Loan A/c XX5678 interest is due. Pay on Vyom app.',
    sender: 'VK-UNIONB-S',
  ),

  // =========================
  // YES BANK
  // =========================
  SampleSms(
    body:
        'INR 1,250 spent on YES BANK Card xx4411 @UPI_MERCHANT 24APR26 10:22. Avl Lmt INR 98,750',
    sender: 'VK-YESBNK-S',
  ),
  SampleSms(
    body: 'UPI txn Rs.500 to food@paytm successful. Ref 61100221',
    sender: 'JM-YESBNK-S',
  ),
  SampleSms(
    body: 'Salary credit Rs.65,000 in A/c **4411',
    sender: 'BZ-YESBNK-S',
  ),
  SampleSms(body: 'Refund INR 799 to Card xx4411', sender: 'BW-YESBNK-S'),
  SampleSms(body: 'OTP 118899 for secure purchase.', sender: 'JD-YESBNK-S'),
  SampleSms(body: 'Low balance alert: Avl Bal Rs.99.50', sender: 'JM-YESBNK-S'),
  SampleSms(
    body: 'OTP for YES BANK net banking is 662911. Valid for 5 mins.',
    sender: 'AD-YESBNK-S',
  ),
  SampleSms(
    body: 'Upgrade your YES BANK Credit Card and get extra reward points!',
    sender: 'VK-YESBNK-S',
  ),

  // --- Varied Headers for Robustness Testing ---
  SampleSms(
    body:
        'INR 1,200.00 debited from HDFC Bank A/c XX1234 on 30-Apr-25. UPI Ref: 123456.',
    sender: 'AD-HDFCBK-S',
  ),
  SampleSms(
    body:
        'INR 500.00 debited from HDFC Bank A/c XX1234 on 01-May-25. Info: Swiggy.',
    sender: 'VK-HDFCBANK-S',
  ),
  SampleSms(
    body:
        'INR 30,000.00 credited to HDFC Bank A/c XX1234 on 01-May-25. Salary.',
    sender: 'JM-HDFCBN-S',
  ),
  SampleSms(
    body:
        'Your A/c XX1234 debited by Rs 2,500.00 on 30Apr25. Avl Bal Rs.5,800.00.',
    sender: 'VK-SBIINB-S',
  ),
  SampleSms(
    body: 'Your A/c XX1234 credited by Rs 10,000.00 on 01May25. Ref: 987654.',
    sender: 'JM-SBICRD-S',
  ),
  SampleSms(
    body: 'Your A/c XX1234 debited by Rs 150.00 on 01May25. UPI: tea@upi.',
    sender: 'BZ-SBIPOS-S',
  ),
  SampleSms(
    body:
        'ICICI Bank Acct XX1234 debited for Rs 3,000.00 on 30-Apr-2025. Info: Zomato.',
    sender: 'VK-ICICIB-S',
  ),
  SampleSms(
    body:
        'ICICI Bank Acct XX1234 credited with INR 5,000.00 on 01-May-2025. IMPS.',
    sender: 'JM-ICICIBANK-S',
  ),
  SampleSms(
    body:
        'INR 2,000.00 debited from Axis Bank A/c ending 1234 on 30-Apr-25. UPI Ref: 112233.',
    sender: 'VK-AXISBK-S',
  ),
  SampleSms(
    body:
        'INR 10,000.00 credited to Axis Bank A/c ending 1234 on 01-May-25. NEFT.',
    sender: 'JM-AXISBN-S',
  ),
  SampleSms(
    body: 'Your BOB A/c XX1234 debited INR 1,500.00 on 30-Apr-25 via UPI.',
    sender: 'VK-BOBTXN-S',
  ),
  SampleSms(
    body: 'Your BOB A/c XX1234 credited INR 25,000.00 on 01-May-25. Salary.',
    sender: 'JM-BOBBNK-S',
  ),
  SampleSms(
    body:
        'Rs.1,200.00 has been debited from your Kotak A/c XX1234 on 30-Apr-25.',
    sender: 'VK-KOTAKB-S',
  ),
  SampleSms(
    body:
        'Rs.50,000.00 has been credited to your Kotak A/c XX1234 on 01-May-25.',
    sender: 'JM-KOTAKM-S',
  ),
  SampleSms(
    body:
        'INR 4,500.00 debited from IndusInd Bank A/c ending 4512 on 30-Apr-25.',
    sender: 'VK-INDUSB-S',
  ),
  SampleSms(
    body: 'INR 1,250.00 spent on YES BANK Card xx4411 @UPI_MERCHANT 30APR26.',
    sender: 'VK-YESBNK-S',
  ),
  SampleSms(
    body: 'INR 10,000.00 credited to YES BANK A/c XX1234 on 01-May-26.',
    sender: 'JM-YESBNK-S',
  ),
  SampleSms(
    body: 'Rs. 2,800.00 debited from your PNB A/c XX1234 on 30-Apr-25.',
    sender: 'VK-PNBSMS-S',
  ),
  SampleSms(
    body: 'Rs. 15,000.00 credited to your PNB A/c XX1234 on 01-May-25.',
    sender: 'JM-PNBBNK-S',
  ),
  SampleSms(
    body: 'Rs. 3,200.00 debited from your Union Bank A/c XX1234 on 30-Apr-25.',
    sender: 'VK-UNIONB-S',
  ),
  SampleSms(
    body: 'Rs. 25,000.00 credited to your Union Bank A/c XX1234 on 01-May-25.',
    sender: 'JM-UNIONB-S',
  ),
  SampleSms(
    body: 'Txn failed for Rs.1,250 at Merchant due to network timeout.',
    sender: 'JM-JIOPAY-S',
  ),

  // ── HSBC ──────────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'HSBC A/c XX1234 debited by INR 1,500.00 on 30/04/26. Info: Swiggy. Bal: INR 45,200.00.',
    sender: 'VK-HSBCIN-S',
  ),
  SampleSms(
    body:
        'Credit of INR 50,000.00 to HSBC A/c XX1234 on 01-05-2026. Ref: SALARY. Bal: INR 95,200.00.',
    sender: 'JM-HSBCIN-S',
  ),
  SampleSms(
    body:
        'Alert: USD 45.00 spent on HSBC Card ending 5678 on 02 May 26 at AMAZON.COM.',
    sender: 'BZ-HSBCIN-S',
  ),
  SampleSms(
    body:
        'Rs. 250.00 debited from HSBC A/c XX1234 on 03.05.26 at CHAI POINT. Avl Bal: Rs. 94,950.00.',
    sender: 'BW-HSBCIN-S',
  ),
  SampleSms(
    body:
        'Your HSBC Credit Card payment of Rs 12,000 received on 04-May-26. Thank you.',
    sender: 'AD-HSBCIN-S',
  ),

  // ── IDFC FIRST Bank ───────────────────────────────────────────────────────
  SampleSms(
    body:
        'INR 450.00 spent on IDFC FIRST Bank Card XX1234 on 30 Apr 26 @ ZOMATO. Avl Lmt: INR 88,200.00.',
    sender: 'VK-IDFCFB-S',
  ),
  SampleSms(
    body:
        'A/c XX1234 debited for Rs.1,200 on 01/05/26 via UPI to merchant. Bal: Rs.15,400.',
    sender: 'JM-IDFCFB-S',
  ),
  SampleSms(
    body:
        'Credit Alert: INR 25,000.00 received in A/c XX1234 on 02-05-26 from EMPLOYER. Bal: INR 40,400.',
    sender: 'BZ-IDFCFB-S',
  ),
  SampleSms(
    body:
        'Cash Wdl of Rs.5,000 from IDFC Bank A/c XX1234 on 03.05.2026 at ATM. Bal: Rs.35,400.',
    sender: 'BW-IDFCFB-S',
  ),
  SampleSms(
    body:
        'Your IDFC Bank A/c XX1234 is credited with Rs 500 cashback on 04-May-26.',
    sender: 'AD-IDFCFB-S',
  ),

  // ── Karnataka Bank ────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Karnatakabank: A/c XX1122 debited Rs.2,400 on 30-Apr-2026. Avl Bal Rs.18,500. -KBL',
    sender: 'VK-KTKBANK-S',
  ),
  SampleSms(
    body:
        'Your A/c XX1122 is credited with Rs.15,000 on 01/05/26 via NEFT. Bal Rs.33,500. -KBL',
    sender: 'JM-KTKBANK-S',
  ),
  SampleSms(
    body:
        'UPI txn of Rs.125.00 from A/c XX1122 on 02 May 26 to tea@upi successful.',
    sender: 'BZ-KTKBANK-S',
  ),
  SampleSms(
    body:
        'ATM Wdl Rs.2,000 from A/c XX1122 on 03.05.26 at BLR ATM. Bal Rs.31,375.',
    sender: 'BW-KTKBANK-S',
  ),
  SampleSms(
    body:
        'KBL A/c XX1122 credited with Rs.500 interest on 04-05-2026. Bal Rs.31,875.',
    sender: 'AD-KTKBANK-S',
  ),

  // ── Kotak Mahindra Bank ───────────────────────────────────────────────────
  SampleSms(
    body:
        'Kotak Bank: Rs.1,199 debited from A/c XX4455 on 30/04/26 for NETFLIX. Bal Rs.22,401.',
    sender: 'VK-KOTAKB-S',
  ),
  SampleSms(
    body:
        'Salary of INR 65,000.00 credited to Kotak A/c XX4455 on 01-05-26. Bal INR 87,401.',
    sender: 'JM-KOTAKB-S',
  ),
  SampleSms(
    body:
        'Alert: Rs 2,500 spent on Kotak Card xx9911 on 02 May 26 at RELIANCE. Avl Lmt Rs 1,45,000.',
    sender: 'BZ-KOTAKB-S',
  ),
  SampleSms(
    body: 'UPI/Rs.80/A/c XX4455/03.05.26/To:shop@upi. Bal Rs.87,321.',
    sender: 'BW-KOTAKB-S',
  ),
  SampleSms(
    body:
        'Kotak A/c XX4455 credited with Rs 1,200 on 04-May-2026. Ref: IMPS. Bal Rs.88,521.',
    sender: 'AD-KOTAKB-S',
  ),

  // ── Canara Bank ───────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Canara Bank: A/c XX5566 debited Rs.4,800 on 30-Apr-26 towards insurance. Bal Rs.14,200.',
    sender: 'VK-CANBK-S',
  ),
  SampleSms(
    body:
        'Your A/c XX5566 is credited with INR 12,000.00 on 01/05/26 via NEFT. Bal INR 26,200.',
    sender: 'JM-CANBK-S',
  ),
  SampleSms(
    body:
        'UPI txn of Rs.350 from A/c XX5566 on 02 May 26 to food@upi successful.',
    sender: 'BZ-CANBK-S',
  ),
  SampleSms(
    body:
        'ATM withdrawal Rs.2,000 from A/c XX5566 on 03.05.26. Avl Bal Rs.23,850.',
    sender: 'BW-CANBK-S',
  ),
  SampleSms(
    body:
        'Canara Bank A/c XX5566 credited with Rs.150 on 04-05-2026. Ref: Cashback.',
    sender: 'AD-CANBK-S',
  ),

  // ── Federal Bank ──────────────────────────────────────────────────────────
  SampleSms(
    body:
        'FedMobile: Rs.2,400 debited from A/c XX3344 on 30/04/26. Ref: Amazon. Bal Rs.11,200.',
    sender: 'VK-FEDBK-S',
  ),
  SampleSms(
    body:
        'Credit alert: INR 45,000.00 in Federal Bank A/c XX3344 on 01-05-26. Bal INR 56,200.',
    sender: 'JM-FEDBK-S',
  ),
  SampleSms(
    body:
        'UPI payment of Rs.650 from A/c XX3344 on 02 May 26 successful. Bal Rs.55,550.',
    sender: 'BZ-FEDBK-S',
  ),
  SampleSms(
    body:
        'Cash Wdl Rs.1,000 from A/c XX3344 on 03.05.26 at ATM. Avl Bal Rs.54,550.',
    sender: 'BW-FEDBK-S',
  ),
  SampleSms(
    body:
        'Federal Bank A/c XX3344 credited with Rs 2,500 on 04-May-2026. Ref: IMPS.',
    sender: 'AD-FEDBK-S',
  ),
  SampleSms(
    body:
        'Dear SBI User, your A/c X1234-debited by Rs2500.00 on 01May26 transfer to rajesh@okicici Ref No 612345678901. If not done by u, fwd this SMS to 9223008333/Call 1800111109 to block UPI.',
    sender: 'SBINB',
  ),
  SampleSms(
    body:
        'Your account No: XXXX4861 is debited with Rs. 4000.00 on 01-May-26 towards ATM cash withdrawal. Available balance is Rs. 70650.00',
    sender: 'SBYONO',
  ),
  SampleSms(
    body:
        'UPDATE: Your A/c XX4861 credited with INR 10000.00 on 01/05/26 by A/c linked to mobile no XX98XX (IMPS Ref No. 4635896913704738) Available bal: INR 18500.00.',
    sender: 'SBINB',
  ),
  SampleSms(
    body:
        '**Alert: You\'ve spent INR 1250.00 on your SBI card 48219 at AMAZON PAY on 01-May-26 at 10:15. Please call 1800111109 if this was not made by you.',
    sender: 'SBICRD',
  ),
  SampleSms(
    body:
        'Dear Customer, SI90711704 executed successfully through State Bank Internet banking. Your Transaction Ref No is CT00QNGIG5 for Rs.13485 on 18-MAY-25.-SBI',
    sender: 'SBINB',
  ),
  SampleSms(
    body:
        'Dear Customer, For PAN XXVVV An IT Refund amount of Rs 25870 for AY-2025-26 has been credited to your account XXXXXXXXXX4861 on 2025-09-29. -SBI',
    sender: 'SBINB',
  ),
  SampleSms(
    body:
        'Dear SBI User, A/c XX1234 credited with INR 10,000.00 on 01/05/26 via IMPS/NEFT. Available Balance: INR 18,500.00. - SBI',
    sender: 'SBYONO',
  ),
  SampleSms(
    body:
        'Dear SBI User, INR 1,500.00 debited from A/c XX1234 on 01/05/26 10:00:00. POS Transaction/ATM Withdrawal. Bal: INR 8,500.00. - SBI',
    sender: 'SBINB',
  ),
  SampleSms(
    body:
        'Dear SBI User, UPI-123456789012-Paytm-12345678-RefNo-INR 500.00 debited from A/c XX1234 on 01/05/26. Bal: INR 10,000.00. - SBI',
    sender: 'SBYONO',
  ),
  SampleSms(
    body:
        'Dear Customer, your A/c XX1234 is credited by INR 45,000.00 on 01May26. Available Balance: INR 69,200.00. - SBI',
    sender: 'SBINB',
  ),
  SampleSms(
    body:
        'Dear Customer, Cheque for INR 5,000.00 in A/c XX1234 is cleared/paid on 01-May-26. Available Bal: INR 64,200.00. - SBI',
    sender: 'SBINB',
  ),
  SampleSms(
    body:
        'Dear Customer, your A/c XX1234 is credited by INR 10,000.00 on 01May26 09:45:10 by NEFT-P1234567890. Avl Bal: INR 24,200.00. - SBI',
    sender: 'SBINB',
  ),
  SampleSms(
    body:
        'Dear SBI User, your A/c XX1234 debited by INR 1,250.00 on 01May26 10:15:20 at AMAZON PAY. Bal: INR 14,200.00. Not done by you? Call 1800111109. - SBI',
    sender: 'SBYONO',
  ),
  SampleSms(
    body:
        'Dear Customer, INR 2,000.00 withdrawn from A/c XX1234 on 01-May-26 at SBI ATM. Avl Bal: INR 15,450.00. Call 1800111109 if not done by you. - SBI',
    sender: 'SBINB',
  ),
  SampleSms(
    body:
        'Dear SBI User, your A/c XX1234 is debited by INR 500.00 on 01May26 11:30:45. Ref no: 612345678901. If not done by you, call 1800111109 to block. - SBI',
    sender: 'SBYONO',
  ),
  SampleSms(
    body:
        'Dear Customer, IMPS of Rs. 1000.0 in account number XX3756 is success. CSP number 1A774C07. Transaction Reference number 4635896913704738 time 14/04/2022 11:40:55 AM.-SBI',
    sender: 'SBINB',
  ),
  SampleSms(
    body:
        'Your A/C XXXXX093161 Credited INR 5,900.00 on 01/12/24-Deposit by transfer from LISTENER SUPREME SOL. Avl Bal INR -SBI',
    sender: 'SBYONO',
  ),
  SampleSms(
    body:
        'Dear SBI Customer, Rs.2000 withdrawn at SBI ATM Tamil nadu from A/cX2463 on 09Sep24 Transaction Number 8274. Available Balance Rs. 40000 If not withdrawn by you, forward this SMS to 9223008333 / call 1800111109 or 09449112211 to block your card. Call 18001234 if cash not received.',
    sender: 'SBINB',
  ),
  SampleSms(
    body:
        'Dear Customer, hold for INR 15,000.00 created in deposit Ac XXXXX960916 on 05/03/26. If not consented, pl contact branch-SBI',
    sender: 'SBYONO',
  ),
  SampleSms(
    body:
        'A/c XX1361 debited INR 25.00 Dt 13-03-23 08:15 thru UPI:343896627597.Bal INR 12539.58 Not u?Fwd this SMS to 9264092640 to block UPI.Download PNB ONE-PNB',
    sender: 'VM-PNBSMS',
  ),
  SampleSms(
    body:
        'Ac XXXXXXXX01361 Credited with Rs.60000.00,13-03-2023 14:20:23 thru NEFT from PAY AND ACCOUNTS OFFICE-III, W. Aval Bal 96489.58 CR Helpline 18001802222-PNB',
    sender: 'VM-PNBSMS',
  ),
  SampleSms(
    body:
        'Dear Customer, Your a/c XXXXXXXX1598 is credited for Rs 1000.00 on 19-11-21 07.17.59 through UPI. Available Bal Rs 1033.02 (UPI Ref ID 132336864448)-PNB',
    sender: 'BG-PNBSMS',
  ),
  SampleSms(
    body:
        'Dear Customer, Your a/c XXXXXXXX1598 is debited for Rs 500.00 on 19-11-21 07.22.17 through UPI. Available Bal Rs 533.02 (UPI Ref no 132351370693). If not done by you,pl forward this SMS from registered mobile to 9264092640 to report unauthorized txn & block UPI. Download PNB ONE-PNB',
    sender: 'BG-PNBSMS',
  ),
  SampleSms(
    body:
        'Dear Customer, Your a/c. XXXXXXXX1598 is credited for Rs. 715.00 on 19-11-21 11.08.05 through UPI. (UPI Ref ID: 132346339990). No carelessness until there is a cure.',
    sender: 'BG-PNBSMS',
  ),
  SampleSms(
    body:
        'Ac XXXXXXXX00000859 Credited with Rs.288279.00,11-06-2024 21:55:22 thru RTGS SBINR12024061128565666 Aval Bal 290518.34 CR Helpline 18001802222 Helpline 18001800/18002021-PNB',
    sender: 'AD-PNBSMS',
  ),
  SampleSms(
    body:
        'Dear Customer, transaction of INR 853.40 done on ICICI Bank Account on 10-Nov-21. Info: VIN*IBPS The Available Balance is INR 3,439.60. Call on 18002662 for dispute or SMS BLOCK 832 to 9215676766',
    sender: 'VK-ICICIB',
  ),
  SampleSms(
    body:
        'Balances for Ac on 11/11/2021 12:01:19 PM ISTTotal Avbl. Bal: INR|2929.6Avbl. Bal: INR 2929.6Linked FD bal: INR 0.0',
    sender: 'TM-ICICIB',
  ),
  SampleSms(
    body:
        'INR1.00 debited on Credit Card XX4006 on 03-Sep-20.Info:GOOGLE SERVICES.Avbl Lmt:INR32,272.64.Call 18002662 for dispute or SMS BLOCK 4006 to 9215676766',
    sender: 'TM-ICICIB',
  ),
  SampleSms(
    body:
        'ICICI Bank Account XX678 is credited with Rs 33,268.00 on 02-Sep-23 by Account linked to mobile number XXXXX00000. IMPS Ref. no. 324515098413.',
    sender: 'TM-ICICIB',
  ),
  SampleSms(
    body:
        'Payment of Rs 81,177.00 has been received on your ICICI Bank Credit Card V through Bharat Bill Payment System on 29-APR-25.',
    sender: 'CP-ICICIT',
  ),
  SampleSms(
    body:
        'ICICI BANK A/c XXXXXX414 credited INR 10.00 Dt 29-08-23 thru.A/c linked to.9034334140@ybl (UPI: R ID 355512725021).',
    sender: 'CP-ICICIT',
  ),
  SampleSms(
    body:
        'Dear Customer, your ICICI Bank Account XX306 has been credited with INR 26,920.00 on 13-FEB-21. Info:BIL*REVERSAL-00 0044191259*RBI-NEFT. The Available Balance is INR 40000',
    sender: 'JD-ICICIB',
  ),
  SampleSms(
    body:
        'Dear Customer, your Account XX14 has been debited with INR 1,900.00 on 03-Apr-18. Info: ATM*CASH WDL*01. The Available Balance is INR 2000',
    sender: 'VM-ICICIB',
  ),
  SampleSms(
    body:
        'Dear Customer, Your transaction of Rs 20000 from ICICI Bank was successfully credited to the beneficiary Chandani account XXXXXXX8102 on 29/03/2023 18:54:14 with RRN 308819054480. In case the beneficiary has not received the amount, then please share the reference number with the beneficiary, to check with their bank.',
    sender: 'TM-ICICIB',
  ),
  SampleSms(
    body:
        'IND AMAZON refund of Rs 699.00 credited to ICICI Bank Credit Card on 06-APR-25. Revised total due Rs 2,827.40, minimum due Rs .00',
    sender: 'TM-ICICIB',
  ),
  SampleSms(
    body:
        'Dear Customer, Your transaction of Rs 3999 from ICICI Bank was successfully credited to the beneficiary RAJKUMAR account XXXXXXXX5768 on 27/05/2022 13:44:32 with RRN 214724995572. In case the beneficiary has not received the amount, then please share the reference number with the beneficiary, to check with their bank.',
    sender: 'VMICICIB',
  ),
  SampleSms(
    body:
        'Rs.4,400.00 Credited to a/c XXXXXXXXXX/on by Transfer Successful 17-01-2024 by linked to VPA/75070706141@ici Net Banking (UPI Ref No.230087248852 Icici bank',
    sender: 'VM-ICICIB',
  ),
  SampleSms(
    body:
        'An amount of INR 230.00 has been kept as hold in your account Number ending with XXXX5825. Total Avail Bal INR 6.00 Canara Bank.',
    sender: 'AX-CANBNK',
  ),
  SampleSms(
    body:
        'An amount of INR 2,000.00 has been CREDITED to your account XXXX5825 on 25/11/2024.Total Avail.bal INR 1,470.00.-Canara Bank',
    sender: 'AX-CANBNK',
  ),
  SampleSms(
    body:
        'Rs.243.20 paid thru A/C XX1652 on 12-3-23 09:54:53 to Smart Point FR, UPI Ref 307159180858. If not done, SMS BLOCKUPI to 9901771222.-Canara Bank',
    sender: 'VM-CANBNK',
  ),
  SampleSms(
    body:
        'Rs.159.40 paid thru A/C XX1652 on 12-3-23 13:30:21 to Magicpin, UPI Ref 343726014001. If not done, SMS BLOCKUPI to 9901771222.-Canara Bank',
    sender: 'VM-CANBNK',
  ),
  SampleSms(
    body:
        'Dear Customer, your ECS Debit for Rs.110 fvg PMSYM rejected on account of Insufficient Balance. Rtn charges of Rs. 500 and applicable GST will be debited from a/c-Canara Bank.',
    sender: 'VM-CANBNK',
  ),
  SampleSms(
    body:
        'Your a/c no. XXXXXXXXX1658 has been debited for Rs.210.00 on 5/20/21 12:40 PM towards beneficiary a/c no. 2063 (UPI Ref no 114012121556)-Canara Bank',
    sender: 'BW-CANBNK',
  ),
  SampleSms(
    body:
        'Rs. 16,964.00 has been debited to your A/c XX0289 on 31/03/2020 towards Loan Drawdown. Avl Bal Rs. 15,625.86',
    sender: 'CANBNK',
  ),
  SampleSms(
    body:
        'Your SB A/c *7332 Debited for Rs:110 on 06-12-2022 19:12:30 by Transfer Avl Bal Rs:675-Union Bank of India',
    sender: 'VM-UNIONB',
  ),
  SampleSms(
    body:
        'Your Cash Deposit of Rs.13220.00 is credited to A/c No **20333 on 13-03-2024 12:41:25, srl no 6.Union Bank of India.',
    sender: 'AD-UNIONB',
  ),
  SampleSms(
    body:
        'A/c *6758 Credited for Rs.500 on 04-09-2021 09:58:45 by Mob Bk ref no 124709049208 Avl Bal Rs: 1234',
    sender: 'JD-UNIONB',
  ),
  SampleSms(
    body:
        'Your SB A/c6758 Credited for Rs:1503 on 07-09-2021 19:03:32 by IMPS AvI Bal Rs 3444 -Union Bank of India',
    sender: 'JD-UNIONB',
  ),
  SampleSms(
    body:
        'A/c *1715 Debited for Rs:2821.00 on 19-10-2025 17:45:07 by Mob Bk ref no 344825400922 Avl Bal Rs:2164.78.If not you, Call 1800222243 -Union Bank of India',
    sender: 'JM-UNIONB-S',
  ),
  SampleSms(
    body:
        'Rs.1200.00 credited to HDFC Bank A/c XX8275 on 21-05-25 from VPA 8076708091-2@ibl (UPI 917338231848)',
    sender: 'JM-HDFCBK',
  ),
  SampleSms(
    body:
        'You\'ve spent Rs.196900 On HDFC Bank CREDIT Card xx1042 At UNICORNINFOS7429142 On 2024-01-10:11:58:18 Avl bal: Rs.243913 Curr O/s: Rs.214087 Not you?Call 18002586161',
    sender: 'JM-HDFCBK',
  ),
  SampleSms(
    body:
        'Alert!Rs.72992 spent without OTP/PIN.On HDFC Bank CREDIT Card xx1042 At AMAZON On 2024-01-10:12:04:17. Not you? Call 18002586161',
    sender: 'JM-HDFCBK',
  ),
  SampleSms(
    body:
        'Rs.963.42 spent on HDFC Bank Card x5966 at CLOUDFLARE on 2024-07-15:09:36:11. Not U? To Block & Reissue Call 18002586161/SMS BLOCK CC 5966 to 7308080808',
    sender: 'AX-HDFCBK',
  ),
  SampleSms(
    body:
        'HDFC Bank: Upcoming mandate set for 5/2/24 12:00 AM, your account will be debited with Rs 150.00towards BSE for Autopay.kindly maintain sufficient Balance',
    sender: 'JM-HDFCBK',
  ),
  SampleSms(
    body:
        'UPDATE: INR 25,000.00 debited from HDFC Bank XX8770 on 01-MAY-24. Info: FD Booked -XXXXXXXXXX9014: SUNIDHI SINGH. Avl bal:INR 1,743.27',
    sender: 'JM-HDFCBK',
  ),
  SampleSms(
    body:
        'Credit Alert! Rs.10.00 credited to HDFC Bank A/c xx6284 on 20-01-25 from VPA ghgid321@ibl (UPI 673227746350)',
    sender: 'VM-HDFCBK',
  ),
  SampleSms(
    body:
        'Credited Rs.100.00 From HDFC Bank A/C x6284 On 21/01/25 Ref 654763000215',
    sender: 'VM-HDFCBK',
  ),
  SampleSms(
    body:
        'DEAR CARDMEMBER, PAYMENT OF Rs. 2000.00 RECEIVED TOWARDS YOUR CREDIT CARD ENDING 4514 THROUGH IMPS ON 8-11-2020.YOUR AVAILABLE LIMIT IS RS. 100277.63',
    sender: 'VK-HDFCBK',
  ),
  SampleSms(
    body:
        'Dear HDFCBank cardmember, Payment of Rs 2000 was credited to your card ending 4514 on 09/NOV/2020.',
    sender: 'VK-HDFCBK',
  ),
  SampleSms(
    body:
        'ALERT:You\'ve spent Rs.600.00 via Debit Card xx8291 at WALIA SAXEΝΑ AND CO on 2020-11-11:19:07:38.Avl Bal Rs.13567.90.Not you?Call 18002586161',
    sender: 'VK-HDFCBK',
  ),
  SampleSms(
    body:
        'ALERT:You\'ve withdrawn Rs.8000.00 via Debit Card xx8291 at BNA E LOBBY DILARAM on 2020-11-12:18:14:32.Avl Bal Rs.5534.15.Not you?Call 18002586161',
    sender: 'VK-HDFCBK',
  ),
  SampleSms(
    body:
        'Txn Rs.10.00 On HDFC Bank Card 7509 At q983302274@ybl by UPI 121532120738 On 13-04 Not You? Call 18002586161/SMS BLOCK CC 7509 to 7308080808',
    sender: 'VM-HDFCBK-S',
  ),
  SampleSms(
    body:
        'Money Received - INR 2088.00 in your HDFC Bank A/c xx7815 on 10-05-25 by A/c linked to mobile no xx0761 (IMPS Ref No. 516327093164) Avl bal: INR 2935.56',
    sender: 'VM-HDFCBK-S',
  ),
  SampleSms(
    body:
        'Debit INR 2750.00 A/c no. XX4160 24-10-22 08:32:25 UPI/P2M/229725062083/NIMESH RI/Paytm Pay Bal INR 7946.53 SMS BLOCKUPI Cust ID to 8691000002, if not you-Axis Bank',
    sender: 'JM-AxisBk',
  ),
  SampleSms(
    body:
        'INR 885.00 debited from Axis Bank A/c no. XX4160 on 06-04-23 08:44:22 IST for Dr Card Charges ANNUAL 4505XXXXXXXX3657. Avl Bal-INR 24016.08. For details, call 18605005555.',
    sender: 'JM-AxisBk',
  ),
  SampleSms(
    body:
        'Balance in savings a/c 814478 as of 25-OCT-2018 EOD is INR 2025.03. Credits in a/c are subject to clearing.',
    sender: 'VK-AxisBk',
  ),
  SampleSms(
    body:
        'Hello! Your A/c no. 814478 has been credited with Rs. 500 on 26oct18. The A/c balance is Rs. 77.03. Info: IMPS/P2A/829916931193/919930066017/. Call 18605005555 (if in India) if you have not done this transaction.',
    sender: 'VK-AxisBk',
  ),
  SampleSms(
    body:
        'Your payment of Axis Bank Credit Card bill 451457XXXXXX4800 for Rs 922.00 has been processed successfully.',
    sender: 'VK-AxisBk',
  ),
  SampleSms(
    body:
        'Debit INR 50000.00 Axis Bank A/c XX9413 10-11-25 15:19:48 SAK/CASH WDL/SAK460965724/WhatsApp CALL to 917036165000 Not You? SMS BLOCKALL CustID to 919951860002',
    sender: 'AD-AXISBK-S',
  ),
  SampleSms(
    body:
        'Dear Customer, payment of Rs. 11377 has been credited to your loan a/c PPR085103445206 on 07-12-18. 10:02 AM',
    sender: 'AD-AXISBK-S',
  ),
  SampleSms(
    body:
        'INR 22,112.00 spent on indusind Card XX1108 on 08-03-2025 07:38:12 pm at FLIPKART. Avl Lmt: INR 7,888.00. To dispute, call 18602677777/SMS BLOCK 1108 to 5676757',
    sender: 'AM-INDUSB',
  ),
  SampleSms(
    body:
        'Dear Customer, Welcome prosperity with a flat Cashback of INR 2000 on your Indusind Bank Iconia American Express Credit Card ending on Spends of INR 25000 or more between 16-Oct-17 and 18-Oct-17.',
    sender: 'AM-INDUSB',
  ),
  SampleSms(
    body:
        'Your account XXXXXXX4873 debited with Rs. 9999 on 04-04-26 and account XXXXXXX6901/RITU will be credited. (IMPS Ref no. 609413866796). Call 18602677777 to report issue - Indusind Bank',
    sender: 'AM-INDUSB',
  ),
  SampleSms(
    body:
        'A/C *XX4873 credited by Rs 10000.00 from 8298349234@ptyes. RRN:602149054101. Avl Bal:10097.33. Not you? Call 18602677777 - Indusind bank',
    sender: 'AM-INDUSB',
  ),
  SampleSms(
    body:
        'Indusind A/C **4387 Debited; INR 377.56 Ref-To Non Maintenance charges Jan 2026.Bal INR 25,847.02.Dispute-Call 18602677777-IndusInd Bank',
    sender: 'AM-INDUSB',
  ),
  SampleSms(
    body:
        'Dear Customer, One Time Password (OTP) for your Loan application is 996462 OTP is valid for 10 min.Thanks - IDFC FIRST Bank. Click on the Link to download T&C Short URL http://bb-idfcfirstbank.my.salesforce-sites.com/Customer ConsentPage',
    sender: 'JX-IDFCFB',
  ),
  SampleSms(
    body:
        'Transaction Successful! RS 203.40 spent on your IDFC FIRST Bank Credit Card ending XX4972 at DIONTRAINING.COM on 23-FEB-2025 at 10:34 PM Avbl Limit: INR 1481017.58 If not done by you, call 180010888 for dispute or to block your card SMS CCBLOCK 4972 to 5676732',
    sender: 'JK-IDFCFB',
  ),
  SampleSms(
    body:
        'Topped up for a long drive! Recharge successful: IDFC FIRST Bank FASTag 3XXX2F60 Credited with Rs 500 Ref: 5225011911465809 Avbl Bal:Rs 600',
    sender: 'AX-IDFCFB',
  ),
  SampleSms(
    body:
        'INR 185 toll paid from IDFC FIRST Bank Tag 3XXX5B00 for vehicle no. UP14FJ8020 at Gharonda Toll Plaza on 20/02/25 15:56. Avbl. Bal.: INR229.11:53 AM',
    sender: 'JX-IDFCFB',
  ),
  SampleSms(
    body:
        'Dear Customer, Your a/c ending XXXXX708582 is debited by Rs. 472.00 as it did not have the required Average Monthly Balance of Rs. 25,000.00 on MAR-2024. Your New balance is Rs 65.00. Click here to add funds and avoid charges in future: my.idfcfirstbank.com/addfunds. Team IDFC FIRST Bank.',
    sender: 'VM-IDFCFB',
  ),
  SampleSms(
    body:
        'Dear Customer, EMI of Rs 5849 will be debited on 02/04/2020 for your loan #18666041. Pls ensure balance in your bank account # ending with 5471 atleast one day before. Bounce charges of 400 + GST charges apply. Pls note that it would take 3 working days to update payment in our system post debit from your account. IDFC FIRST Bank Ltd. Now get upto 7% interest with IDFC FIRST Bank saving a/c, SMS 1 to 5676732 to open an account now.',
    sender: 'MD-IDFCFB',
  ),
  SampleSms(
    body:
        'Rs 268,088.40 is credited to YES BANK Acc XX3730 on 03-MAY-23 09:31:57 -ME POS PYMT DT 030523 -MID 0978A0017289. Avl bal-268,851.18.',
    sender: 'AX-YESBNK',
  ),
  SampleSms(
    body:
        'Rs 11,302.00 debited from YES BANK Acc XX3730 on 17-MAY 18:42-EMI_ALN000300354152. Avl Bal-Rs 864.22.',
    sender: 'AX-YESBNK',
  ),
  SampleSms(
    body:
        'Rs 49,005.00 debited to Acc. XX3730 on 29-MAY 13:10. Avl Bal-Rs 451.16. Not You? Click yesbank.in/fraud',
    sender: 'AX-YESBNK',
  ),
  SampleSms(
    body:
        'INR 1,500.00 Debited to Ac XXXXXXXXXXX0816 on 08-MAY-2018 14:44:39-ATD: 2202502994:800025:+PRAHLADPUR CHOWK OATM DELHI DLIN Tot Avbl Bal-INR 30,910.50',
    sender: 'AD-YESBNK',
  ),
  SampleSms(
    body:
        'Rs 11,955.00 Debited to Ac XX0816 on 11-MAY 06:38-Chq Paid-INWARD MICR-CHANAKYAPURI- Tot Avbl Bal-Rs 18,795.36 on 11-May 06:38',
    sender: 'AD-YESBNK',
  ),
  SampleSms(
    body:
        'This is to inform you that M/s RAHUL ENTERPRISES has transferred an amount of Rs. 2475.00 to your account no. XXXXXXXX4487 from their YES Bank account through RTGS/NEFT/IMPS',
    sender: 'VK-YESBNK',
  ),
  SampleSms(
    body:
        'Dear Customer, Rs.100 credited to your A/c XX2814 on 11SEP2024 15:22:29. BAL-Rs.480.91-Federal Bank',
    sender: 'JM-FEDBNK',
  ),
  SampleSms(
    body:
        'Dear Customer, Rs.443 debited from your A/c XX2814 towards non-maintenance of Average Monthly Balance in your account on 11SEP2024 15:34:11. BAL-Rs.37.91-Federal Bank',
    sender: 'JM-FEDBNK',
  ),
  SampleSms(
    body:
        'Hi, payment of INR 1750.00 for Google Play via e-mandate ID: XzOaZEsoKJ on Federal Bank Debit Card 2014 is processed successfully. To manage, visit: https://www.sihub.in /managesi/federal T&CA - Federal Bank',
    sender: 'VM-FEDBNK-S',
  ),
  SampleSms(
    body:
        'INR 100.00 sent from your Account XXXXXXXX5721 Mode: UPI ö To: paytmqr281005050101pl59klibw 7ux@paytm Date: September 21, 2022 Not done by you? Call 080-47485490-Federal Bank',
    sender: 'BP-FedFiB',
  ),
  SampleSms(
    body:
        'INR 90.00 sent from your account XXXXXXXX5721 Sent to your beneficiary on September 21, 2022. If this transaction wasn\'t done by you, call 080-47485490-Federal Bank',
    sender: 'BP-FedFiB',
  ),
  SampleSms(
    body:
        'Rs.1 debited by ECOM Txn using your card XX0787 at WWW OLACABS COM on 14JUN2019 15:56:42.BAL-Rs. 1877.12.Call 18004251199, if not done by you-Federal Bank',
    sender: 'HP-FEDBNK',
  ),
  SampleSms(
    body:
        'IDBI Bank A/c NN75453 credited for INR 1500.00 thru UPI. Bal INR 4936.19 (incl. of chq in clg) as of 04 FEB 08:29hr. If not used by you, call 18002094324',
    sender: 'JD-IDBIBK',
  ),
  SampleSms(
    body:
        'IDBI Bank A/c NN11010 credited for INR 500.00 thru UPL Bal INR 3203.39 (incl of chq in clg) as of 15 FEB 21:51hr. If not used by you, call 18002094324',
    sender: 'VK-IDBIBK-S',
  ),
  SampleSms(
    body:
        'IDBI Bank Acct XX010 debited for Rs 30.00 on 17-Feb-26 Bal Rs 2803.39 Manikram Gautam credited. UPL308380713294. To Block UPI send SMS UPIBLOCK <Mob. No to 07799000298 or call 18002094324-IDBI Bank',
    sender: 'VK-IDBIBK-S',
  ),
  SampleSms(
    body:
        'IDBI Bank A/C NN11010 debited INR 590.00 Det:DIRDB1106241"BAJAJ FINANCE L. Bal (incl of chain cig) INR. 3313.39 as of 21FEB 11:54 hrs.',
    sender: 'VK-IDBIBK-S',
  ),
  SampleSms(
    body:
        'A/c NN81754 debited for Rs 9000.00 thru UPI. A/c Bal Rs 5168.84 (incl. of uncleared chqs) as of 29 OCT 15:34hr. If not used by you, call 18002094324',
    sender: 'BW-IDBIBK',
  ),
  SampleSms(
    body:
        'Your a/c no. XXXXXXXXXXXX1754 is debited for Rs.9000.00 on 29-10-19 and credited to a/c no. XXXXXXXX7875 (UPI Ref no 930215044400)',
    sender: 'BW-IDBIBK',
  ),
  SampleSms(
    body:
        'Alert! Your AU Bank A/c No. X9318 has been Debited with INR 71.07 on 26-DEC-2025 for Debit Card Fee FY25\'26 XX7022. Avl Bal: INR 0.00.- AU Bank',
    sender: 'VD-AUBANK-S',
  ),
  SampleSms(
    body:
        'Alert! Your AU Bank A/c No. xxx1234 has been Debited with INR 352.82 on 16-DEC-2025 for Debit Card Fee FY25\'26 Avl Bal: 500 INR',
    sender: 'VD-AUBANK-S',
  ),
  SampleSms(
    body:
        'Debited INF 40,000.00 rom A/c XX6439 on 13-JUL-2022 Ref UPI/DR/219458166688/PANKAJ PRADHAN/CNRB. Bal INR 4,25,373.00. Not you?Call',
    sender: 'AX-AUBANK',
  ),
  SampleSms(
    body:
        'Thank you AU Bank Credit Cardholder! Payment of INR 20,685.00 was credited to your Card xx7750 on 12/10/2024. -AU Bank',
    sender: 'AD-AUBANK',
  ),
  SampleSms(
    body:
        'Your UCO Bank A/c XX2963 has been Debited with Rs.2.66 by Transfer.Avl Bal in your A/c is Rs.5.48.For feedback, click https://apps.ucoonline.in/cust feedback/Home Page.jsp',
    sender: 'VM-UCOBNK',
  ),
  SampleSms(
    body:
        'A/c XX9816 Debited with Rs. 1,600.00 on 02-10-2023 by UCO-UPI.Avl Bal Rs.111.00. Report Dispute https://bit.ly/3y39tLP.For feedback https://rb.gy/fdfmda',
    sender: 'VM-UCOBNK',
  ),
  SampleSms(
    body:
        'A/c XX5700 Credited with Rs. 150.00 on 11-12-2018 by UCO-UPI.Avl Bal Rs.8,184.35.Use UCOSECURE App http://bit.ly/UCOSECURE for enhanced security.',
    sender: 'AD-UCOBNK',
  ),
  SampleSms(
    body:
        'Rs. 8,000 withdrawn on Card XX1417 on 11-12-2018,17:03:24 at VILUPURAM, VILLUPURAM ATM ID-NFUC0000. Avl Bal Rs. 34.35. Avail offer@IOCL with Rupay Card.',
    sender: 'AD-UCOBNK',
  ),
  SampleSms(
    body:
        'Namaskar! ATM txn. initiated on 11-12-2018 is reversed, A/c XX5700 credited with Rs.8,000.00. Avl Bal Rs 34.35.Use UCOSECURE App http://bit.ly/UCOSECURE',
    sender: 'AD-UCOBNK',
  ),
  SampleSms(
    body:
        'You have received a payment of Rs. 190.00 in a/c X9571 on 06/12/2025 17:07 from shiv raj thru IPPB. Info: UPI/CREDIT/ 534085674590.- IPPB',
    sender: 'AD-IPBMSG-S',
  ),
];
