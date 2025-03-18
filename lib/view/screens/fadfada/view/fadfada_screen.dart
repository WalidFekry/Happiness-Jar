import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/fadfada/widgets/fadfada_list_view.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/title_text.dart';
import '../../base_screen.dart';
import '../view_model/fadfada_view_model.dart';
import '../widgets/fadfada_info.dart';
import '../widgets/floating_action_button_add_fadfada.dart';

class FadfadaScreen extends StatelessWidget {
  const FadfadaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<FadfadaViewModel>(
      onModelReady: (viewModel) {
        viewModel.getFadfadaList();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: const CustomAppBar(title: "الركن الدافئ"),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (viewModel.categories.length != 1)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: viewModel.categoryFilter,
                        hint: const TitleTextWidget(label: "اختر القسم"),
                        items: viewModel.categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          viewModel.setSelectedCategory(value!);
                        },
                      ),
                      DropdownButton<String>(
                        value: viewModel.sortOrder,
                        hint: const TitleTextWidget(label: "ترتيب حسب"),
                        items: const [
                          DropdownMenuItem(
                            value: "newest",
                            child: Text("الأحدث أولًا"),
                          ),
                          DropdownMenuItem(
                            value: "oldest",
                            child: Text("الأقدم أولًا"),
                          ),
                        ],
                        onChanged: (value) {
                          viewModel.setSortOrder(value!);
                        },
                      ),
                    ],
                  ),
                ),
              viewModel.filteredFadfadaList.isEmpty
                  ? const FadfadaInfoWidget()
                  : const FadfadaListViewWidget()
            ],
          ),
          floatingActionButton: const FloatingActionButtonAddFadfada(),
        );
      },
    );
  }
}
