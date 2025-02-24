import 'package:flutter/material.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';

import '../../../../constants/assets_manager.dart';
import '../../../../helpers/validators.dart';
import '../../../../services/locator.dart';
import '../../../../services/navigation_service.dart';
import '../../../widgets/subtitle_text.dart';

class ChangeNameDialog extends StatelessWidget {
  final String? userName;

  const ChangeNameDialog({Key? key, this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
    TextEditingController(text: userName ?? '');
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetsManager.profileJar,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              TextFormField(
                maxLength: 20,
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "ادخل الاسم الجديد",
                ),
                validator: Validators.validateUserName,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              locator<NavigationService>().goBackWithData(null);
            },
            child: ContentTextWidget(
              label: "إلفاء",
              color: Theme.of(context).primaryColor,
            ),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                locator<NavigationService>().goBackWithData(nameController.text);
              }
            },
            child: ContentTextWidget(
              label: "تغيير",
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
