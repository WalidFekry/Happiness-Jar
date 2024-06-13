import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/notifications/view_model/notifications_view_model.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../services/assets_manager.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';
import '../../base_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationsViewModel>(onModelReady: (viewModel) {
      viewModel.getContent();
    }, builder: (context, viewModel, child) {
      return Scaffold(
          body: Stack(
            children: [
              viewModel.list.isNotEmpty ?
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ListView.separated(
                  itemCount: viewModel.list.length,
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
                                  SubtitleTextWidget(label: viewModel.list[index].createdAt?.split(" ")[0],fontSize: 16,),
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
                                            icon: viewModel.list[index].isFavourite ? Icon(IconlyBold.heart,color: Theme.of(context).iconTheme.color) : Icon(IconlyLight.heart,color: Theme.of(context).iconTheme.color)),

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
                                    label: viewModel.list[index].text,
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
                child:  Visibility(
                  visible: viewModel.isDone,
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
                      SubtitleTextWidget(
               label: 'يلزم وجود اتصال بالانترنت لاول مره فقط حتى يتم تحميل بيانات هذا القسم 👀',
                      ),
                    ],
                  ),
                ),
            ],
          )

      );
    });

  }
}
