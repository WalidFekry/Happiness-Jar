import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:happiness_jar/constants/local_notification_constants.dart';


class LocalNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Init the plugin.
  Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  // Show notification from FCM.
  Future<void> showNotificationFromFCM(RemoteMessage message) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      LocalNotificationConstants.channelId_2,
      LocalNotificationConstants.channelName_2,
      channelDescription: LocalNotificationConstants.channelDescription,
      importance: Importance.max,
      priority: Priority.max,
      autoCancel: false,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    const DarwinNotificationDetails ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );

    NotificationDetails details = const NotificationDetails(
      android: android,
      iOS: ios,
    );

    await flutterLocalNotificationsPlugin.show(
      id: LocalNotificationConstants.notificationId_2,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: details,
      payload: message.data["click_action"],
    );
  }

  // Show repeated notification.
  Future<void> showRepeatedNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      LocalNotificationConstants.channelId,
      LocalNotificationConstants.channelName,
      channelDescription: LocalNotificationConstants.channelDescription,
      importance: Importance.max,
      priority: Priority.max,
      autoCancel: false,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    const DarwinNotificationDetails ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );

    NotificationDetails details = const NotificationDetails(
      android: android,
      iOS: ios,
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
      id: LocalNotificationConstants.notificationId,
      title: LocalNotificationConstants.notificationTitle,
      body: LocalNotificationConstants.notificationBody,
      repeatInterval: RepeatInterval.daily,
      notificationDetails: details,
      payload: LocalNotificationConstants.notificationPayload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Show birthday notification.
  Future<void> showBirthdayNotification(String title, String body) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      LocalNotificationConstants.channelId_3,
      LocalNotificationConstants.channelName_3,
      channelDescription: LocalNotificationConstants.channelDescription_3,
      importance: Importance.max,
      priority: Priority.max,
      autoCancel: false,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    const DarwinNotificationDetails ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );

    NotificationDetails details = const NotificationDetails(
      android: android,
      iOS: ios,
    );

    await flutterLocalNotificationsPlugin.show(
      id: LocalNotificationConstants.notificationId_3,
      title: title,
      body: body,
      notificationDetails: details,
      payload: LocalNotificationConstants.birthdayNotificationPayload,
    );
  }

  // Show welcome notification
  Future<void> showWelcomeNotification(String userName) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      LocalNotificationConstants.channelId_4,
      LocalNotificationConstants.channelName_4,
      channelDescription: LocalNotificationConstants.channelDescription_4,
      importance: Importance.max,
      priority: Priority.max,
      autoCancel: false,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    const DarwinNotificationDetails ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );

    NotificationDetails details = const NotificationDetails(
      android: android,
      iOS: ios,
    );

    await flutterLocalNotificationsPlugin.show(
      id: LocalNotificationConstants.notificationId_4,
      title: "مرحبًا بك يا $userName 👋",
      body: "سعادتك تبدأ بخطوة… وقد بدأت الآن 💙",
      notificationDetails: details,
      payload: LocalNotificationConstants.welcomeNotificationPayload,
    );
  }


  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }
}

final StreamController<NotificationResponse?> streamController = StreamController<NotificationResponse?>.broadcast();

void onTap(NotificationResponse notificationResponse) {
  streamController.add(notificationResponse);
}
