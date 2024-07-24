import 'dart:async';

import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/shared_preferences_constants.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';

import '../../../../constants/assets_manager.dart';
import '../../../../helpers/spacing.dart';

class GreetingDialog {
  Future<void> showGreeting(BuildContext context) async {
    final now = DateTime.now();
    final prefs = locator<SharedPrefServices>();
    String? lastMorningShownDate;
    String? lastEveningShownDate;
    String? userName;

    userName = await prefs.getString(SharedPrefsConstants.userName);
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
      await showGreetingDialog(context, "صباح الخير \n والمقصود بالخير وجودك",
          "عساك بخير يا $userName 💙");
      await prefs.saveString(SharedPrefsConstants.lastMorningGreetingDate,
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
      await prefs.saveString(SharedPrefsConstants.lastEveningGreetingDate,
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
              verticalSpace(10),
              Image.asset(
                AssetsManager.welcomeJar,
                width: 100,
                height: 100,
                fit:  BoxFit.cover,
              ),
              verticalSpace(20),
              ContentTextWidget(
                label: body,
                textAlign: TextAlign.center,
              ),
              verticalSpace(30),
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
