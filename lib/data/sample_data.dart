class SampleSms {
  final String body;
  final String sender;
  final DateTime? date;

  const SampleSms({required this.body, required this.sender, this.date});
}

final List<SampleSms> sampleSms = [
  // ATMs / basic debit
  SampleSms(
    body: 'Rs.5000 debited from your A/C 1234 on 05-02-26. Avl Bal: Rs.10000.',
    sender: 'AD-HDFCBK',
  ),
  SampleSms(
    body: 'INR 5000 withdrawn from A/C 1234 on 05-02-2026. Avl Bal: INR 10000.',
    sender: 'VM-ICICIB',
  ),
  SampleSms(
    body: 'Rs.2000 debited from A/C 1234. Avl Bal: Rs.9000.',
    sender: 'AXISBK',
  ),

  // UPI‑bank‑SMS
  SampleSms(
    body:
        'UPI has been debited with Rs.1000.00 from your A/C 1234 on 05-02-26. Avl Bal: Rs.9000.00.',
    sender: 'SBIUPI',
  ),
  SampleSms(
    body:
        'UPI payment of INR 1549.00 has been debited from your A/C 1234 on 05-02-26.',
    sender: 'KOTAKB',
  ),
  SampleSms(
    body: 'UPI debit of Rs.99 to Swiggy from your A/C 1234 on 05-02-26.',
    sender: 'HDFCBK',
  ),

  // Realistic Bank Specific Samples
  SampleSms(
    body:
        'Alert: Your HDFC Bank Card ending 1234 has been debited for Rs. 5000.00 at AMAZON on 05-02-26. Avl Bal: Rs. 15000.00.',
    sender: 'HDFCBK',
  ),
  SampleSms(
    body:
        'Your ICICI Bank A/c XX123 debited for INR 1,200.00 on 05-Feb-26; VPA swiggy@upi. Avl Bal: INR 8,500.00.',
    sender: 'ICICIB',
  ),

  // --- NEW BANKS TEST DATA ---
  SampleSms(
    body: 'Rs. 500.00 paid to MerchantName, UPI Ref 123456789012.',
    sender: 'CNRBNK',
  ),
  SampleSms(
    body:
        'INR 1,250.50 has been DEBITED from your A/C XX1234. Avail.bal INR 15,400.00.',
    sender: 'CANBNK',
  ),
  SampleSms(
    body:
        'Your a/c no. X1234 debited for Rs. 1,000.00. Avl Bal 45,000.00. (UPI Ref no 123456789).',
    sender: 'CUBPNK',
  ),
  SampleSms(
    body:
        'Savings No X4321 credited with INR 2,500.00 BY NEFT TRF:REMITTER NAME.',
    sender: 'CUBBNK',
  ),
  SampleSms(
    body:
        'SBI: Rs1000.0 credited to A/c XX1234 on 05Feb26 by NEFT:REF NO 1234567890. Bal:Rs15000.0',
    sender: 'SBIBK',
  ),
  SampleSms(
    body:
        'Axis Bank: Rs. 200.00 debited from A/c XX1234 on 05-02-26 14:20:05 for UPI-PAYTM-1234@paytm. Bal: Rs. 4500.00.',
    sender: 'AXISBK',
  ),

  // --- NEW SAMPLES ADDED ---

  // New Debit Samples
  SampleSms(
    body:
        '248,759.00 is debited from A/c XXXX6791 for BillPay/Credit Card payment via Example Bank NetBanking. Call XXXXXXXX161XXX if txn not done by you.',
    sender: 'BANK-BK',
  ),
  SampleSms(
    body:
        'INR 35,000.00 withdrawn from a/c 40XXXXXXXXX0019 on 08/AUG 10:55 for NET/NEFT/Anil Sharma/ABER000123. Clear Balance: INR 75,000.00.',
    sender: 'SBIBK',
  ),
  SampleSms(
    body:
        'Rs.5000 debited from Acct ending 1234 on 15/04/26 at 09:30 via UPI/ABCXYZ. Avl Bal: Rs.25000. If not you, call 1800-11-XXXX.',
    sender: 'HDFCBK',
  ),
  SampleSms(
    body:
        'A/c XX4567 debited INR 12,500 on 06-Apr-26 14:20 IMPS/MerchantName/IFSC123. Balance: INR 87,500. Dispute? Dial XXX-XXXX.',
    sender: 'ICICIB',
  ),
  SampleSms(
    body:
        'Debit of Rs.2,999 from ****6789 on 06/04/26 12:10 for NEFT/PAYTM/ABC123. New Bal: Rs.45,001. Contact 1800-XXX if unauthorized.',
    sender: 'PAYTM',
  ),
  SampleSms(
    body:
        'Rs.15,000 withdrawn from Acct *2345 via ATM/PIN on 05-Apr-26 18:45. Balance Rs.1,20,000. Call support if dispute.',
    sender: 'ATMSBI',
  ),
  SampleSms(
    body:
        'INR 8,750 debited A/c ending 8910 on 06-Apr 11:45 UPI/PhonePe/XXXX1234. Avl Bal INR 42,250. SMS STOP to block if fraud.',
    sender: 'PHONEPE',
  ),
  SampleSms(
    body:
        '45,000 debited from XX3456 for Credit Card paymt on 04-Apr-26 via NetBanking. Bal: 1,55,000. Helpline: 1800-XXXXXXX.',
    sender: 'HDFCBK',
  ),
  SampleSms(
    body:
        'A/c ****1122 debited Rs.3,200 on 06/04 10:15 IMPS/RemitterName/IFSCABC. Balance Rs.67,800. Report issue at XXX161XXX.',
    sender: 'SBIBK',
  ),
  SampleSms(
    body:
        'Rs.25,000 from Acct XX7890 on 06-Apr-26 12:00 NEFT/SENDER/ABCDEF. Clear Bal Rs.3,75,000. Call if not initiated by you.',
    sender: 'DIB-BK',
  ),
  SampleSms(
    body:
        'Debit INR 1,150 A/c *5678 06-Apr 13:20 UPI/GPay/Merch123. Bal INR 28,850. Dispute? 1800-12-XXXX.',
    sender: 'AXISBK',
  ),
  SampleSms(
    body:
        '7,500 withdrawn ****9012 ATM 05-Apr-26 22:30. New Bal 92,500. Contact bank if unauthorized.',
    sender: 'SBI-ATM',
  ),
  SampleSms(
    body:
        'Rs.18,999 debited XX1234 on 06/04/26 09:50 for Bill Payment/NetBanking. Avl: Rs.81,001. Helpline XXX-XXXXXXX.',
    sender: 'BANK-SMS',
  ),
  SampleSms(
    body:
        'A/c ending 3456 INR 4,200 debited 06-Apr 15:10 IMPS/ABC/IFSC123. Bal 56,800. Call 1800-XXX for disputes.',
    sender: 'DIB-BK',
  ),
  SampleSms(
    body:
        '32,000 from *7890 NEFT/RemitName on 04-Apr-26 17:45. Balance 2,68,000. SMS BLOCK if fraud.',
    sender: 'KOTAKB',
  ),
  SampleSms(
    body:
        'Debit Rs.950 ****2345 UPI 06-Apr 11:30. Bal Rs.19,050. Report to XXX161XXX.',
    sender: 'HDFCBK',
  ),
  SampleSms(
    body:
        'INR 22,500 debited Acct XX4567 05-Apr-26 20:15 ATM. Avl Bal 1,77,500. Helpline 1800-XXXX.',
    sender: 'ICICIB',
  ),
  SampleSms(
    body:
        'Rs.6,750 from 6789 on 06/04 14:00 Credit Card/NetBanking. New Bal 43,250. Call if not you.',
    sender: 'DIB-BK',
  ),
  SampleSms(
    body:
        '1,200 debited *9012 IMPS 06-Apr-26 10:45. Bal 34,800. Dispute helpline XXX-XXXX.',
    sender: 'SBIBK',
  ),
  SampleSms(
    body:
        'A/c XX1122 Rs.28,000 withdrawn 04-Apr 16:20 UPI. Balance 72,000. Contact support.',
    sender: 'AXISBK',
  ),
  SampleSms(
    body:
        'INR 9,999 debited ****5678 NEFT 06-Apr 12:55. Avl 51,001. 1800-11-XXXX if issue.',
    sender: 'KOTAKB',
  ),
  SampleSms(
    body: 'Rs.14,250 ATM *2345 05-Apr-26 19:10. Bal 85,750. Report fraud.',
    sender: 'DIB-BK',
  ),
  SampleSms(
    body:
        'Debit 3,500 XX7890 UPI 06/04/26 13:40. New Bal 96,500. Helpline XXX161XXX.',
    sender: 'HDFCBK',
  ),
  SampleSms(
    body:
        '47,000 from Acct *1234 NetBanking 06-Apr 11:00. Bal 2,53,000. Call 1800-XXXXXXX.',
    sender: 'SBIBK',
  ),
  SampleSms(
    body:
        'Rs.5,600 debited 3456 IMPS 04-Apr-26 21:30. Avl 78,400. SMS STOP for block.',
    sender: 'AXISBK',
  ),

  // New Credit Samples
  SampleSms(
    body:
        '46,000.00 on 24-Jul-2025 & Acct XX791 credited. IMPS: XXX410XX. Call XX0026XX for dispute or SMS BLOCK 126 to XXX5676XXX.',
    sender: 'BANK-BK',
  ),
  SampleSms(
    body:
        'Dear John Doe, Your account ending with 1234 has been credited with ₹5,000 on 25th December 2024. For any queries, please contact our customer support at 1800-123-4567. Thank you for banking with XYZ Bank.',
    sender: 'XYZ-BANK',
  ),
  SampleSms(
    body:
        'Acct ****6789 credited Rs.10,000 on 06-Apr-26 12:05 IMPS/SenderName/IFSC123. New Bal: Rs.55,000.',
    sender: 'SBIBK',
  ),
  SampleSms(
    body:
        'INR 25,500 credited to A/c XX4567 on 06/04/26 14:30 NEFT/ABC/ABCD0001. Avl Bal: INR 80,500.',
    sender: 'DIB-BK',
  ),
  SampleSms(
    body:
        'Rs.15,000 credit *2345 UPI/Paytm on 05-Apr-26 10:20. Balance Rs.1,15,000. Thank you.',
    sender: 'HDFCBK',
  ),
  SampleSms(
    body:
        'A/c ending 8910 credited 42,750 on 06-Apr 11:15. Salary/IMPS. New Bal 87,750. Helpline 1800-XXXX.',
    sender: 'SBIBK',
  ),
  SampleSms(
    body:
        '3,200.00 credited XX3456 NEFT/Remitter 04-Apr-26 17:45. Bal 1,03,200. Queries? XXX-XXXXXXX.',
    sender: 'DIB-BK',
  ),
  SampleSms(
    body:
        'INR 78,000 to ****1122 on 06/04 09:50 UPI. Avl Bal INR 1,78,000. Contact if needed.',
    sender: 'AXISBK',
  ),
  SampleSms(
    body:
        'Rs.22,500 credited Acct *7890 06-Apr-26 13:10 IMPS. Balance 2,22,500. Thank you for banking.',
    sender: 'HDFCBK',
  ),
  SampleSms(
    body:
        'Credit 1,150 XX1234 NEFT 05-Apr 20:30. New Bal 45,150. Helpline 1800-11-XXXX.',
    sender: 'ICICIB',
  ),
  SampleSms(
    body:
        'A/c ****9012 Rs.7,500 credited 06-Apr 12:40 ATM Deposit. Bal Rs.60,000.',
    sender: 'DIB-BK',
  ),
  SampleSms(
    body:
        '18,999 to *5678 on 04-Apr-26 15:20 UPI/GPay. Avl 68,999. Support XXX161XXX.',
    sender: 'KOTAKB',
  ),
  SampleSms(
    body: 'Rs.32,000 credit XX4567 IMPS 06/04/26 10:55. Balance 1,32,000.',
    sender: 'AXISBK',
  ),
  SampleSms(
    body:
        'INR 4,250 credited 7890 NEFT 06-Apr 14:15. New Bal 49,250. Queries call XXX-XXXX.',
    sender: 'HDFCBK',
  ),
  SampleSms(
    body:
        'Acct *2345 Rs.28,000 on 05-Apr-26 18:30 Salary Credit. Bal 78,000. Thank you.',
    sender: 'DIB-BK',
  ),
  SampleSms(
    body:
        '9,999 credited ****6789 UPI 06-Apr 11:45. Avl 59,999. Helpline 1800-XXXXXXX.',
    sender: 'ICICIB',
  ),
  SampleSms(
    body: 'Rs.14,250 to XX1122 04-Apr 16:10. IMPS/Sender. Balance 64,250.',
    sender: 'SBIBK',
  ),
  SampleSms(
    body:
        'Credit 47,000 *9012 NEFT 06/04/26 13:25. New Bal 97,000. Contact support.',
    sender: 'AXISBK',
  ),
  SampleSms(
    body: 'INR 5,600 credited 3456 05-Apr-26 21:00 Cash Dep. Bal 55,600.',
    sender: 'DIB-BK',
  ),

  // --- NEW BANKS TEST DATA ---

  // Canara Bank
  SampleSms(
    body: 'Rs. 500.00 paid to MerchantName, UPI Ref 123456789012.',
    sender: 'CNRBNK',
  ),
  SampleSms(
    body:
        'INR 1,250.50 has been DEBITED from your A/C XX1234. Avail.bal INR 15,400.00.',
    sender: 'CANBNK',
  ),

  // City Union Bank (CUB)
  SampleSms(
    body:
        'Your a/c no. X1234 debited for Rs. 1,000.00. Avl Bal 45,000.00. (UPI Ref no 123456789).',
    sender: 'CUBPNK',
  ),
  SampleSms(
    body:
        'Savings No X4321 credited with INR 2,500.00 BY NEFT TRF:REMITTER NAME.',
    sender: 'CUBBNK',
  ),

  // CRED
  SampleSms(
    body:
        'Your payment of Rs. 15,000.00 was credited towards your HDFC Bank Credit Card ending in 1234.',
    sender: 'CREDIN',
  ),
  SampleSms(
    body: 'Rs.72,500 to Acct XX7890 UPI 06-Apr 12:20. Avl 1,72,500. Thank you.',
    sender: 'HDFCBK',
  ),
  SampleSms(
    body:
        '2,999 credited *1234 IMPS 04-Apr 10:40. Balance 52,999. Helpline XXX161XXX.',
    sender: 'SBIBK',
  ),
  SampleSms(
    body: 'A/c ****5678 Rs.85,000 on 06/04 15:05 NEFT. New Bal 1,35,000.',
    sender: 'ICICIB',
  ),
  SampleSms(
    body: '19,750 credit XX2345 05-Apr-26 19:50 Salary. Bal 69,750. 1800-XXXX.',
    sender: 'DIB-BK',
  ),
  SampleSms(
    body: 'Rs.36,000 to 4567 UPI 06-Apr 11:30. Avl 86,000. Queries? Call bank.',
    sender: 'AXISBK',
  ),
  SampleSms(
    body:
        'INR 11,200 credited *8910 04-Apr-26 14:00. Balance 61,200. Thank you for banking.',
    sender: 'HDFCBK',
  ),

  // Negative Samples
  SampleSms(
    body:
        '123456 is your OTP for transaction of Rs. 1000.00 at AMAZON. Do not share.',
    sender: 'HDFCBK',
  ),
  SampleSms(
    body:
        'Win Rs. 1 Crore! Play now at MegaLotto.com. This is a promotional message.',
    sender: 'SPAM',
  ),
  SampleSms(
    body:
        'Rs.500.00 debited from a/c XXXXX6789 on 25-Oct-23 via UPI/Ref 329845612345. Avl bal Rs.10,234.56',
    sender: 'SBIINB',
  ),

  SampleSms(
    body:
        'INR 1,250.00 is debited from your A/c XX1234 on 05-02-26 by POS txn at SWIGGY. Avl Bal: INR 5,678.00',
    sender: 'HDFCBK',
  ),

  SampleSms(
    body:
        'A/c XX4321 debited by Rs 3,450 on 20-02-26 via UPI Ref No 22334455. If not you call 1800xxxx',
    sender: 'ICICIB',
  ),

  SampleSms(
    body:
        'Rs.2,000 withdrawn from A/c XX5678 at ATM on 02-03-26. Avl bal: Rs.8,500',
    sender: 'PNBSMS',
  ),

  SampleSms(
    body:
        'INR 899 spent on HDFC Bank Credit Card ending 1234 at FLIPKART INTERNET on 18-Mar-26',
    sender: 'HDFCBK',
  ),

  SampleSms(
    body:
        'Rs.6,000 debited from your A/c no. XXXXX2222 on 21-03-26 via NEFT. Avl bal: Rs.45,000',
    sender: 'AXISBK',
  ),

  SampleSms(
    body:
        'Txn of Rs 450 done on ICICI Card xx7890 at ZOMATO on 22-Mar-26. Avl limit Rs 50,000',
    sender: 'ICICIB',
  ),

  SampleSms(
    body:
        'Rs 5,500 debited from A/c XX5555 via IMPS on 14-03-26 Ref No 77665544. Avl Bal Rs 23,000',
    sender: 'KOTAKB',
  ),

  SampleSms(
    body:
        'Rs.320.00 debited from A/c XX6666 on 15-03-26 at DMART POS. Avl Bal Rs.9,200',
    sender: 'YESBNK',
  ),

  SampleSms(
    body: 'INR 1,150 spent using your Card at AMAZON PAY INDIA on 16-Mar-26',
    sender: 'HDFCBK',
  ),

  SampleSms(
    body:
        'Rs 4,000 debited from your account XX7777 on 17-03-26 via IMPS Ref 77665544. Not you? Call bank',
    sender: 'SBMSMS',
  ),

  SampleSms(
    body:
        'Rs.2,300 spent on SBI Credit Card ending 7890 at BIG BAZAAR on 18-Mar-26',
    sender: 'SBICRD',
  ),

  SampleSms(
    body:
        'Rs 850 debited from A/c XX8888 on 19-03-26 via UPI. UPI Ref No 99887766',
    sender: 'AXISBK',
  ),

  SampleSms(
    body: 'Cash withdrawal Rs.1,750 from A/c XX9999 on 20-03-26 ATM ID S1234',
    sender: 'PNBSMS',
  ),

  SampleSms(
    body: 'Rs.600 debited from your A/c XX1212 at MEDPLUS on 21-03-26 via POS',
    sender: 'ICICIB',
  ),

  SampleSms(
    body:
        'Rs.10,000 credited to your A/c XX1234 on 05-02-26 via NEFT. Avl bal Rs.50,000',
    sender: 'SBIINB',
  ),

  SampleSms(
    body:
        'INR 5,000 credited to A/c XX5678 by IMPS Ref No 123456789 on 06-02-26',
    sender: 'HDFCBK',
  ),

  SampleSms(
    body: 'Rs.2,500 received in your account XX4321 via UPI Ref No 99887766',
    sender: 'ICICIB',
  ),

  SampleSms(
    body:
        'Rs 15,000 credited to your A/c XX6789 via RTGS on 11-02-26. Avl Bal Rs 1,20,000',
    sender: 'AXISBK',
  ),

  SampleSms(
    body: 'Rs.1,200 credited to A/c XX1111 via UPI on 20-02-26 Ref 22334455',
    sender: 'KOTAKB',
  ),

  // --- NEWLY ADDED BANKS ---
  // Canara Bank
  SampleSms(
    body: 'Rs. 500.00 paid to MerchantName, UPI Ref 123456789012.',
    sender: 'CNRBNK',
  ),
  SampleSms(
    body:
        'INR 1,250.50 has been DEBITED from your A/C XX1234. Avail.bal INR 15,400.00.',
    sender: 'CANBNK',
  ),

  // City Union Bank (CUB)
  SampleSms(
    body:
        'Your a/c no. X1234 debited for Rs. 1,000.00. Avl Bal 45,000.00. (UPI Ref no 123456789).',
    sender: 'CUBPNK',
  ),
  SampleSms(
    body:
        'Savings No X4321 credited with INR 2,500.00 BY NEFT TRF:REMITTER NAME.',
    sender: 'CUBBNK',
  ),

  // Dhanlaxmi Bank
  SampleSms(
    body:
        'INR 250.00 is debited from A/c X1234. Aval Bal is INR 4,500.00. UPI Ref no 123456789.',
    sender: 'DLXBNK',
  ),

  // --- NEWLY ADDED BANKS ---
  // Canara Bank
  SampleSms(
    body: 'Rs. 500.00 paid to MerchantName, UPI Ref 123456789012.',
    sender: 'CNRBNK',
  ),
  SampleSms(
    body:
        'INR 1,250.50 has been DEBITED from your A/C XX1234. Avail.bal INR 15,400.00.',
    sender: 'CANBNK',
  ),

  // City Union Bank (CUB)
  SampleSms(
    body:
        'Your a/c no. X1234 debited for Rs. 1,000.00. Avl Bal 45,000.00. (UPI Ref no 123456789).',
    sender: 'CUBPNK',
  ),
  SampleSms(
    body:
        'Savings No X4321 credited with INR 2,500.00 BY NEFT TRF:REMITTER NAME.',
    sender: 'CUBBNK',
  ),

  // Department of Post (DOP)
  SampleSms(
    body:
        'Acc No. 1234 debited with amount Rs. 2,000.00. Bal: Rs. 15,800.00. [REF123456789].',
    sender: 'DOPBNK',
  ),

  SampleSms(
    body:
        'SBI: Rs1000.0 credited to A/c XX1234 on 05Feb26 by NEFT:REF NO 1234567890. Bal:Rs15000.0',
    sender: 'VM-SBIINB',
  ),

  SampleSms(
    body:
        'INR 3,000 credited in your account XX2222 via IMPS. Avl Bal INR 15,000',
    sender: 'YESBNK',
  ),

  SampleSms(
    body:
        'Rs 7,500 credited to A/c XX3333 on 25-03-26 via NEFT Ref No 88997766',
    sender: 'PNBSMS',
  ),

  SampleSms(
    body: 'Rs.950 received via UPI in A/c XX4444 Ref No 77665544',
    sender: 'ICICIB',
  ),

  SampleSms(
    body: 'INR 12,000 credited to A/c XX5555 via RTGS. Avl Bal INR 2,00,000',
    sender: 'HDFCBK',
  ),

  SampleSms(
    body: 'Rs 2,000 credited to your account XX6666 via IMPS Ref No 44556677',
    sender: 'SBMSMS',
  ),

  SampleSms(
    body:
        'Rs.500 debited from A/c XX4545 on 22-03-26 via UPI/Ref 99887766. Avl bal Rs 5,000',
    sender: 'AXISBK',
  ),

  SampleSms(
    body: 'INR 1,000 credited to your account XX5656 via IMPS Ref No 11223344',
    sender: 'KOTAKB',
  ),

  SampleSms(
    body: 'Rs.2,750 spent on your Credit Card at AMAZON on 23-Mar-26',
    sender: 'HDFCBK',
  ),

  SampleSms(
    body:
        'Rs.9,000 credited to A/c XX6767 via NEFT on 24-03-26 Ref No 66778899',
    sender: 'SBIINB',
  ),

  SampleSms(
    body:
        'Rs.650 debited from A/c XX7878 via POS at RELIANCE SMART on 25-03-26',
    sender: 'ICICIB',
  ),

  // ── HDFC Bank ─────────────────────────────────────────────────────────────
  SampleSms(
    body:
        'Rs.5,000.00 debited from A/c **1234 on 01-Apr-25. Avbl Bal: Rs.12,350.00. Call 18002586161 for dispute.',
    sender: 'VM-HDFCBK',
  ),

  SampleSms(
    body:
        'Rs.850.00 debited from A/c **1234 on 02-Apr-25. Avbl Bal: Rs.11,500.00. Call 18002586161 for dispute.',
    sender: 'VM-HDFCBK',
  ),

  SampleSms(
    body:
        'Rs.25,000.00 credited to A/c **1234 on 01-Apr-25. Avbl Bal: Rs.36,500.00.',
    sender: 'VM-HDFCBK',
  ),

  SampleSms(
    body:
        'Rs.1,200.00 credited to A/c **1234 on 03-Apr-25. Avbl Bal: Rs.37,700.00.',
    sender: 'VM-HDFCBK',
  ),

  SampleSms(
    body:
        'INR 499.00 spent on HDFC Bank Credit Card **5678 at AMAZON INDIA on 02-Apr-2025. Available Limit: INR 45,001.00.',
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

  // ── IndusInd Bank ─────────────────────────────────────────────────────────
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
];
