import 'package:flutter/material.dart';
import 'package:happiness_jar/consts/app_consts.dart';
import 'package:happiness_jar/locator.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../services/navigation_service.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';

class ShareAPPDialog {
  static void show(BuildContext context) {
    showDialog(
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
              const SubtitleTextWidget(
                label: "مشاركة التطبيق 📲",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const ContentTextWidget(
                label: AppConsts.SHARE_APP_MESSAGE,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      shareApp();
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
                      label: "مشاركة",
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () async {
                      locator<NavigationService>().goBack();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                    ),
                    child: SubtitleTextWidget(
                      label: "إغلاق",
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> shareApp() async {
    await Share.share(AppConsts.SHARE_APP);
  }
}
