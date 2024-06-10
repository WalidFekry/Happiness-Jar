import 'package:flutter/material.dart';
import 'package:happiness_jar/consts/app_colors.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/view/screens/base_screen.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_categories_model.dart';
import 'package:happiness_jar/view/screens/categories/view_model/categories_view_model.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:iconly/iconly.dart';

import '../../../../services/assets_manager.dart';
import '../../../widgets/app_name_text.dart';
import '../../../widgets/title_text.dart';

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
        body: Stack(
          children: [
            viewModel.content.isNotEmpty ?
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
                                            // if (notificationController
                                            //     .isFavoriteNotification(
                                            //     notification)) {
                                            //   notificationController
                                            //       .removeFavoriteNotification(
                                            //       notification);
                                            // } else {
                                            //   notificationController
                                            //       .addFavoriteNotification(
                                            //       notification);
                                            // }
                                          },
                                          icon: Icon(IconlyLight.heart,color: Theme.of(context).iconTheme.color)),
                                      IconButton(
                                        onPressed: () {
                                          // if (notificationController
                                          //     .isFavoriteNotification(
                                          //     notification)) {
                                          //   notificationController
                                          //       .removeFavoriteNotification(
                                          //       notification);
                                          // } else {
                                          //   notificationController
                                          //       .addFavoriteNotification(
                                          //       notification);
                                          // }
                                        },
                                        icon: Icon(Icons.copy,color:Theme.of(context).iconTheme.color),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // if (notificationController
                                          //     .isFavoriteNotification(
                                          //     notification)) {
                                          //   notificationController
                                          //       .removeFavoriteNotification(
                                          //       notification);
                                          // } else {
                                          //   notificationController
                                          //       .addFavoriteNotification(
                                          //       notification);
                                          // }
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
            ) : Visibility(
              visible: viewModel.isDone,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).iconTheme.color,
                  strokeAlign: 5,
                  strokeWidth: 5,
                ),
              ),
            ),
            if(!viewModel.isDone)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleTextWidget(label: 'يلزم وجود اتصال بالانترنت لاول مره فقط حتى يتم تحميل بيانات هذا القسم 👀',maxLines: 5,fontSize: 18,)
                  ],
                ),
              ),
          ],
        )

      );
    });
  }
}
