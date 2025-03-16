import 'package:flutter/material.dart';

import '../../../../helpers/spacing.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/subtitle_text.dart';
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
                  : Expanded(
                    child: ListView.separated(
                                    padding: const EdgeInsets.all(10),
                                    itemCount: viewModel.filteredFadfadaList.length,
                                    separatorBuilder: (context, index) => verticalSpace(8),
                                    itemBuilder: (context, index) {
                    final fadfada = viewModel.filteredFadfadaList[index];
                    return GestureDetector(
                      onTap: () {
                        viewModel.navigateToContent(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    fadfada.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                    color: fadfada.isPinned
                                        ? Theme.of(context).unselectedWidgetColor
                                        : Theme.of(context).iconTheme.color,
                                  ),
                                  onPressed: () {
                                    viewModel.togglePinFadfada(fadfada.id!);
                                  },
                                ),
                                CircleAvatar(
                                  backgroundColor: Theme.of(context).cardColor,
                                  child: const Icon(Icons.notes, color: Colors.white),
                                ),
                              ],
                            ),
                            horizontalSpace(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SubtitleTextWidget(
                                    fontSize: 18,
                                    label: fadfada.category!,
                                    overflew: TextOverflow.ellipsis,
                                  ),
                                  verticalSpace(4),
                                  ContentTextWidget(
                                    label: fadfada.text!,
                                    maxLines: 2,
                                    overflew: TextOverflow.ellipsis,
                                  ),
                                  verticalSpace(8),
                                  Text(
                                    viewModel.formatTimestamp(fadfada.createdAt!),
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            horizontalSpace(10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Theme.of(context).iconTheme.color),
                                  onPressed: () {
                                    viewModel.navigateToEditFadfada(index);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Theme.of(context).cardColor),
                                  onPressed: () {
                                    viewModel.deleteFadfada(fadfada.id!);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                                    },
                                  ),
                  ),
            ],
          ),
          floatingActionButton: const FloatingActionButtonAddFadfada(),
        );
      },
    );
  }
}
