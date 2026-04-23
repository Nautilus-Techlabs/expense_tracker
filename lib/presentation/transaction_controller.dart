import 'package:flutter/material.dart';
import '../domain/sms_service.dart';
import '../domain/parsers/entities/transaction.dart';

enum TransactionSort { dateDesc, dateAsc, amountDesc, amountAsc }

class TransactionController extends ChangeNotifier {
  final SmsService _smsService = SmsService();
  
  List<Transaction> _allTransactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Filters
  String? _selectedBank;
  PaymentMethod? _selectedMethod;
  TransactionSort _currentSort = TransactionSort.dateDesc;

  // Getters
  List<Transaction> get transactions => _getFilteredAndSortedTransactions();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedBank => _selectedBank;
  PaymentMethod? get selectedMethod => _selectedMethod;
  TransactionSort get currentSort => _currentSort;

  // Summary Data
  double get totalDebit => transactions
      .where((t) => t.type == TransactionType.debit)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalCredit => transactions
      .where((t) => t.type == TransactionType.credit)
      .fold(0, (sum, t) => sum + t.amount);

  double get balance => totalCredit - totalDebit;

  Future<void> syncTransactions() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newTransactions = await _smsService.syncTransactions(forceAll: true);
      
      // Merge unique transactions
      final existingSms = _allTransactions.map((t) => t.rawSms).toSet();
      for (var tx in newTransactions) {
        if (!existingSms.contains(tx.rawSms)) {
          _allTransactions.add(tx);
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void setBankFilter(String? bank) {
    _selectedBank = bank;
    notifyListeners();
  }

  void setMethodFilter(PaymentMethod? method) {
    _selectedMethod = method;
    notifyListeners();
  }

  void setSort(TransactionSort sort) {
    _currentSort = sort;
    notifyListeners();
  }

  List<String> getAvailableBanks() {
    final banks = _allTransactions
        .where((t) => t.isVerified)
        .map((t) => t.bankName)
        .toSet()
        .toList()
      ..sort();
    return banks;
  }

  bool hasUnsupportedTransactions() {
    return _allTransactions.any((t) => !t.isVerified);
  }

  List<PaymentMethod> getAvailableMethods() {
    return _allTransactions
        .map((t) => t.method)
        .where((m) => m != PaymentMethod.unknown)
        .toSet()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  List<Transaction> _getFilteredAndSortedTransactions() {
    final filtered = _allTransactions.where((t) {
      // Bank filter
      bool matchesBank = true;
      if (_selectedBank != null) {
        if (_selectedBank == 'unsupported') {
          matchesBank = !t.isVerified;
        } else {
          matchesBank = t.isVerified && t.bankName == _selectedBank;
        }
      }

      // Method filter
      bool matchesMethod = true;
      if (_selectedMethod != null) {
        matchesMethod = t.method == _selectedMethod;
      }

      return matchesBank && matchesMethod;
    }).toList();

    // Sorting
    switch (_currentSort) {
      case TransactionSort.dateDesc:
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case TransactionSort.dateAsc:
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case TransactionSort.amountDesc:
        filtered.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case TransactionSort.amountAsc:
        filtered.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    return filtered;
  }
}
