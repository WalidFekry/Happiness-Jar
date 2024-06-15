

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/consts/app_colors.dart';
import 'package:happiness_jar/view/screens/favorite/view_model/favorite_view_model.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../locator.dart';
import '../../../../services/assets_manager.dart';
import '../../../../services/navigation_service.dart';
import '../../../widgets/app_name_text.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/title_text.dart';
import '../../base_screen.dart';

class FavoriteScreen extends StatelessWidget {

  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<FavoriteViewModel>(onModelReady: (viewModel) {
    viewModel.getFavoriteMessages();
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
                            width: 2
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor:Theme.of(context).scaffoldBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(18)),
                                  title: Row(
                                    children: [
                                      const TitleTextWidget(label: "رسالة من البرطمان"),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () =>
                                            viewModel.shareMessage(
                                                index),
                                        icon: Icon(
                                          Icons.share,
                                          color: Theme.of(context).iconTheme.color,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // locator<NavigationService>().goBack();
                                          viewModel.copyMessage(
                                              index);
                                        },
                                        icon: Icon(
                                          CupertinoIcons.doc_on_clipboard_fill,
                                          color: Theme.of(context).iconTheme.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: ContentTextWidget(
                                    label: viewModel.list[index].title,textAlign:TextAlign.center,
                                  ),
                                  actions: [
                                    Center(
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              backgroundColor: Theme.of(context).iconTheme.color,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      15))),
                                          onPressed: () {
                                            viewModel.goBack();
                                          },
                                          child: SubtitleTextWidget(
                                            label: "اغلاق",
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 18,
                                          )
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SubtitleTextWidget(label: viewModel.list[index].createdAt,fontSize: 16,),
                                  Image.asset(
                                    AssetsManager.iconAppBar,
                                    height: 35,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
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
                                        IconButton(
                                          onPressed: () {
                                            viewModel.deleteFavoriteMessage(index);
                                            showTopSnackBar(
                                              Overlay.of(context),
                                              CustomSnackBar.error(
                                                backgroundColor: Theme.of(context).cardColor,
                                                message:
                                                "تم الحذف",
                                                icon: Icon(Icons.delete,color: Theme.of(context).iconTheme.color,
                                                  size: 50,),
                                              ),
                                            );
                                          },
                                          icon: Icon(IconlyLight.delete,color:Theme.of(context).cardColor),
                                        ),
                                      ]),
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ContentTextWidget(
                                    label: viewModel.list[index].title,
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
                child:  Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AssetsManager.iconAppBar,height: 150),
                      const SizedBox(height: 10),
                      const TitleTextWidget(label: 'لا توجد رسائل مفضلة في البرطمان ',maxLines: 5,fontSize: 18,)
                    ],
                  ),
                ),
              ),
            ],
          )

      );
    });
  }
}
