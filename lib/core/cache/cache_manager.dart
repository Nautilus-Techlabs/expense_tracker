import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../features/auth/model/user_model.dart';
import '../../../features/personal_expenses/models/recurring_bill_model.dart';

final cacheManagerProvider = Provider<CacheManager>((ref) {
  return CacheManager();
});

class CacheManager {
  final _storage = const FlutterSecureStorage();

  static const String _userKey = 'user_data';
  static const String _themeKey = 'theme_mode';
  static const String _processedInvitesKey = 'processed_invites';
  static const String _recurringBillsKey = 'recurring_bills';

  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: _userKey, value: userJson);
  }

  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson != null) {
      try {
        return UserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }

  Future<void> saveThemeMode(String mode) async {
    await _storage.write(key: _themeKey, value: mode);
  }

  Future<String?> getThemeMode() async {
    return await _storage.read(key: _themeKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> saveProcessedInvite(int circleId) async {
    final currentInvites = await getProcessedInvites();
    if (!currentInvites.contains(circleId)) {
      currentInvites.add(circleId);
      await _storage.write(
        key: _processedInvitesKey,
        value: jsonEncode(currentInvites),
      );
    }
  }

  Future<List<int>> getProcessedInvites() async {
    final jsonStr = await _storage.read(key: _processedInvitesKey);
    if (jsonStr != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        return decoded.map((e) => e as int).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<void> setAppVersion(String appVersion) async {
    await _storage.write(key: 'appVersion', value: appVersion);
  }

  Future<void> saveRecurringBills(List<RecurringBillModel> bills) async {
    final jsonList = bills.map((b) => b.toJson()).toList();
    await _storage.write(key: _recurringBillsKey, value: jsonEncode(jsonList));
  }

  Future<List<RecurringBillModel>> getRecurringBills() async {
    final jsonStr = await _storage.read(key: _recurringBillsKey);
    if (jsonStr != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        return decoded
            .map((e) => RecurringBillModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }
}
