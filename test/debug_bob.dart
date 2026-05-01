import 'package:expense_tracker/domain/parsers/flutter_parser_initializer.dart';
import 'package:expense_tracker/domain/sms_parser.dart';

void main() async {
  print("Initializing Parser...");
  await FlutterParserInitializer.initialize();
  final parser = SmsParserEngine();

  final List<String> bobMessages = [
    "Rs.10000 withdrawn from a/c ....00234 at ATM TID S@#D\$F%GG Ref. 605958934839483 Avlbl amt : rs. 20000",
    "Rs. 1000 Dr. from A/c xxxxxxxxx1298 and Cr. to 3246564646@okhdfc .",
    "DEar BOb up user , Your account is credited with 10ra. on 202-0908",
    "Rs.40.00 debited from a/c xxxxxx0987 and trf no - gpay-543543545 avl bal: rs 230000",
  ];

  print("Testing Bank of Baroda Parsing...");

  for (int i = 0; i < bobMessages.length; i++) {
    print("\n--- Message ${i + 1} ---");
    print("Raw: ${bobMessages[i]}");

    final tx = parser.parseSingle(
      body: bobMessages[i],
      sender: "BOBSMS",
      date: DateTime.now(),
    );

    if (tx != null) {
      print("✅ PARSED SUCCESS!");
      print("   Bank: ${tx.bankName}");
      print("   Amount: ${tx.amount}");
      print("   Type: ${tx.type.name}");
      print("   Account: ${tx.accountExtracted}");
      print("   Method: ${tx.method.name}");
      if (tx.merchantExtracted != null) {
        print("   Merchant: ${tx.merchantExtracted}");
      }
    } else {
      print("❌ FAILED TO PARSE");
    }
  }
}
