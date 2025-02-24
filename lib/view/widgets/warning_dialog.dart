import 'package:flutter/material.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

import '../../helpers/spacing.dart';
import '../../services/locator.dart';
import '../../services/navigation_service.dart';
import 'content_text.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog({super.key, required this.content, required this.onConfirm});

  final String content;
  final VoidCallback onConfirm;

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
            Icons.warning,
            size: 50,
            color: Theme.of(context).cardColor,
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
            label: "إلغاء",
            color: Theme.of(context).primaryColor,
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: SubtitleTextWidget(
            label: "موافقة",
            color: Theme.of(context).cardColor,
          ),
        ),
      ],
    );
  }
}
