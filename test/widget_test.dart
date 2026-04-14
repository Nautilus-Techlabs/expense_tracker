import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  testWidgets('Expense tracker smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that our app title exists.
    expect(find.text('Expense Tracker'), findsOneWidget);
    
    // Check for the "Total Balance" text in the dashboard header
    expect(find.text('Total Balance'), findsOneWidget);
  });
}
