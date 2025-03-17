import 'package:flutter/material.dart';
import 'package:happiness_jar/services/locator.dart';

import '../../../../helpers/date_time_helper.dart';
import '../../../../helpers/spacing.dart';
import '../../../../services/navigation_service.dart';
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
                                          fadfada.isPinned
                                              ? Icons.push_pin
                                              : Icons.push_pin_outlined,
                                          color: fadfada.isPinned
                                              ? Theme.of(context)
                                                  .unselectedWidgetColor
                                              : Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                        ),
                                        onPressed: () {
                                          viewModel
                                              .togglePinFadfada(fadfada.id!);
                                        },
                                      ),
                                      SizedBox(
                                        width: 75,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.timer,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              size: 14,
                                            ),
                                            horizontalSpace(2),
                                            Text(
                                              DateTimeHelper.formatTimeSpent(
                                                  fadfada.timeSpent),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  horizontalSpace(5),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          DateTimeHelper.formatTimestamp(
                                              fadfada.createdAt!),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  horizontalSpace(5),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color),
                                        onPressed: () {
                                          viewModel
                                              .navigateToEditFadfada(index);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Theme.of(context).cardColor),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                              title: const TitleTextWidget(label:("تأكيد الحذف")),
                                              content: const SubtitleTextWidget(label:
                                                  "هل أنت متأكد أنك تريد حذف هذه الفضفضة؟"),
                                              actions: [
                                                TextButton(
                                                  child: ContentTextWidget(label:"إلغاء",color: Theme.of(context).primaryColor,),
                                                  onPressed: () {
                                                    locator<NavigationService>().goBack();
                                                  }
                                                ),
                                                TextButton(
                                                  child:ContentTextWidget(label: "حذف",color: Theme.of(context).cardColor),
                                                  onPressed: () async {
                                                    await viewModel.deleteFadfada(fadfada.id!);
                                                    locator<NavigationService>().goBack();
                                                  },
                                                ),
                                              ],
                                            ),
                                          );

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
                    )
            ],
          ),
          floatingActionButton: const FloatingActionButtonAddFadfada(),
        );
      },
    );
  }
}
