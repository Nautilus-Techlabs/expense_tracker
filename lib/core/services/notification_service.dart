// import 'dart:math';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import '../utils/app_logger.dart';
//
// class NotificationService {
//   NotificationService._();
//
//   static final NotificationService instance = NotificationService._();
//
//   final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();
//
//   Future<void> initialize() async {
//     tz.initializeTimeZones();
//
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//     );
//
//     await _notifications.initialize(
//       settings: settings,
//       onDidReceiveNotificationResponse: _onNotificationTapped,
//     );
//
//     await _requestAndroidPermission();
//   }
//
//   /// Schedules two randomized notifications for the coming week
//   /// if accounts are missing initial balances.
//   Future<void> scheduleBalanceReminders({
//     required List<String> missingBanks,
//   }) async {
//     // Clear previous reminder notifications
//     await cancelNotification(101);
//     await cancelNotification(102);
//
//     if (missingBanks.isEmpty) {
//       AppLogger.i('No missing balances. Skipping reminder scheduling.');
//       return;
//     }
//
//     const String title = 'Complete Your Setup';
//
//     final String body = missingBanks.length == 1
//         ? 'Set the initial balance for ${missingBanks.first} to see your accurate total.'
//         : 'You have ${missingBanks.length} accounts waiting for initial balances. Set them now!';
//
//     final random = Random();
//
//     // Reminder 1: Random time within next 3 days
//     final slot1OffsetMinutes = random.nextInt(3 * 24 * 60);
//     final slot1Date = DateTime.now().add(
//       Duration(minutes: 60 + slot1OffsetMinutes),
//     );
//
//     await scheduleNotification(
//       id: 101,
//       title: title,
//       body: body,
//       scheduledDate: slot1Date,
//     );
//
//     // Reminder 2: Random time between day 4 and day 7
//     final slot2OffsetMinutes = random.nextInt(3 * 24 * 60);
//     final slot2Date = DateTime.now().add(
//       Duration(days: 4, minutes: slot2OffsetMinutes),
//     );
//
//     await scheduleNotification(
//       id: 102,
//       title: title,
//       body: body,
//       scheduledDate: slot2Date,
//     );
//
//     AppLogger.i(
//       'Scheduled 2 random balance reminders for ${missingBanks.join(', ')}',
//     );
//   }
//
//   Future<void> cancelAllReminders() async {
//     await cancelNotification(101);
//     await cancelNotification(102);
//   }
//
//   Future<void> _requestAndroidPermission() async {
//     final androidImplementation = _notifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >();
//
//     await androidImplementation?.requestNotificationsPermission();
//     await androidImplementation?.requestExactAlarmsPermission();
//   }
//
//   void _onNotificationTapped(NotificationResponse response) {
//     debugPrint('Notification tapped: ${response.payload}');
//   }
//
//   NotificationDetails _notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'alarm_channel_id',
//         'Alarm Notifications',
//         channelDescription: 'Notification channel for alarms',
//         importance: Importance.max,
//         priority: Priority.high,
//         playSound: true,
//         enableVibration: true,
//       ),
//     );
//   }
//
//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//     String? payload,
//   }) async {
//     final tz.TZDateTime tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
//
//     await _notifications.zonedSchedule(
//       id: id,
//       title: title,
//       body: body,
//       scheduledDate: tzDate,
//       notificationDetails: _notificationDetails(),
//       payload: payload,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }
//
//   Future<void> cancelNotification(int id) async {
//     await _notifications.cancel(id: id);
//   }
// }
