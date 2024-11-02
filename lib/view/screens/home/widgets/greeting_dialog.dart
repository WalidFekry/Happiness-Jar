import 'dart:async';

import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/shared_preferences_constants.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/screens/home/widgets/show_greeting_dialog.dart';

import '../../../../services/current_session_service.dart';

class GreetingDialog {
  Future<void> showGreeting(BuildContext context) async {
    final now = DateTime.now();
    final prefs = locator<SharedPrefServices>();
    String? lastMorningShownDate;
    String? lastEveningShownDate;
    String? userName;

    userName = CurrentSessionService.cachedUserName;
    lastMorningShownDate =
        await prefs.getString(SharedPrefsConstants.lastMorningGreetingDate);
    lastEveningShownDate =
        await prefs.getString(SharedPrefsConstants.lastEveningGreetingDate);

    if (now.hour < 12) {
      if (lastMorningShownDate != "") {
        final lastShown = DateTime.parse(lastMorningShownDate);
        if (isSameDay(now, lastShown)) {
          return;
        }
      }
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
            context: context,
            builder: (context) {
              return ShowGreetingDialog(
                  title: "صباح الخير \n والمقصود بالخير وجودك",
                  body: "عساك بخير يا $userName 💙");
            });
      });
      await prefs.saveString(
          SharedPrefsConstants.lastMorningGreetingDate, now.toIso8601String());
    } else {
      if (lastEveningShownDate != "") {
        final lastShown = DateTime.parse(lastEveningShownDate);
        if (isSameDay(now, lastShown)) {
          return;
        }
      }
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
            context: context,
            builder: (context) {
              return ShowGreetingDialog(
                  title: "مساء الخير \n والمقصود بالخير وجودك",
                  body: "عساك بخير يا $userName 💙");
            });
      });
      await prefs.saveString(
          SharedPrefsConstants.lastEveningGreetingDate, now.toIso8601String());
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
