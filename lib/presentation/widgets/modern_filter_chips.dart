import 'package:flutter/material.dart';
import '../transaction_controller.dart';
import 'bank_selector_bar.dart';
import 'method_selection_tag.dart';

class ModernFilterBar extends StatelessWidget {
  final TransactionController controller;

  const ModernFilterBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BankSelectorBar(controller: controller),
        MethodSelectionTag(controller: controller),
      ],
    );
  }
}
