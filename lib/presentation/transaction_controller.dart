import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/transaction.dart';
import '../domain/sms_service.dart';

enum TransactionSort { dateDesc, dateAsc, amountDesc, amountAsc }

class TransactionController extends ChangeNotifier {
  static const String _storageKey = 'persisted_transactions_v2';

  final SmsService _smsService = SmsService();

  List<Transaction> _allTransactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _debugInfo = "";
  bool _isShowingSampleData = false;

  // Filters
  String? _selectedBank;
  PaymentMethod? _selectedMethod;
  TransactionSort _currentSort = TransactionSort.dateDesc;

  TransactionController() {
    _init();
  }

  Future<void> _init() async {
    await loadFromStorage();
    await syncTransactions(isStartup: true);
  }

  // Getters
  List<Transaction> get transactions => _getFilteredAndSortedTransactions();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get debugInfo => _debugInfo;
  String? get selectedBank => _selectedBank;
  PaymentMethod? get selectedMethod => _selectedMethod;
  TransactionSort get currentSort => _currentSort;
  bool get isShowingSampleData => _isShowingSampleData;

  // Summary Data
  double get totalDebit => transactions
      .where((t) => t.type == TransactionType.debit)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalCredit => transactions
      .where((t) => t.type == TransactionType.credit)
      .fold(0, (sum, t) => sum + t.amount);

  double get balance => totalCredit - totalDebit;

  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null) {
        final List<dynamic> decoded = json.decode(jsonStr);
        _allTransactions = decoded.map((m) => Transaction.fromMap(m)).toList();
        _isShowingSampleData = false;
        notifyListeners();
      }
    } catch (e) {
      _debugInfo += "Load Error: $e\n";
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final realTransactions = _allTransactions
          .where((t) => !t.isSample)
          .toList();
      final jsonStr = json.encode(
        realTransactions.map((t) => t.toMap()).toList(),
      );
      await prefs.setString(_storageKey, jsonStr);
    } catch (e) {
      _debugInfo += "Save Error: $e\n";
    }
  }

  Future<void> syncTransactions({bool isStartup = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    _debugInfo = "Sync started (${isStartup ? 'Startup' : 'Manual'})...\n";
    notifyListeners();

    try {
      final fetched = await _smsService.syncTransactions(
        forceAll: !isStartup,
        onDebug: (msg) {
          _debugInfo += "$msg\n";
          notifyListeners();
        },
      );

      bool hasRealDataInResult = fetched.any((t) => !t.isSample);

      if (hasRealDataInResult) {
        _isShowingSampleData = false;

        final existingSms = _allTransactions
            .where((t) => !t.isSample)
            .map((t) => t.rawSms)
            .toSet();
        final List<Transaction> merged = _allTransactions
            .where((t) => !t.isSample)
            .toList();

        for (var tx in fetched) {
          if (!tx.isSample && !existingSms.contains(tx.rawSms)) {
            merged.add(tx);
          }
        }

        _allTransactions = merged;
        await _saveToStorage();
      } else {
        if (_allTransactions.isNotEmpty &&
            _allTransactions.any((t) => !t.isSample)) {
          _isShowingSampleData = false;
        } else if (fetched.isNotEmpty && fetched.every((t) => t.isSample)) {
          _allTransactions = fetched;
          _isShowingSampleData = true;
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Sync failed: ${e.toString()}";
      _debugInfo += "Sync Exception: $e\n";
      notifyListeners();
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
    final banks =
        _allTransactions
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
      bool matchesBank = true;
      if (_selectedBank != null) {
        if (_selectedBank == 'unsupported') {
          matchesBank = !t.isVerified;
        } else {
          matchesBank = t.isVerified && t.bankName == _selectedBank;
        }
      }
      bool matchesMethod = true;
      if (_selectedMethod != null) {
        matchesMethod = t.method == _selectedMethod;
      }
      return matchesBank && matchesMethod;
    }).toList();

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
