import 'package:expense_tracker/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Expense tracker smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ExpenseTrackerApp()));
    await tester.pumpAndSettle();

    // Verify that our app title exists.
    expect(find.text('Expense Tracker'), findsOneWidget);
  });
}
