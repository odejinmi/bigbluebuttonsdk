import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart'
    hide NotificationVisibility;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../bigbluebuttonsdk_method_channel.dart';

class CallNotificationService {
  static MethodChannelBigbluebuttonsdk? _sdkInstance;
  static Timer? _keepAliveTimer;
  static bool _isCallActive = false;

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
    // Request all necessary permissions
    await _requestPermissions();

    // Initialize notifications
    await _initializeNotifications();

    // Initialize background service
    // await _initializeBackgroundService();

    // Configure iOS categories
    await configureIOSCategories();
  }

  static Future<void> _requestPermissions() async {
    // Request notification permissions
    await Permission.notification.request();

    // Request phone permission for call-related features
    await Permission.phone.request();

    // Request system alert window permission (Android)
    await Permission.systemAlertWindow.request();

    // Request ignore battery optimization (Android)
    await Permission.ignoreBatteryOptimizations.request();
  }

  static Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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

  // static Future<void> _initializeBackgroundService() async {
  //   final service = FlutterBackgroundService();
  //
  //   await service.configure(
  //     androidConfiguration: AndroidConfiguration(
  //       onStart: onStart,
  //       autoStart: false,
  //       isForegroundMode: true,
  //       notificationChannelId: 'call_background_service',
  //       initialNotificationTitle: 'Call Service',
  //       initialNotificationContent: 'Keeping call connection active',
  //       foregroundServiceNotificationId: 888,
  //     ),
  //     iosConfiguration: IosConfiguration(
  //       autoStart: false,
  //       onForeground: onStart,
  //       onBackground: onIosBackground,
  //     ),
  //   );
  // }
  //
  // // Background service entry point
  // @pragma('vm:entry-point')
  // static void onStart(ServiceInstance service) async {
  //   DartPluginRegistrant.ensureInitialized();
  //
  //   if (service is AndroidServiceInstance) {
  //     service.on('setAsForeground').listen((event) {
  //       service.setAsForegroundService();
  //     });
  //
  //     service.on('setAsBackground').listen((event) {
  //       service.setAsBackgroundService();
  //     });
  //   }
  //
  //   service.on('stopService').listen((event) {
  //     service.stopSelf();
  //   });
  //
  //   // Keep WebSocket alive with periodic ping
  //   Timer.periodic(const Duration(seconds: 30), (timer) async {
  //     if (!_isCallActive) {
  //       timer.cancel();
  //       service.stopSelf();
  //       return;
  //     }
  //
  //     // Send keep-alive signal to WebSocket
  //     try {
  //       // You might need to implement a keep-alive method in your SDK
  //       // await _sdk.sendKeepAlive();
  //       print('WebSocket keep-alive sent');
  //     } catch (e) {
  //       print('Keep-alive failed: $e');
  //     }
  //
  //     service.invoke(
  //       'update',
  //       {
  //         "current_date": DateTime.now().toIso8601String(),
  //       },
  //     );
  //   });
  // }
  //
  // @pragma('vm:entry-point')
  // static bool onIosBackground(ServiceInstance service) {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   print('iOS background fetch');
  //   return true;
  // }

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
        if (payload == 'call_tap') {
          _handleCallTap();
        }
        break;
    }
  }

  static Future<void> _handleUnmute() async {
    print('Unmute button pressed');
    await _sdk.mutemyself();
  }

  static void _handleHangup() async {
    print('Hang up button pressed');

    // Stop background processes
    await _stopBackgroundExecution();

    if (_sdk.mydetails != null && _sdk.mydetails!.fields!.role == "MODERATOR") {
      await _sdk.endroom();
    } else {
      _sdk.leaveroom();
    }

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
    // Start background execution when call starts
    await _startBackgroundExecution();

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
      enableLights: true,
      ledColor: Color(0xFF6366F1),
      showBadge: false,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final List<AndroidNotificationAction> actions = [
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

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      onlyAlertOnce: true,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      usesChronometer: false,
      actions: actions,
      color: const Color(0xFF6366F1),
      colorized: true,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      category: AndroidNotificationCategory.call,
      fullScreenIntent: false,
      timeoutAfter: null,
      // Additional flags to keep notification persistent
      visibility: NotificationVisibility.public,
    );

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

    await _notificationsPlugin.show(
      0,
      title,
      status,
      notificationDetails,
      payload: 'call_tap',
    );

    isNotificationActive = true;
  }

  static Future<void> _startBackgroundExecution() async {
    _isCallActive = true;

    // Enable wakelock to prevent device from sleeping
    await WakelockPlus.enable();

    // // Start background service
    // final service = FlutterBackgroundService();
    // var isRunning = await service.isRunning();
    // if (!isRunning) {
    //   service.startService();
    // }

    // Start foreground task for iOS
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Call Foreground Service',
        channelDescription: 'This notification appears when call is active.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        // iconData: const NotificationIconData(
        //   resType: ResourceType.mipmap,
        //   resPrefix: ResourcePrefix.ic,
        //   name: 'launcher',
        // ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        // interval: 5000,
        // isOnceEvent: false,
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: true,
        eventAction: ForegroundTaskEventAction.repeat(5000),
      ),
    );

    await FlutterForegroundTask.startService(
      notificationTitle: 'Call Active',
      notificationText: 'Keeping connection alive',
      callback: startCallback,
    );
  }

  static Future<void> _stopBackgroundExecution() async {
    _isCallActive = false;

    // Disable wakelock
    await WakelockPlus.disable();

    // Stop background service
    // final service = FlutterBackgroundService();
    // service.invoke("stopService");

    // Stop foreground task
    await FlutterForegroundTask.stopService();

    // Cancel keep-alive timer
    _keepAliveTimer?.cancel();
  }

  // Foreground task callback
  @pragma('vm:entry-point')
  static void startCallback() {
    FlutterForegroundTask.setTaskHandler(MyTaskHandler());
  }

  static Future<void> updateCallNotification({
    required String title,
    required String status,
    required String time,
  }) async {
    await showCallNotification(
      title: title,
      status: status,
    );
  }

  static Future<void> dismissCallNotification() async {
    print('Dismissing call notification');
    isNotificationActive = false;

    await _notificationsPlugin.cancel(0);
    await _stopBackgroundExecution();
  }

  static bool get isNotificationActive => _isNotificationActive;
  static set isNotificationActive(bool value) => _isNotificationActive = value;

  static Future<void> ensureNotificationExists({
    required String title,
    required String status,
  }) async {
    try {
      // Only ensure notification exists if call is still active and not ended
      if (isNotificationActive) {
        await showCallNotification(
          title: title,
          status: status,
        );
      }
    } catch (e) {
      print('Error ensuring notification exists: $e');
    }
  }

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

// Task handler for foreground service
class MyTaskHandler extends TaskHandler {
  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // Keep WebSocket connection alive
    print('Foreground task event: ${timestamp}');

    // You can add WebSocket ping logic here
    // Example: await webSocketChannel.sink.add('ping');
  }

  @override
  void onButtonPressed(String id) {
    print('Button pressed: $id');
  }

  @override
  void onNotificationPressed() {
    print('Notification pressed');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // TODO: implement onRepeatEvent
    print('Notification repeat');
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) {
    // TODO: implement onDestroy
    throw UnimplementedError();
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) {
    // TODO: implement onStart
    throw UnimplementedError();
  }
}
