import 'package:flutter/material.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';

import '../../../../constants/assets_manager.dart';
import '../../../../services/locator.dart';
import '../../../../services/navigation_service.dart';
import '../../../widgets/subtitle_text.dart';

class ChangeNameDialog {
  static Future<String?> show(BuildContext context, String? userName) {
    TextEditingController nameController = TextEditingController(text: userName ?? '');

    return showDialog<String?>(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const SubtitleTextWidget(
              label: "تغيير الاسم",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetsManager.profileJar,
                  width: 100,
                  height: 100,
                  fit:  BoxFit.cover,
                ),
                TextField(
                  maxLength: 20,
                  controller: nameController,
                  decoration: const InputDecoration(hintText: "ادخل الاسم الجديد"),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  locator<NavigationService>().goBackWithData(null);
                },
                child: ContentTextWidget(label: "إلفاء",color: Theme.of(context).primaryColor,),
              ),
              TextButton(
                onPressed: () {
                  if (nameController.text.isEmpty) return;
                  locator<NavigationService>().goBackWithData(nameController.text);
                },
                child: ContentTextWidget(label: "تغيير",color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        );
      },
    );
  }
}