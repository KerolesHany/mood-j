import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<bool> requestPermission() async {
    final request = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    if (request == null) return true;
    return request;
  }

  //! => Initialization
  static Future<void> init() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/launcher_icon"),
      iOS: DarwinInitializationSettings(),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo')); // غيّر حسب منطقتك
  }

  static Future<void> onTap(NotificationResponse response) async {
    //!  print("Notification tapped: ${response.payload}");
  }

  //! ===>>>
  static NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      "basic_channel",
      "Basic Notifications",
      channelDescription: "This channel is for basic notifications",
      importance: Importance.max,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  //! Scheduled Notification
  static Future<void> scheduleDailyNotification({
    required TimeOfDay time,
    required String title,
    required String description,
  }) async {
    await init();
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      title,
      description,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  //! Cancel Notification by ID
  static Future<void> cancel() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
