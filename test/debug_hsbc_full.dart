import 'dart:convert';
import 'dart:io';

class Transaction {
  final double? amount;
  final String? type;
  final String? account;
  final String? merchant;
  final String? templateName;
  final int score;

  Transaction({this.amount, this.type, this.account, this.merchant, this.templateName, required this.score});
}

void main() {
  final configFile = File('assets/bank_configs.json');
  final jsonStr = configFile.readAsStringSync();
  final Map<String, dynamic> root = jsonDecode(jsonStr);
  final List<dynamic> banks = root['banks'];

  const sms = 'Rs.40,000.00 credited to HSBC A/c XX1234 on 02-Apr-25. Avl Bal Rs.71,250.00.';
  print('📨 SMS: $sms\n');

  final List<Transaction> matches = [];

  for (var bank in banks) {
    final bankName = bank['bankName'];
    final templates = bank['templates'] as List;

    for (var tmpl in templates) {
      final patternStr = tmpl['pattern'];
      final regex = RegExp(patternStr, caseSensitive: false);
      final match = regex.firstMatch(sms);

      if (match != null) {
        final amountGroup = tmpl['amountGroup'];
        final accountGroup = tmpl['accountGroup'];
        final merchantGroup = tmpl['merchantGroup'];
        final type = tmpl['type'];
        final priority = tmpl['priority'] ?? 100;

        double? amount;
        if (amountGroup != null && amountGroup <= match.groupCount) {
          final raw = match.group(amountGroup);
          if (raw != null) amount = double.tryParse(raw.replaceAll(',', ''));
        }

        String? account;
        if (accountGroup != null && accountGroup <= match.groupCount) {
          account = match.group(accountGroup);
        }

        String? merchant;
        if (merchantGroup != null && merchantGroup <= match.groupCount) {
          merchant = match.group(merchantGroup);
        }

        int score = 0;
        if (amount != null) score += 50;
        if (merchant != null) score += 20;
        if (account != null) score += 15;
        score += (100 - (priority as int));

        matches.add(Transaction(
          amount: amount,
          type: type,
          account: account,
          merchant: merchant,
          templateName: '$bankName -> ${tmpl['name']}',
          score: score,
        ));
      }
    }
  }

  matches.sort((a, b) => b.score.compareTo(a.score));

  print('--- Potential Matches (Sorted by Score) ---');
  for (var m in matches) {
    print('[Score ${m.score}] ${m.templateName}');
    print('   Type: ${m.type}, Amount: ${m.amount}, Account: ${m.account}, Merchant: ${m.merchant}');
    print('');
  }
}
