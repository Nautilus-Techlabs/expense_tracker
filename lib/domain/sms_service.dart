import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../data/local/app_database.dart';
import '../data/sample_data.dart';
import 'entities/transaction.dart';
import 'sms_parser.dart';

class SmsService {
  static const String _lastSyncKey = 'last_sms_sync_timestamp';
  static const String _unsupportedLogsKey = 'unsupported_sms_logs';
  final SmsQuery _query = SmsQuery();
  final SmsParserEngine _parser = SmsParserEngine();

  SmsService();

  Future<DateTime?> getLastSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastSyncKey);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  Future<void> updateLastSyncDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSyncKey, date.millisecondsSinceEpoch);
  }

  Future<List<Transaction>> syncTransactions({
    bool forceAll = false,
    Function(String)? onDebug,
    AppDatabase? db,
  }) async {
    // 1. Check Permissions
    final status = await Permission.sms.status;
    if (!status.isGranted) {
      onDebug?.call("Permission not granted: ${status.name}");
      return _parser
          .parseBatch(
            sampleSms
                .map((s) => (body: s.body, sender: s.sender, date: s.date))
                .toList(),
          )
          .map((t) => t.copyWith(isSample: true))
          .toList();
    }

    onDebug?.call("Permission granted. Querying SMS...");

    // 2. Determine time window
    final lastSync = forceAll ? null : await getLastSyncDate();

    // 3. Fetch messages
    final List<SmsMessage> messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
    );

    onDebug?.call("Found ${messages.length} total messages in inbox.");

    if (messages.isEmpty) return [];

    // 4. Apply Filtering
    int filteredOutCount = 0;
    final filteredMessages = messages.where((msg) {
      if (lastSync != null && msg.date != null) {
        if (!msg.date!.isAfter(lastSync)) {
          filteredOutCount++;
          return false;
        }
      }

      final sender = (msg.address ?? '').toUpperCase();

      // Skip common non-bank noise
      if (AppConstants.ignoredSenders.any(
        (ignored) => sender.contains(ignored),
      )) {
        filteredOutCount++;
        return false;
      }

      // Pattern 1: Alphanumeric headers (standard for banks)
      if (sender.contains(RegExp(r'[A-Z]'))) return true;

      // Pattern 2: Short codes (5-6 digits)
      final cleanNumeric = sender.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanNumeric.isNotEmpty && cleanNumeric.length <= 6) return true;

      filteredOutCount++;
      return false;
    }).toList();

    onDebug?.call(
      "Filtered out $filteredOutCount non-bank messages. Processing ${filteredMessages.length} potential bank SMS.",
    );

    if (filteredMessages.isEmpty) return [];

    // 5. Parse Messages
    final transactions = _parser.parseBatch(
      filteredMessages
          .map((m) => (body: m.body ?? '', sender: m.address, date: m.date))
          .toList(),
    );

    onDebug?.call("Successfully parsed ${transactions.length} transactions.");

    // 6. Log unsupported messages
    _logUnsupported(filteredMessages, transactions, db);

    // 7. Update last sync date
    if (filteredMessages.isNotEmpty && !forceAll) {
      final newestDate = filteredMessages
          .map((m) => m.date ?? DateTime(2000))
          .reduce((a, b) => a.isAfter(b) ? a : b);
      await updateLastSyncDate(newestDate);
    }

    return transactions;
  }

  void _logUnsupported(
    List<SmsMessage> raw,
    List<Transaction> parsed,
    AppDatabase? db,
  ) async {
    final parsedRawSms = parsed.map((t) => t.rawSms).toSet();
    final unsupported = raw
        .where((m) => !parsedRawSms.contains(m.body))
        .toList();
    if (unsupported.isEmpty || db == null) return;

    final companions = unsupported.map((m) {
      return SmsLogsCompanion.insert(
        timestamp: m.date ?? DateTime.now(),
        sender: m.address ?? 'Unknown',
        body: m.body ?? '',
      );
    }).toList();

    await db.insertSmsLogs(companions);
  }
}
