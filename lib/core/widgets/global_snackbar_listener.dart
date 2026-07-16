import 'package:expense_tracker/core/providers/app_message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A wrapper widget that listens to [appMessageProvider] and automatically
/// displays SnackBars when a message is dispatched by any Notifier.
/// 
/// Place this high in the widget tree (e.g., wrapping the router's child)
/// so that it has access to Scaffold's snackbar system.
class GlobalSnackbarListener extends ConsumerWidget {
  final Widget child;

  const GlobalSnackbarListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AppMessage?>(appMessageProvider, (previous, next) {
      if (next == null) return;

      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(next.text),
          backgroundColor: next.isError ? Colors.red.shade700 : Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );

      // Clear after showing so it doesn't re-trigger on widget rebuild
      Future.microtask(() {
        ref.read(appMessageProvider.notifier).clear();
      });
    });

    return child;
  }
}
