import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/locator.dart';
import '../../../../constants/assets_manager.dart';
import '../../../../services/navigation_service.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';

class OpenSettingAppDialog {
   static void show(BuildContext context) {
    showDialog(context: context, builder: (context) => Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SubtitleTextWidget(
              label: "الاشعارات غير مفعلة !",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Image.asset(
              AssetsManager.notificationAlertJar,
              width: 100,
              height: 100,
              fit:  BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const ContentTextWidget(
              label: "يرجى تفعيل اشعارات البرطمان في الاعدادات",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    locator<NavigationService>().goBack();
                    AppSettings.openAppSettings(type: AppSettingsType.notification);
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
                    label: "الاعدادت",
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {
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
                    label: "إلغاء",
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),);
  }
}