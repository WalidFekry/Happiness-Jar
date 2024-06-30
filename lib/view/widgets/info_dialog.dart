import 'package:flutter/material.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

class InfoDialog {
  static void show(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info,
                size: 50,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(height: 20),
              ContentTextWidget(
                label: content,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                locator<NavigationService>().goBack();
              },
              child: SubtitleTextWidget(
                label: "حسناً",
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
