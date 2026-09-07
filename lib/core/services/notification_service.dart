import 'dart:convert';

import 'package:expense_tracker/core/constants/app_router.dart';
import 'package:expense_tracker/data/remote/supabase/supabase_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles FCM setup, token registration, and notification tap routing
/// for the app's `notifications` table / notify_users() delivery pipeline.
///
/// Expected `data` payload shape (set by the send-pending-notifications
/// edge function):
/// {
///   "notification_id": "123",
///   "type": "transaction_added" | "settlement_done" | "proceed_settlement"
///           | "circle_invite" | "member_removed" | "ownership_transferred"
///           | "circle_settled",
///   "ref_type": "circle" | "transaction" | "split" | "",
///   "ref_id": "45" | ""
/// }
class FCMService {
  final SupabaseHelper _supabase;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription =
      'Used for transaction, settlement, and circle activity alerts.';

  Map<String, dynamic>? _initialMessageData;
  bool _hasCheckedInitialMessage = false;
  bool _isInitialized = false;

  FCMService(this._supabase);

  Future<Map<String, dynamic>?> setupFirebaseMessaging() async {
    if (_isInitialized) {
      debugPrint('FCMService already initialized, skipping setup');
      return _initialMessageData;
    }

    try {
      await _initLocalNotifications();
      await _createAndroidNotificationChannel();

      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await _setFcmToken(fcmToken);
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        await _setFcmToken(token);
      });

      // Foreground: FCM does NOT auto-display a system notification,
      // so we show one ourselves via flutter_local_notifications.
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Foreground FCM message: ${message.data}');
        _showLocalNotification(message);
      });

      // App was backgrounded (not terminated) and user tapped the
      // system tray notification.
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('Notification tapped (from background): ${message.data}');
        _handleNotificationClick(message.data);
      });

      // App was terminated and opened via notification tap.
      // Only checked once per app session to avoid repeat navigation.
      if (!_hasCheckedInitialMessage) {
        final RemoteMessage? initialMessage = await FirebaseMessaging.instance
            .getInitialMessage();
        _hasCheckedInitialMessage = true;

        if (initialMessage != null) {
          debugPrint(
            'App opened from terminated state via notification: '
            '${initialMessage.data}',
          );
          _initialMessageData = initialMessage.data;
        }
      }

      _isInitialized = true;
      return _initialMessageData;
    } catch (e, stack) {
      debugPrint('Firebase setup failed: $e\n$stack');
    }
    return null;
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final Map<String, dynamic> data = jsonDecode(response.payload!);
            _handleNotificationClick(data);
          } catch (e) {
            debugPrint('Failed to parse notification payload: $e');
          }
        }
      },
    );
  }

  /// Required on Android 8+ before showing any notification on this
  /// channel, otherwise delivery is inconsistent across OEMs.
  Future<void> _createAndroidNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Maps the FCM data payload to the app's deep-link routes.
  ///
  /// NOTE: route paths below are a best guess based on our
  /// notification_type / notification_ref_type enums. Adjust to match
  /// your actual AppRouter route names.
  String? getRouteFromData(Map<String, dynamic> data) {
    debugPrint('Parsing notification data for route: $data');

    final String? type = data['type']?.toString();
    final String? refId = data['ref_id']?.toString();

    final bool hasRef = refId != null && refId.isNotEmpty;

    switch (type) {
      case 'circle_invite':
        return hasRef ? '/circles/$refId/invite' : '/circles';

      case 'transaction_added':
        // ref_type is 'split' -> ref_id is the transaction id
        return hasRef ? '/transactions/$refId' : null;

      case 'settlement_done':
      case 'proceed_settlement':
        // ref_type is 'circle' -> ref_id is the circle id
        return hasRef ? '/circles/$refId/ledger' : null;

      case 'ownership_transferred':
      case 'circle_settled':
        return hasRef ? '/circles/$refId' : null;

      case 'member_removed':
        // not delivered as a push notification per current design
        // (shown in the circle activity feed instead) — kept here
        // only as a safe fallback in case that changes later.
        return hasRef ? '/circles/$refId' : null;

      default:
        debugPrint('Unhandled notification type: $type');
        return null;
    }
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    final route = getRouteFromData(data);
    if (route != null) {
      debugPrint('Navigating to: $route');
      AppRouter.router.push(route);
    }
  }

  /// Clears the initial message data after it has been handled, so a
  /// logout/login within the same app session doesn't re-trigger the
  /// same navigation.
  void consumeInitialMessageData() {
    if (_initialMessageData != null) {
      debugPrint('Consuming initial notification message data');
      _initialMessageData = null;
    }
  }

  Future<void> requestNotificationPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted notification permission');
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await _setFcmToken(fcmToken);
        }
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        debugPrint('User granted provisional permission');
      } else {
        debugPrint('User declined notification permission');
      }
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.high,
        );
    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      id: notification.hashCode,
      body: notification.body,
      title: notification.title,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }

  Future<void> _setFcmToken(String token) async {
    try {
      await _supabase.updateOrInsertFcmToken(token);
    } catch (e) {
      debugPrint('Failed to update FCM token: $e');
    }
  }
}
