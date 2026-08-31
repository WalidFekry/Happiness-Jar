import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String _groupId = 'group.com.jar.happiness';
  static const String _androidWidgetName = 'HappinessJarWidgetProvider';
  static const String _iosWidgetName = 'HappinessJarWidget';

  /// Fetches 24 random messages and saves them to shared storage for the native widgets to use.
  /// This eliminates the need for the widgets to trigger Flutter or SQLite every hour.
  Future<void> refreshWidgetMessages() async {
    try {
      final appDatabase = locator<AppDatabase>();
      final messages =
          await appDatabase.getMessagesNotificationContent(limit: 24);

      if (messages.isEmpty) return;

      final messageTexts = messages
          .map((m) => m.text)
          .where((text) => text != null)
          .cast<String>()
          .toList();

      if (messageTexts.isEmpty) return;

      await HomeWidget.setAppGroupId(_groupId);

      // Save the list of messages for both platforms to use locally
      await HomeWidget.saveWidgetData<String>(
          'message_list', jsonEncode(messageTexts));

      // Save the first message as a fallback/initial text
      await HomeWidget.saveWidgetData<String>(
          'message_text', messageTexts.first);

      // Reset index to 0 for a fresh cycle
      await HomeWidget.saveWidgetData<int>('message_index', 0);

      // Trigger native update to apply changes immediately
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iosWidgetName,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing widget messages: $e');
      }
    }
  }
}
