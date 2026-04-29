import 'package:flutter/material.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';
import 'bank_selector_bar.dart';
import 'method_selection_tag.dart';

class ModernFilterBar extends StatelessWidget {
  final TransactionState state;
  final TransactionController controller;

  const ModernFilterBar({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BankSelectorBar(state: state, controller: controller),
        MethodSelectionTag(state: state, controller: controller),
      ],
    );
  }
}
