import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import 'sms_parser.dart';

class SmsService {
  static const String _lastSyncKey = 'last_sms_sync_timestamp';
  final SmsQuery _query = SmsQuery();
  final SmsParserEngine _parser = SmsParserEngine();

  /// Gets the last sync date from SharedPreferences
  Future<DateTime?> getLastSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastSyncKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  /// Updates the last sync date in SharedPreferences
  Future<void> updateLastSyncDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSyncKey, date.millisecondsSinceEpoch);
  }

  /// Main sync method: fetches, filters, and parses new messages
  Future<List<Transaction>> syncTransactions({bool forceAll = false}) async {
    // 1. Check Permissions
    final status = await Permission.sms.request();
    if (!status.isGranted) {
      throw Exception('SMS permission not granted');
    }

    // 2. Determine time window
    final lastSync = forceAll ? null : await getLastSyncDate();
    
    // 3. Fetch messages
    // Note: We limit to 500 messages to prevent hanging on massive inboxes
    final List<SmsMessage> messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
      count: 500,
    );

    if (messages.isEmpty) return [];

    // 4. Apply Smart Filtering (Non-mobile headers + Date)
    final filteredMessages = messages.where((msg) {
      // Filter by Date
      if (lastSync != null && msg.date != null) {
        if (!msg.date!.isAfter(lastSync)) return false;
      }

      // Smart Filter: Filter for alphanumeric headers (like VM-HDFCBK) 
      // instead of 10-digit mobile numbers.
      final sender = msg.address ?? '';
      
      // Pattern 1: Contains a hyphen (very common for bank headers)
      if (sender.contains('-')) return true;
      
      // Pattern 2: Is not a standard 10-digit mobile number
      final cleanNumeric = sender.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanNumeric.length < 8 || cleanNumeric.length > 13) return true;

      // Pattern 3: Common bank codes (Fallback)
      final commonBankSubstrings = [
        'HDFC', 'ICICI', 'SBI', 'AXIS', 'KOTAK', 'PAYTM', 'GPAY', 'AMEX', 'BANK'
      ];
      if (commonBankSubstrings.any((code) => sender.toUpperCase().contains(code))) return true;

      return false;
    }).toList();

    if (filteredMessages.isEmpty) return [];

    // 5. Parse Messages
    final rawTexts = filteredMessages.map((m) => m.body ?? '').toList();
    final transactions = _parser.parseBatch(
      rawTexts,
      fallbackDate: null, // Parser will extract date from SMS body if possible
    );

    // 6. Update Sync Date to the newest message processed
    if (filteredMessages.isNotEmpty) {
      final newestDate = filteredMessages
          .map((m) => m.date ?? DateTime(2000))
          .reduce((a, b) => a.isAfter(b) ? a : b);
      await updateLastSyncDate(newestDate);
    }

    return transactions;
  }

  /// Quickly check how many new messages might be available
  Future<int> getRemainingCount() async {
    final status = await Permission.sms.status;
    if (!status.isGranted) return 0;

    final lastSync = await getLastSyncDate();
    if (lastSync == null) return -1; // First time sync

    final messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
      count: 100,
    );
    return messages.where((msg) {
      return msg.date != null && msg.date!.isAfter(lastSync);
    }).length;
  }
}
