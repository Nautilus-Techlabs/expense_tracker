// lib/services/notification_service.dart

import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../utils/app_logger.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestAndroidPermission();
  }

  /// Schedules two randomized notifications for the coming week if accounts are missing.
  Future<void> scheduleBalanceReminders({
    required List<String> missingBanks,
  }) async {
    // Clear specifically these reminder IDs
    await cancelNotification(101);
    await cancelNotification(102);

    if (missingBanks.isEmpty) {
      AppLogger.i("No missing balances. Skipping reminder scheduling.");
      return;
    }

    // Prepare message
    const String title = "Complete Your Setup";
    final String body = missingBanks.length == 1
        ? "Set the initial balance for ${missingBanks.first} to see your accurate total."
        : "You have ${missingBanks.length} accounts waiting for initial balances. Set them now!";

    // Schedule 2 random slots
    final random = Random();

    // Slot 1: Sometime in the next 3 days
    final slot1Offset = random.nextInt(3 * 24 * 60); // Random minute in next 72 hours
    final slot1Date = DateTime.now().add(Duration(minutes: 60 + slot1Offset));
    await scheduleNotification(
      id: 101,
      title: title,
      body: body,
      scheduledDate: slot1Date,
    );

    // Slot 2: Sometime between day 4 and day 7
    final slot2Offset = random.nextInt(3 * 24 * 60); // Random minute in another 72 hour window
    final slot2Date = DateTime.now().add(Duration(days: 4, minutes: slot2Offset));
    await scheduleNotification(
      id: 102,
      title: title,
      body: body,
      scheduledDate: slot2Date,
    );

    AppLogger.i(
      "Scheduled 2 random balance reminders for ${missingBanks.join(', ')}",
    );
  }

  Future<void> cancelAllReminders() async {
    await cancelNotification(101);
    await cancelNotification(102);
  }

  Future<void> _requestAndroidPermission() async {
    if (!Platform.isAndroid) return;

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImplementation?.requestNotificationsPermission();

    await androidImplementation?.requestExactAlarmsPermission();
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'alarm_channel_id',
        'Alarm Notifications',
        channelDescription: 'Notification channel for alarms',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _notificationDetails(),
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    final tz.TZDateTime tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzDate,
      notificationDetails: _notificationDetails(),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: _notificationDetails(),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _notifications.pendingNotificationRequests();
  }
}
