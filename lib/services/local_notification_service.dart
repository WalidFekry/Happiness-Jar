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
      settings,
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
      LocalNotificationConstants.notificationId_2,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: LocalNotificationConstants.notificationPayload_2,
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
      LocalNotificationConstants.notificationId,
      LocalNotificationConstants.notificationTitle,
      LocalNotificationConstants.notificationBody,
      RepeatInterval.daily,
      details,
      payload: LocalNotificationConstants.notificationPayload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

final StreamController<NotificationResponse?> streamController = StreamController<NotificationResponse?>.broadcast();

void onTap(NotificationResponse notificationResponse) {
  streamController.add(notificationResponse);
}
