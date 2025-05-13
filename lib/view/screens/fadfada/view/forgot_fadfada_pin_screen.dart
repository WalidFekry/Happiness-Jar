import 'package:flutter/material.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';

import '../../../../constants/lists_constants.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../base_screen.dart';
import '../view_model/fadfada_view_model.dart';

class ForgotFadfadaPinScreen extends StatelessWidget {
  const ForgotFadfadaPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<FadfadaViewModel>(
      onModelReady: (viewModel) {},
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: const CustomAppBar(title: "استعادة رمز الحماية"),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'اختر السؤال'),
                  items: questions.map((q) {
                    return DropdownMenuItem(value: q, child: Text(q));
                  }).toList(),
                  onChanged: (value) {
                      viewModel.selectedQuestion = value!;
                  },
                ),
                verticalSpace(20),
                TextField(
                  controller: viewModel.answerController,
                  decoration: const InputDecoration(labelText: 'الإجابة'),
                ),
                verticalSpace(20),
                if (viewModel.errorMessage.isNotEmpty) ...[
                  SubtitleTextWidget(
                    label: (viewModel.errorMessage),
                    color: Theme.of(context).cardColor,
                  ),
                  verticalSpace(20),
                ],
                CustomElevatedButton(
                    onPressed: viewModel.verifyAnswer,
                    label: 'تحقق',
                    backgroundColor: Theme.of(context).iconTheme.color,
                    textColor: Theme.of(context).primaryColor),
              ],
            ),
          ),
        );
      },
    );
  }
}
