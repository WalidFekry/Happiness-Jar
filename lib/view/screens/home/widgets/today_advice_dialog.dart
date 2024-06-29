import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import '../../../../consts/shared_preferences_constants.dart';
import '../../../../services/navigation_service.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';

class TodayAdviceDialog {
   static void show(BuildContext context, String? body) {
    final prefs = locator<SharedPrefServices>();
    showDialog(context: context, builder: (context) => Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SubtitleTextWidget(
              label: "نصيحة اليوم من البرطمان 🎁",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ContentTextWidget(
              label: body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                await prefs.saveString(SharedPrefsConstants.GET_TODAY_ADVICE_TIME,
                    DateTime.now().toIso8601String());
                locator<NavigationService>().goBack();
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).iconTheme.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 20),
              ),
              child: SubtitleTextWidget(
                label: "شكراً 🎉",
                color: Theme.of(context).primaryColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    ),);
  }
}