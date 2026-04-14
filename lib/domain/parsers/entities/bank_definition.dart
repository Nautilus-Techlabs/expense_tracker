import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:expense_tracker/domain/parsers/entities/transaction.dart';

/// A single template for an SMS transaction.
class SmSTemplate {
  final String name;
  final RegExp pattern;
  final TransactionType type;

  // Group indexes for extraction
  final int? amountGroup;
  final int? merchantGroup;
  final int? accountGroup;
  final int? balanceGroup;
  final int? dateGroup;

  // Default values or overrides
  final PaymentMethod method;

  // High-level filtering
  final List<String> exclusionKeywords;
  final int priority;

  SmSTemplate({
    required this.name,
    required this.pattern,
    required this.type,
    this.amountGroup,
    this.merchantGroup,
    this.accountGroup,
    this.balanceGroup,
    this.method = PaymentMethod.unknown,
    this.exclusionKeywords = AppConstants.exclusionKeywords,
    this.priority = 100,
    this.dateGroup,
  });

  factory SmSTemplate.fromJson(Map<String, dynamic> json) {
    return SmSTemplate(
      name: json['name'] as String,
      pattern: RegExp(json['pattern'] as String, caseSensitive: false),
      type: TransactionType.fromString(json['type'] as String),
      amountGroup: json['amountGroup'] as int?,
      merchantGroup: json['merchantGroup'] as int?,
      accountGroup: json['accountGroup'] as int?,
      balanceGroup: json['balanceGroup'] as int?,
      method: PaymentMethod.fromString(json['method'] as String? ?? 'unknown'),
      exclusionKeywords:
          (json['exclusionKeywords'] as List<dynamic>?)?.cast<String>() ??
          AppConstants.exclusionKeywords,
      priority: json['priority'] as int? ?? 100,
      dateGroup: json['dateGroup'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'pattern': pattern.pattern,
    'type': type.name,
    'amountGroup': amountGroup,
    'merchantGroup': merchantGroup,
    'accountGroup': accountGroup,
    'balanceGroup': balanceGroup,
    'method': method.name,
    'exclusionKeywords': exclusionKeywords,
    'priority': priority,
  };

  bool matches(String sms) {
    final lower = sms.toLowerCase();
    if (exclusionKeywords.any((k) => lower.contains(k))) return false;
    return pattern.hasMatch(sms);
  }
}

class BankDefinition {
  final String bankName;
  final List<String> senderIdentifiers;
  final List<SmSTemplate> templates;

  BankDefinition({
    required this.bankName,
    required this.senderIdentifiers,
    required this.templates,
  });

  factory BankDefinition.fromJson(Map<String, dynamic> json) {
    return BankDefinition(
      bankName: json['bankName'] as String,
      senderIdentifiers: (json['senderIdentifiers'] as List<dynamic>)
          .cast<String>(),
      templates: (json['templates'] as List<dynamic>)
          .map((t) => SmSTemplate.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'bankName': bankName,
    'senderIdentifiers': senderIdentifiers,
    'templates': templates.map((t) => t.toJson()).toList(),
  };

  bool canHandle(String sender) {
    final s = sender.toUpperCase();
    return senderIdentifiers.any((id) => s.contains(id.toUpperCase()));
  }
}
