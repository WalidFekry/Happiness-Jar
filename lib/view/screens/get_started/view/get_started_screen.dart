import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_consts.dart';
import 'package:happiness_jar/constants/assets_manager.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

import '../../../../helpers/spacing.dart';
import '../../../../routs/routs_names.dart';
import '../../../widgets/title_text.dart';
import '../../base_screen.dart';
import '../view_model/get_started_view_model.dart';
import '../widget/get_started_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<GetStartedViewModel>(
      onModelReady: (viewModel) {
      },
      builder: (context, getStartedViewModel, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 25.0),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AssetsManager.welcomeJar,
                      height: 150,
                      width: 150,
                      fit:  BoxFit.cover,
                    ),
                    verticalSpace(15),
                    const TitleTextWidget(
                      label: "برطمان السعادة 🦋",
                    ),
                    verticalSpace(15),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: const ContentTextWidget(label: AppConsts.getStartedMessage,textAlign: TextAlign.center,
                         ),
                    ),
                   verticalSpace(15),
                    const GetStartedButton(RouteName.GET_NOTIFICATION_SCREEN,"التالي"),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}