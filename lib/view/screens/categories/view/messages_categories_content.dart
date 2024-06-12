import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../locator.dart';
import '../../../../services/assets_manager.dart';
import '../../../../services/navigation_service.dart';
import '../../../widgets/app_name_text.dart';
import '../../../widgets/content_text.dart';
import '../../base_screen.dart';
import '../model/messages_categories_model.dart';
import '../view_model/categories_view_model.dart';

class MessagesCategoriesContent extends StatelessWidget {
  MessagesCategories? messagesCategories;
  int index;
  MessagesCategoriesContent(this.messagesCategories, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<CategoriesViewModel>(onModelReady: (viewModel) {
      viewModel.getContent(messagesCategories?.categorie);
    }, builder: (context, viewModel, child) {
      return Scaffold(
          appBar: AppBar(
            title: AppBarTextWidget(
              title: messagesCategories?.title,
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AssetsManager.iconAppBar),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    locator<NavigationService>().goBack();
                  },
                  icon: Icon(
                    IconlyLight.arrow_left_2,
                    size: 35,
                    color: Theme.of(context).iconTheme.color,
                  ))
            ],
          ),
          body: viewModel.content.isNotEmpty ?
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListView.separated(
              itemCount: viewModel.content.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(right: 5, left: 5, top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color.fromARGB(178, 158, 158, 158),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                AssetsManager.iconAppBar,
                                height: 35,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          viewModel.saveFavoriteMessage(index);
                                          showTopSnackBar(
                                            Overlay.of(context),
                                            CustomSnackBar.success(
                                              backgroundColor: Theme.of(context).iconTheme.color!,
                                              message:
                                              "تمت الإضافة للمفضلة",
                                              icon: Icon(IconlyBold.heart,color: Theme.of(context).cardColor,
                                                size: 50,),
                                            ),
                                          );
                                        },
                                        icon: viewModel.content[index].isFavourite ? Icon(IconlyBold.heart,color: Theme.of(context).iconTheme.color) : Icon(IconlyLight.heart,color: Theme.of(context).iconTheme.color)),
                                    IconButton(
                                      onPressed: () {
                                        viewModel.copyMessage(index);
                                        showTopSnackBar(
                                          Overlay.of(context),
                                          CustomSnackBar.success(
                                            backgroundColor: Theme.of(context).iconTheme.color!,
                                            message:
                                            "تم النسخ",
                                            icon: Icon(Icons.copy,color: Theme.of(context).cardColor,
                                              size: 50,),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.copy,color:Theme.of(context).iconTheme.color),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        viewModel.shareMessage(index);
                                      },
                                      icon: Icon(Icons.share,color:Theme.of(context).iconTheme.color),
                                    ),
                                  ]),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ContentTextWidget(
                                label: viewModel.content[index].title,
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 20,
              ),
            ),
          ) : Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).iconTheme.color,
              strokeAlign: 5,
              strokeWidth: 5,
            ),
          )

      );
    });
  }
}
