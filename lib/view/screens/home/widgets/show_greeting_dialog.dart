import 'package:flutter/material.dart';

import '../../../../constants/assets_manager.dart';
import '../../../../helpers/spacing.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';

class ShowGreetingDialog extends StatelessWidget {
  const ShowGreetingDialog(
      {super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
              fit: BoxFit.cover,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
    );
  }
}
