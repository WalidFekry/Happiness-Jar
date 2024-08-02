import 'package:flutter/material.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

import '../../helpers/spacing.dart';
import '../../locator.dart';
import '../../services/navigation_service.dart';
import 'content_text.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key, required this.content});

  final String content;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          verticalSpace(20),
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
  }
}
