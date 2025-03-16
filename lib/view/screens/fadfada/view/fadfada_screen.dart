import 'package:flutter/material.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../base_screen.dart';
import '../view_model/fadfada_view_model.dart';
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
            body: viewModel.fadfadaList.isEmpty
                ? const Center(
              child: TitleTextWidget(
                label: "لا توجد أي فضفضة لك حتى الآن!",
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: viewModel.fadfadaList.length,
              separatorBuilder: (context, index) => verticalSpace(8),
              itemBuilder: (context, index) {
                final fadfada = viewModel.fadfadaList[index];
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
                        CircleAvatar(
                          backgroundColor: Theme.of(context).cardColor,
                          child: const Icon(Icons.notes, color: Colors.white),
                        ),
                        horizontalSpace(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubtitleTextWidget(
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
            floatingActionButton: const FloatingActionButtonAddFadfada(),
          );
        });
  }
}
