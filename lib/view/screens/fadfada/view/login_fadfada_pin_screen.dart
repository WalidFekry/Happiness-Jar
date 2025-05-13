import 'package:flutter/material.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../base_screen.dart';
import '../view_model/fadfada_view_model.dart';

class LoginFadfadaPinScreen extends StatelessWidget {
  const LoginFadfadaPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<FadfadaViewModel>(
      onModelReady: (viewModel) {},
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: const CustomAppBar(title: "رمز الحماية"),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TitleTextWidget(label: ('من فضلك أدخل رمز الحماية')),
                verticalSpace(10),
                TextField(
                  controller: viewModel.pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '****',
                  ),
                ),
                verticalSpace(10),
                if (viewModel.errorMessage.isNotEmpty) ...[
                  SubtitleTextWidget(
                    label: (viewModel.errorMessage),
                    color: Theme.of(context).cardColor,
                  ),
                  verticalSpace(10),
                ],
                CustomElevatedButton(
                    onPressed: viewModel.checkPin,
                    label: 'دخول',
                    backgroundColor: Theme.of(context).iconTheme.color,
                    textColor: Theme.of(context).primaryColor),
                verticalSpace(10),
                TextButton(
                  onPressed: () {
                    viewModel.navigateToResetFadfadaPin();
                  },
                  child: Align(
                       alignment:Alignment.centerLeft,
                      child: ContentTextWidget(
                    label: ('نسيت رمز الحماية؟'),
                    color: Theme.of(context).primaryColor,
                  )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
