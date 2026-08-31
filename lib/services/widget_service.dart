import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:happiness_jar/view/screens/notifications/model/notification_model.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/services/locator.dart';

class WidgetService {
  static const String _groupId = 'group.com.jar.happiness';
  static const String _androidWidgetName = 'HappinessJarWidgetProvider';
  static const String _iosWidgetName = 'HappinessJarWidget';

  Future<void> updateWidget(MessagesNotifications? message) async {
    if (message == null) return;

    try {
      await HomeWidget.setAppGroupId(_groupId);
      
      // For Android
      await HomeWidget.saveWidgetData<String>('message_text', message.text);
      
      // For iOS (Prepare 24 messages for the next 24 hours)
      if(Platform.isIOS){
        final appDatabase = locator<AppDatabase>();
        final allMessages = await appDatabase.getMessagesNotificationContent(limit: 24);
        if (allMessages.isNotEmpty) {
          final batch = allMessages.take(24).map((m) => m.text).toList();
          await HomeWidget.saveWidgetData<String>('message_list', jsonEncode(batch));
        }
      }

      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iosWidgetName,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating widget: $e');
      }
    }
  }

  Future<void> refreshWidget() async {
    final appDatabase = locator<AppDatabase>();
    final messages = await appDatabase.getMessagesNotificationContent(limit: 1);
    if (messages.isNotEmpty) {
      await updateWidget(messages.first);
    }
  }

  static Future<void> handleWidgetAction(Uri? uri) async {
    if (uri == null) return;

    if (uri.host == 'update_message') {
      setupLocator();
      final widgetService = WidgetService();
      await widgetService.refreshWidget();
    }
  }
}
