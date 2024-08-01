import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_consts.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/view/screens/get_started/widget/get_started_button.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';

import '../../../../constants/assets_manager.dart';
import '../../../../helpers/spacing.dart';
import '../../../widgets/title_text.dart';
import '../../base_screen.dart';
import '../view_model/get_started_view_model.dart';

class GetNotificationScreen extends StatelessWidget {
  const GetNotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<GetStartedViewModel>(
      onModelReady: (viewModel) {
        viewModel.setDoneGetStarted();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetsManager.notificationAlertJar,
                    height: 150,
                    width: 150,
                    fit:  BoxFit.cover,
                  ),
                  verticalSpace(15),
                  const TitleTextWidget(
                    label: "تفعيل إشعارات البرطمان 🔔",
                  ),
                  verticalSpace(15),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: const ContentTextWidget(label: AppConsts.notificationMessage,textAlign: TextAlign.center,
                    ),
                  ),
                  verticalSpace(15),
                  const GetStartedButton(RouteName.REGISTER,"تفعيل"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}