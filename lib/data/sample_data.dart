class SampleSms {
  final String body;
  final String sender;
  final DateTime? date;

  const SampleSms({required this.body, required this.sender, this.date});
}

final List<SampleSms> sampleSms = [
  // ── HDFC Bank ─────────────────────────────────────────────────────────────
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
    body: 'OTP for your HDFC Bank transaction is 882911. Do not share it with anyone.',
    sender: 'AD-HDFCBK-S',
  ),
  SampleSms(
    body: 'Your HDFC Bank Personal Loan of Rs. 2,00,000 is ready for disbursal. Click to apply.',
    sender: 'VM-HDFCBK-S',
  ),
  SampleSms(
    body: 'Transaction of INR 1,250.00 failed on your HDFC Bank A/c XX1234. Insufficient Balance.',
    sender: 'BW-HDFCBK-S',
  ),
  SampleSms(
    body: 'Grab 10% Cashback on HDFC Bank Cards at Flipkart Big Billion Days! Shop now.',
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
    body: 'Transaction of Rs. 500.00 on SBI Card ending 5678 declined due to technical error.',
    sender: 'VK-SBICRD-S',
  ),
  SampleSms(
    body: 'Congratulations! You are eligible for an SBI Home Loan with interest starting at 8.5%.',
    sender: 'JM-SBISMS-S',
  ),
  SampleSms(
    body: 'Enjoy zero processing fee on SBI Car Loans this festive season. Apply on YONO.',
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
    body: 'Transaction of INR 2,500.00 on ICICI Bank Card failed due to incorrect PIN.',
    sender: 'VK-ICICIB-S',
  ),
  SampleSms(
    body: 'Pre-approved Personal Loan of Rs. 5 Lakhs for you! Apply on iMobile app.',
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
    body: 'Your Axis Bank Credit Card payment is due. Pay now to avoid late fees.',
    sender: 'JM-AXISBN-S',
  ),
  SampleSms(
    body: 'Declined: Txn of INR 1,000.00 at Amazon on Axis Bank Card XX1234. Exceeds limit.',
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
    body: 'Failed: Rs. 200.00 debited from Kotak A/c XX1234 but reversed due to timeout.',
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
    body: 'Failed: INR 500.00 debited from IndusInd Bank A/c XX1234 but rejected by merchant.',
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
    body: 'Your IDFC FIRST Bank Loan statement for Mar-25 is available for download.',
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
    body: 'Transaction of Rs. 1,000.00 on PNB A/c XX1234 failed. Network issue.',
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
    body: 'Get a Canara Bank Gold Loan at attractive interest rates. Visit branch.',
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
    body: 'Failed: JioPay payment of Rs. 350.00 at Zomato failed. Amt will be reversed.',
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
  SampleSms(body: 'Cheque no 881221 cleared for Rs.12,500.', sender: 'JM-KTKBANK-S'),
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
  SampleSms(body: 'ATM WDL Rs.1,000 from card ending 2234', sender: 'BW-KGBANK-S'),
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
  SampleSms(body: 'Salary credit Rs.38,000 in A/c **9122', sender: 'JM-SARASW-S'),
  SampleSms(body: 'Cheque no 229911 passed for Rs.9,500', sender: 'BZ-SARASW-S'),
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
  SampleSms(body: 'Salary credit INR 1,25,000 to A/c XX5511', sender: 'JM-SCBANK-S'),
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
  SampleSms(body: 'Salary Rs.22,000 credited in A/c **1144', sender: 'JM-UCOBNK-S'),
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
  SampleSms(body: 'Salary credit Rs.52,000 in A/c **1234', sender: 'BZ-UNIONB-S'),
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
  SampleSms(body: 'Salary credit Rs.65,000 in A/c **4411', sender: 'BZ-YESBNK-S'),
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
    body: 'HSBC A/c XX1234 debited by INR 1,500.00 on 30/04/26. Info: Swiggy. Bal: INR 45,200.00.',
    sender: 'VK-HSBCIN-S',
  ),
  SampleSms(
    body: 'Credit of INR 50,000.00 to HSBC A/c XX1234 on 01-05-2026. Ref: SALARY. Bal: INR 95,200.00.',
    sender: 'JM-HSBCIN-S',
  ),
  SampleSms(
    body: 'Alert: USD 45.00 spent on HSBC Card ending 5678 on 02 May 26 at AMAZON.COM.',
    sender: 'BZ-HSBCIN-S',
  ),
  SampleSms(
    body: 'Rs. 250.00 debited from HSBC A/c XX1234 on 03.05.26 at CHAI POINT. Avl Bal: Rs. 94,950.00.',
    sender: 'BW-HSBCIN-S',
  ),
  SampleSms(
    body: 'Your HSBC Credit Card payment of Rs 12,000 received on 04-May-26. Thank you.',
    sender: 'AD-HSBCIN-S',
  ),

  // ── IDFC FIRST Bank ───────────────────────────────────────────────────────
  SampleSms(
    body: 'INR 450.00 spent on IDFC FIRST Bank Card XX1234 on 30 Apr 26 @ ZOMATO. Avl Lmt: INR 88,200.00.',
    sender: 'VK-IDFCFB-S',
  ),
  SampleSms(
    body: 'A/c XX1234 debited for Rs.1,200 on 01/05/26 via UPI to merchant. Bal: Rs.15,400.',
    sender: 'JM-IDFCFB-S',
  ),
  SampleSms(
    body: 'Credit Alert: INR 25,000.00 received in A/c XX1234 on 02-05-26 from EMPLOYER. Bal: INR 40,400.',
    sender: 'BZ-IDFCFB-S',
  ),
  SampleSms(
    body: 'Cash Wdl of Rs.5,000 from IDFC Bank A/c XX1234 on 03.05.2026 at ATM. Bal: Rs.35,400.',
    sender: 'BW-IDFCFB-S',
  ),
  SampleSms(
    body: 'Your IDFC Bank A/c XX1234 is credited with Rs 500 cashback on 04-May-26.',
    sender: 'AD-IDFCFB-S',
  ),

  // ── Karnataka Bank ────────────────────────────────────────────────────────
  SampleSms(
    body: 'Karnatakabank: A/c XX1122 debited Rs.2,400 on 30-Apr-2026. Avl Bal Rs.18,500. -KBL',
    sender: 'VK-KTKBANK-S',
  ),
  SampleSms(
    body: 'Your A/c XX1122 is credited with Rs.15,000 on 01/05/26 via NEFT. Bal Rs.33,500. -KBL',
    sender: 'JM-KTKBANK-S',
  ),
  SampleSms(
    body: 'UPI txn of Rs.125.00 from A/c XX1122 on 02 May 26 to tea@upi successful.',
    sender: 'BZ-KTKBANK-S',
  ),
  SampleSms(
    body: 'ATM Wdl Rs.2,000 from A/c XX1122 on 03.05.26 at BLR ATM. Bal Rs.31,375.',
    sender: 'BW-KTKBANK-S',
  ),
  SampleSms(
    body: 'KBL A/c XX1122 credited with Rs.500 interest on 04-05-2026. Bal Rs.31,875.',
    sender: 'AD-KTKBANK-S',
  ),

  // ── Kotak Mahindra Bank ───────────────────────────────────────────────────
  SampleSms(
    body: 'Kotak Bank: Rs.1,199 debited from A/c XX4455 on 30/04/26 for NETFLIX. Bal Rs.22,401.',
    sender: 'VK-KOTAKB-S',
  ),
  SampleSms(
    body: 'Salary of INR 65,000.00 credited to Kotak A/c XX4455 on 01-05-26. Bal INR 87,401.',
    sender: 'JM-KOTAKB-S',
  ),
  SampleSms(
    body: 'Alert: Rs 2,500 spent on Kotak Card xx9911 on 02 May 26 at RELIANCE. Avl Lmt Rs 1,45,000.',
    sender: 'BZ-KOTAKB-S',
  ),
  SampleSms(
    body: 'UPI/Rs.80/A/c XX4455/03.05.26/To:shop@upi. Bal Rs.87,321.',
    sender: 'BW-KOTAKB-S',
  ),
  SampleSms(
    body: 'Kotak A/c XX4455 credited with Rs 1,200 on 04-May-2026. Ref: IMPS. Bal Rs.88,521.',
    sender: 'AD-KOTAKB-S',
  ),

  // ── Canara Bank ───────────────────────────────────────────────────────────
  SampleSms(
    body: 'Canara Bank: A/c XX5566 debited Rs.4,800 on 30-Apr-26 towards insurance. Bal Rs.14,200.',
    sender: 'VK-CANBK-S',
  ),
  SampleSms(
    body: 'Your A/c XX5566 is credited with INR 12,000.00 on 01/05/26 via NEFT. Bal INR 26,200.',
    sender: 'JM-CANBK-S',
  ),
  SampleSms(
    body: 'UPI txn of Rs.350 from A/c XX5566 on 02 May 26 to food@upi successful.',
    sender: 'BZ-CANBK-S',
  ),
  SampleSms(
    body: 'ATM withdrawal Rs.2,000 from A/c XX5566 on 03.05.26. Avl Bal Rs.23,850.',
    sender: 'BW-CANBK-S',
  ),
  SampleSms(
    body: 'Canara Bank A/c XX5566 credited with Rs.150 on 04-05-2026. Ref: Cashback.',
    sender: 'AD-CANBK-S',
  ),

  // ── Federal Bank ──────────────────────────────────────────────────────────
  SampleSms(
    body: 'FedMobile: Rs.2,400 debited from A/c XX3344 on 30/04/26. Ref: Amazon. Bal Rs.11,200.',
    sender: 'VK-FEDBK-S',
  ),
  SampleSms(
    body: 'Credit alert: INR 45,000.00 in Federal Bank A/c XX3344 on 01-05-26. Bal INR 56,200.',
    sender: 'JM-FEDBK-S',
  ),
  SampleSms(
    body: 'UPI payment of Rs.650 from A/c XX3344 on 02 May 26 successful. Bal Rs.55,550.',
    sender: 'BZ-FEDBK-S',
  ),
  SampleSms(
    body: 'Cash Wdl Rs.1,000 from A/c XX3344 on 03.05.26 at ATM. Avl Bal Rs.54,550.',
    sender: 'BW-FEDBK-S',
  ),
  SampleSms(
    body: 'Federal Bank A/c XX3344 credited with Rs 2,500 on 04-May-2026. Ref: IMPS.',
    sender: 'AD-FEDBK-S',
  ),
];
