import '../core/constants/app_constants.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'parsers/entities/transaction.dart';
import '../data/sample_data.dart';
import 'sms_parser.dart';

class SmsService {
  static const String _lastSyncKey = 'last_sms_sync_timestamp';
  static const String _unsupportedLogsKey = 'unsupported_sms_logs';
  final SmsQuery _query = SmsQuery();
  final SmsParserEngine _parser = SmsParserEngine();

  SmsService();

  /// Gets the last sync date from SharedPreferences
  Future<DateTime?> getLastSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastSyncKey);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
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
      // Fallback to sample data if permission is not given
      return _parser.parseBatch(
        sampleSms
            .map((s) => (body: s.body, sender: s.sender, date: s.date))
            .toList(),
      );
    }

    // 2. Determine time window
    final lastSync = forceAll ? null : await getLastSyncDate();

    // 3. Fetch messages
    // Note: We limit to 5000 messages to prevent hanging on massive inboxes
    final List<SmsMessage> messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
      count: 5000,
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
      final sender = (msg.address ?? '').toUpperCase();

      // 🚫 EXCLUSION: Ignore common non-bank senders (PhonePe, Paytm, etc.)
      if (AppConstants.ignoredSenders.any(
        (ignored) => sender.contains(ignored),
      )) {
        return false;
      }

      // Pattern 1: Contains a hyphen (very common for bank headers)
      if (sender.contains('-')) return true;

      // Pattern 2: Is not a standard 10-digit mobile number
      final cleanNumeric = sender.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanNumeric.length < 8 || cleanNumeric.length > 13) return true;

      // Pattern 3: Common bank codes (Fallback)
      final commonBankSubstrings = [
        'HDFC',
        'ICICI',
        'SBI',
        'AXIS',
        'KOTAK',
        'BANK',
      ];
      if (commonBankSubstrings.any((code) => sender.contains(code)))
        return true;

      return false;
    }).toList();

    if (filteredMessages.isEmpty) return [];

    // 5. Parse Messages
    final transactions = _parser.parseBatch(
      filteredMessages
          .map((m) => (body: m.body ?? '', sender: m.address, date: m.date))
          .toList(),
    );

    // 6. Monitor and log unsupported transactions
    _logUnsupported(transactions);

    // 7. Update Sync Date to the newest message processed
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
    if (!status.isGranted)
      return 0; // Return 0 to avoid nagging if no permission

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

  /// Saves unverified raw SMS to persistent storage for later analysis
  Future<void> _logUnsupported(List<Transaction> transactions) async {
    final unverified = transactions.where((tx) => !tx.isVerified).toList();
    if (unverified.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getStringList(_unsupportedLogsKey) ?? [];

    bool updated = false;
    for (var tx in unverified) {
      if (!logs.contains(tx.rawSms)) {
        logs.add(tx.rawSms);
        updated = true;
      }
    }

    if (updated) {
      await prefs.setStringList(_unsupportedLogsKey, logs);
    }
  }

  /// Retrieves the list of raw SMS that couldn't be correctly verified
  Future<List<String>> getUnsupportedLogs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_unsupportedLogsKey) ?? [];
  }
}
