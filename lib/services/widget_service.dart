import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String _groupId = 'group.com.jar.happiness';
  static const String _androidWidgetName = 'HappinessJarWidgetProvider';
  static const String _iosWidgetName = 'HappinessJarWidget';

  /// Fetches 24 random messages from SQLite and saves them to shared storage.
  /// This allows the native widgets to rotate messages hourly without booting Flutter.
  Future<void> prepareWidgetMessages() async {
    try {
      final appDatabase = locator<AppDatabase>();
      // Fetch 24 random messages
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

      // Save the list of messages for native rotation
      await HomeWidget.saveWidgetData<String>(
          'message_list', jsonEncode(messageTexts));

      // Save the current message as a fallback/initial text
      await HomeWidget.saveWidgetData<String>(
          'message_text', messageTexts.first);

      // Reset index to 0 for a fresh cycle
      await HomeWidget.saveWidgetData<int>('message_index', 0);

      // Trigger native update to apply changes immediately (this also ensures Worker is scheduled on Android)
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iosWidgetName,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error preparing widget messages: $e');
      }
    }
  }
}
