import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bigbluebuttonsdk_method_channel.dart';

class CallNotificationService {
  static MethodChannelBigbluebuttonsdk? _sdkInstance;

  static void initializeSdkInstance(MethodChannelBigbluebuttonsdk sdk) {
    _sdkInstance = sdk;
  }

  static MethodChannelBigbluebuttonsdk get _sdk {
    if (_sdkInstance == null) {
      throw Exception(
          'SDK instance not initialized. Call initializeSdkInstance first');
    }
    return _sdkInstance!;
  }

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isNotificationActive = false;

  static Future<void> initialize() async {
    // Request notification permissions
    await Permission.notification.request();

    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  static void _onNotificationResponse(NotificationResponse response) {
    final actionId = response.actionId;
    final payload = response.payload;
    print('Notification actionId: $actionId, payload: $payload');
    switch (actionId) {
      case 'unmute':
        _handleUnmute();
        break;
      case 'hangup':
        _handleHangup();
        break;
      default:
        // If no actionId, treat as notification tap
        if (payload == 'call_tap') {
          _handleCallTap();
        }
        break;
    }
  }

  static Future<void> _handleUnmute() async {
    print('Unmute button pressed');
    // Get the Bigbluebuttonsdk instance and call endroom
    await _sdk.mutemyself();
    // Handle unmute logic
    // You might want to communicate with your calling service here
  }

  static void _handleHangup() async {
    print('Hang up button pressed');
    // Get the Bigbluebuttonsdk instance and call endroom
    if (_sdk.mydetails != null && _sdk.mydetails!.fields!.role == "MODERATOR") {
      await _sdk.endroom();
    } else {
      _sdk.leaveroom();
    }

    // Dismiss the notification
    await dismissCallNotification();
  }

  static void _handleCallTap() {
    print('Call notification tapped');
    // Handle opening the call screen
  }

  static Future<void> showCallNotification({
    required String title,
    required String status,
    bool isReconnecting = false,
  }) async {
    const String channelId = 'call_channel';
    const String channelName = 'Call Notifications';
    const String channelDescription = 'Notifications for ongoing calls';

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
      playSound: false,
      enableVibration: false,
      // Make channel non-dismissable
      enableLights: true,
      ledColor: Color(0xFF6366F1),
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Create action buttons
    final List<AndroidNotificationAction> actions = [
      // if (_sdk.mydetails.fields != null)
      AndroidNotificationAction(
        'unmute',
        _sdk.mydetails?.fields?.muted == true ? 'Unmute' : 'Mute',
        showsUserInterface: true,
        cancelNotification: false,
      ),
      const AndroidNotificationAction(
        'hangup',
        'Hang up',
        showsUserInterface: true,
        cancelNotification: true,
      ),
    ];

    // Android notification details
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true, // Makes it persistent
      autoCancel: false,
      onlyAlertOnce: true, // Prevents repeated alerts
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      usesChronometer: false,
      chronometerCountDown: false,
      actions: actions,
      // Custom layout styling
      color: const Color(0xFF6366F1), // Blue color for call
      colorized: true,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      // Style as a call notification
      category: AndroidNotificationCategory.call,
      fullScreenIntent: false,
      // Make it non-dismissable
      timeoutAfter: null, // No timeout
      // Custom sound (optional)
      // sound: RawResourceAndroidNotificationSound('call_sound'),
    );

    // iOS notification details
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
      interruptionLevel: InterruptionLevel.timeSensitive,
      categoryIdentifier: 'call_category',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Show the notification
    await _notificationsPlugin.show(
      0, // Notification ID
      title,
      status,
      notificationDetails,
      payload: 'call_tap',
    );

    _isNotificationActive = true;
  }

  static Future<void> updateCallNotification({
    required String title,
    required String status,
    required String time,
  }) async {
    // Update the existing notification
    await showCallNotification(
      title: title,
      status: status,
    );
  }

  static Future<void> dismissCallNotification() async {
    _isNotificationActive = false;
    await _notificationsPlugin.cancel(0);
  }

  // Method to check if notification is active
  static bool get isNotificationActive => _isNotificationActive;

  // Method to force show notification if dismissed externally
  static Future<void> ensureNotificationExists({
    required String title,
    required String status,
  }) async {
    if (_isNotificationActive) {
      // Check if notification still exists, if not, recreate it
      await showCallNotification(
        title: title,
        status: status,
      );
    }
  }

  // For iOS, you need to configure categories with actions
  static Future<void> configureIOSCategories() async {
    DarwinNotificationCategory callCategory = DarwinNotificationCategory(
      'call_category',
      actions: [
        DarwinNotificationAction.plain(
          'unmute',
          'Unmute',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'hangup',
          'Hang up',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
      ],
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
