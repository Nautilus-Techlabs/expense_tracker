import json
import re

federal_sms = [
    "Dear Customer, Rs.100 credited to your A/c XX2814 on 11SEP2024 15:22:29. BAL-Rs.480.91-Federal Bank",
    "Dear Customer, Rs.443 debited from your A/c XX2814 towards non-maintenance of Average Monthly Balance in your account on 11SEP2024 15:34:11. BAL-Rs.37.91-Federal Bank",
    "Hi, payment of INR 1750.00 for Google Play via e-mandate ID: XzOaZEsoKJ on Federal Bank Debit Card 2014 is processed successfully. To manage, visit: https://www.sihub.in /managesi/federal T&CA - Federal Bank",
    "INR 100.00 sent from your Account XXXXXXXX5721 Mode: UPI  To: paytmqr281005050101pl59klibw 7ux@paytm Date: September 21, 2022 Not done by you? Call 080-47485490-Federal Bank",
    "INR 90.00 sent from your account XXXXXXXX5721 Sent to your beneficiary on September 21, 2022. If this transaction wasn't done by you, call 080-47485490-Federal Bank",
    "Rs.1 debited by ECOM Txn using your card XX0787 at WWW OLACABS COM on 14JUN2019 15:56:42.BAL-Rs. 1877.12.Call 18004251199, if not done by you-Federal Bank"
]

au_sms = [
    "Alert! Your AU Bank A/c No. X9318 has been Debited with INR 71.07 on 26-DEC-2025 for Debit Card Fee FY25'26 XX7022. Avl Bal: INR 0.00.- AU Bank",
    "Alert! Your AU Bank A/c No. xxx1234 has been Debited with INR 352.82 on 16-DEC-2025 for Debit Card Fee FY25'26 Avl Bal: 500 INR",
    "Thank you AU Bank Credit Cardholder! Payment of INR 20,685.00 was credited to your Card xx7750 on 12/10/2024. -AU Bank",
    "INR 100.00 spent at Amazon on 15-Mar-2024. Avl Bal: INR 5000.00"
]

with open('e:/P-Code/expense_tracker/assets/bank_configs.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

for bank in data['banks']:
    if bank['bankName'] == 'Federal Bank':
        print("\\n=== Federal Bank ===")
        for sms in federal_sms:
            matched = False
            for template in bank['templates']:
                match = re.search(template['pattern'], sms, re.IGNORECASE)
                if match:
                    print(f"Matched '{template['name']}' -> {match.groups()}")
                    matched = True
                    break
            if not matched:
                print(f"FAILED: {sms}")
                
    if bank['bankName'] == 'AU Small Finance Bank':
        print("\\n=== AU Small Finance Bank ===")
        for sms in au_sms:
            matched = False
            for template in bank['templates']:
                match = re.search(template['pattern'], sms, re.IGNORECASE)
                if match:
                    print(f"Matched '{template['name']}' -> {match.groups()}")
                    matched = True
                    break
            if not matched:
                print(f"FAILED: {sms}")
