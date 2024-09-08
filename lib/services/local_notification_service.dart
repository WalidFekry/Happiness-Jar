import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:happiness_jar/constants/local_notification_constants.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/services/navigation_service.dart';

import '../routs/routs_names.dart';

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
