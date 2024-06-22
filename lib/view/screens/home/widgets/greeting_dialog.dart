import 'dart:async';

import 'package:flutter/material.dart';
import 'package:happiness_jar/consts/shared_preferences_constants.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';

class GreetingDialog {
  Future<void> showGreeting(BuildContext context) async {
    final now = DateTime.now();
    var prefs = locator<SharedPrefServices>();
    String? lastMorningShownDate;
    String? lastEveningShownDate;
    String? userName;

    userName = await prefs.getString(SharedPrefsConstants.USER_NAME);
    lastMorningShownDate =
        await prefs.getString(SharedPrefsConstants.LAST_MORNING_GREETING_DATE);
    lastEveningShownDate =
        await prefs.getString(SharedPrefsConstants.LAST_EVENING_GREETING_DATE);

    if (now.hour < 12) {
      if (lastMorningShownDate != "") {
        final lastShown = DateTime.parse(lastMorningShownDate);
        if (isSameDay(now, lastShown)) {
          return;
        }
      }
      await showGreetingDialog(context, "صباح الخير \n والمقصود بالخير وجودك",
          "عساك بخير يا $userName 💙");
      await prefs.saveString(SharedPrefsConstants.LAST_MORNING_GREETING_DATE,
          now.toIso8601String());
    } else {
      if (lastEveningShownDate != "") {
        final lastShown = DateTime.parse(lastEveningShownDate);
        if (isSameDay(now, lastShown)) {
          return;
        }
      }
      await showGreetingDialog(context, "مساء الخير \n والمقصود بالخير وجودك",
          "عساك بخير يا $userName 💙");
      await prefs.saveString(SharedPrefsConstants.LAST_EVENING_GREETING_DATE,
          now.toIso8601String());
    }
  }

  Future<void> showGreetingDialog(
      BuildContext context, String title, String body) async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SubtitleTextWidget(
                label: title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ContentTextWidget(
                label: body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).iconTheme.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                  ),
                  child: TitleTextWidget(
                    label: "شكراً",
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
