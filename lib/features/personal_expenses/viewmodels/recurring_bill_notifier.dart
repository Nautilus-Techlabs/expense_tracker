import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/cache/cache_manager.dart';
import '../models/recurring_bill_model.dart';

final recurringBillNotifierProvider =
    NotifierProvider<RecurringBillNotifier, List<RecurringBillModel>>(
  RecurringBillNotifier.new,
);

class RecurringBillNotifier extends Notifier<List<RecurringBillModel>> {
  late final CacheManager _cacheManager;

  @override
  List<RecurringBillModel> build() {
    _cacheManager = ref.read(cacheManagerProvider);
    _loadBills();
    return [];
  }

  Future<void> _loadBills() async {
    final bills = await _cacheManager.getRecurringBills();
    state = bills;
  }

  Future<void> addBill(RecurringBillModel bill) async {
    final updated = [...state, bill];
    state = updated;
    await _cacheManager.saveRecurringBills(updated);
  }

  Future<void> updateBill(RecurringBillModel updatedBill) async {
    final updated = state.map((b) => b.id == updatedBill.id ? updatedBill : b).toList();
    state = updated;
    await _cacheManager.saveRecurringBills(updated);
  }

  Future<void> deleteBill(String id) async {
    final updated = state.where((b) => b.id != id).toList();
    state = updated;
    await _cacheManager.saveRecurringBills(updated);
  }

  Future<void> markAsLogged(String id, DateTime date) async {
    final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    final updated = state.map((b) {
      if (b.id == id) {
        return b.copyWith(lastLoggedMonth: monthKey);
      }
      return b;
    }).toList();
    state = updated;
    await _cacheManager.saveRecurringBills(updated);
  }

  List<RecurringBillModel> getDueBills({DateTime? forDate}) {
    final now = forDate ?? DateTime.now();
    return state.where((bill) => bill.isDueForMonth(now)).toList();
  }
}
