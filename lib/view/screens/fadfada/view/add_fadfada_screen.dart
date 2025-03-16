import 'package:flutter/material.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/screens/fadfada/view_model/fadfada_view_model.dart';
import 'package:happiness_jar/view/widgets/custom_elevated_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../base_screen.dart';
import '../widgets/fadfada_categories.dart';

class AddFadfadaScreen extends StatelessWidget {
  const AddFadfadaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<FadfadaViewModel>(onModelReady: (viewModel) {
      viewModel.clearController();
    }, builder: (context, viewModel, child) {
      return Scaffold(
        appBar: const CustomAppBar(title: "إضافة فضفضة"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadfadaCategories(viewModel: viewModel),
                verticalSpace(16),
                TextField(
                  controller: viewModel.controller,
                  maxLength: viewModel.maxChars,
                  maxLines: 20,
                  minLines: 15,
                  decoration: const InputDecoration(
                    hintText:
                        "اكتب، لأن الكلمات في قلبك هي أصدق من أي شيء آخر.",
                  ),
                ),
                verticalSpace(8),
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
                                  message: "لا يمكنك الحفاظ على فضفضة فارغة",
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
                          viewModel.addFadfada();
                        },
                        label: "حفظ",
                        backgroundColor: Theme.of(context).iconTheme.color,
                        textColor: Theme.of(context).primaryColor))
              ],
            ),
          ),
        ),
      );
    });
  }
}
