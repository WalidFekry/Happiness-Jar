import 'package:flutter/material.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/screens/fadfada/model/fadfada_model.dart';
import 'package:happiness_jar/view/screens/fadfada/view_model/fadfada_view_model.dart';
import 'package:happiness_jar/view/widgets/custom_elevated_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../helpers/date_time_helper.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../base_screen.dart';
import '../widgets/fadfada_categories.dart';
import '../widgets/record_and_player.dart';

class EditFadfadaScreen extends StatelessWidget {
  final FadfadaModel fadfadaModel;

  const EditFadfadaScreen({super.key, required this.fadfadaModel});

  @override
  Widget build(BuildContext context) {
    return BaseView<FadfadaViewModel>(
      onModelReady: (viewModel) {
        viewModel.setFadfada(fadfadaModel);
        viewModel.startTimer();
      },onFinish: (viewModel){
      viewModel.disposeController();
    },
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: const CustomAppBar(title: "تعديل الفضفضة"),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadfadaCategories(viewModel: viewModel),
                  verticalSpace(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ContentTextWidget(
                        fontSize: 14,
                        label: "⏳ الوقت المستغرق: ${DateTimeHelper.formatTime(viewModel.stopwatch?.elapsed.inSeconds)}",
                      ),
                      ContentTextWidget(
                        fontSize: 14,
                        label: "🕐 الوقت السابق: ${DateTimeHelper.formatTime(fadfadaModel.timeSpent)}",
                      ),
                    ],
                  ),
                  verticalSpace(8),
                  TextField(
                    controller: viewModel.controller,
                    maxLength: viewModel.maxChars,
                    maxLines: 20,
                    minLines: 15,
                    decoration: const InputDecoration(
                      hintText: "ابدأ الكتابة، دع قلبك يروي قصته، وتذكر أنك لست وحدك.",
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).cardColor,
                      size: 30,
                    ),
                    onPressed: () {
                      viewModel.clearController();
                    },
                  ),
                  verticalSpace(4),
                  RecordAndPlayerWidget(viewModel: viewModel),
                  verticalSpace(16),
                  Center(
                    child: CustomElevatedButton(
                      horizontal: 60,
                      onPressed: () {
                        if (viewModel.controller.text.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.error(
                                backgroundColor: Theme.of(context).cardColor,
                                message: "لا يمكنك حفظ فضفضة فارغة",
                                icon: Icon(
                                  Icons.error,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 50,
                                ),
                              ),
                            );
                          });
                          return;
                        }
                        viewModel.updateFadfada(fadfadaModel.id,fadfadaModel.createdAt,fadfadaModel.timeSpent);
                      },
                      label: "حفظ التعديلات",
                      backgroundColor: Theme.of(context).iconTheme.color,
                      textColor: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
