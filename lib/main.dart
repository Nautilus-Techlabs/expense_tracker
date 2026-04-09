import 'package:expense_tracker/presentation/transaction_list_screen.dart';
import 'package:flutter/material.dart';
import 'domain/parsers/flutter_parser_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterParserInitializer.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0EA5E9), // Sky 500
          brightness: Brightness.light,
          surface: const Color(0xFFF8FAFC), // Slate 50
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9), // Slate 100
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF38BDF8), // Sky 400
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B), // Slate 800
          background: const Color(0xFF0F172A), // Slate 900
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFFF8FAFC),
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFF1F5F9),
          ),
        ),
      ),
      home: const TransactionListScreen(),
    );
  }
}
