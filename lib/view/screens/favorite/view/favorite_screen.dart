

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happiness_jar/consts/app_colors.dart';
import 'package:happiness_jar/view/screens/favorite/view_model/favorite_view_model.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../locator.dart';
import '../../../../consts/assets_manager.dart';
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
                            color: Colors.grey,
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
                                      const TitleTextWidget(label: "من مفضلة البرطمان",fontSize: 18,),
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
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AssetsManager.favoriteJar,
                                        height: 100,
                                        width: 100,
                                        fit:  BoxFit.cover,
                                      ),
                                      ContentTextWidget(
                                        label: viewModel.list[index].title,textAlign:TextAlign.center,
                                      ),
                                    ],
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SubtitleTextWidget(label: viewModel.list[index].createdAt,fontSize: 16,),
                                    Image.asset(
                                      AssetsManager.favoriteJar,
                                      fit:  BoxFit.cover,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ContentTextWidget(
                                    label: viewModel.list[index].title,
                                  )),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(  color: Colors.grey, thickness: 1),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
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
                                        viewModel.shareWhatsapp(index);
                                      },
                                      icon: SvgPicture.asset(
                                        AssetsManager.whatsapp,
                                        width: 24,
                                        height: 24,
                                        colorFilter: ColorFilter.mode(Theme.of(context).iconTheme.color!, BlendMode.srcIn),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        viewModel.shareFacebook(index);
                                      },
                                      icon: Icon(Icons.facebook,color:Theme.of(context).iconTheme.color),
                                    ),
                                  ],
                                ),
                              ),
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
                      Image.asset(AssetsManager.favoriteJar,height: 200,width: 200,fit:   BoxFit.cover,),
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
