import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_constants.dart';
import 'package:happiness_jar/constants/lists_constants.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../base_screen.dart';
import '../view_model/fadfada_view_model.dart';

class SetFadfadaPinScreen extends StatelessWidget {
  const SetFadfadaPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<FadfadaViewModel>(
      onModelReady: (viewModel) {},
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: const CustomAppBar(title: "إعداد الرقم السري"),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  TextField(
                    controller: viewModel.pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'الرقم السري'),
                  ),
                  verticalSpace(10),
                  TextField(
                    controller: viewModel.confirmPinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'تأكيد الرقم السري'),
                  ),
                  verticalSpace(20),
                  const TitleTextWidget(label: ('سؤال الأمان:')),
                  verticalSpace(10),
                  DropdownButtonFormField<String>(
                    value: viewModel.selectedQuestion.isNotEmpty
                        ? viewModel.selectedQuestion
                        : null,
                    items: questions.map((question) {
                      return DropdownMenuItem<String>(
                        value: question,
                        child: Text(question),
                      );
                    }).toList(),
                    onChanged: (value) {
                      viewModel.selectedQuestion = value!;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      hintText: 'اختر سؤال الأمان',
                    ),
                  ),
                  verticalSpace(10),
                  TextField(
                    controller: viewModel.answerController,
                    decoration: const InputDecoration(labelText: 'إجابتك'),
                  ),
                  verticalSpace(20),
                  if (viewModel.errorMessage.isNotEmpty) ...[
                    ContentTextWidget(
                      label: viewModel.errorMessage,
                      color: Theme.of(context).cardColor,
                    ),
                    verticalSpace(20),
                  ],
                  CustomElevatedButton(
                      onPressed: viewModel.savePinAndAnswer,
                      label: 'حفظ',
                      backgroundColor: Theme.of(context).iconTheme.color,
                      textColor: Theme.of(context).primaryColor),
                  verticalSpace(20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const SubtitleTextWidget(
                      textAlign: TextAlign.center,
                      label: AppConstants.setFadfadaPinMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
