import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_jar/view/screens/posts/view_model/posts_view_model.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../constants/assets_manager.dart';
import '../../../../helpers/spacing.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';

class PostsListView extends StatelessWidget {
  PostsListView(this.viewModel, {super.key});

  PostsViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: viewModel.list.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: InkWell(
              onTap: () {
                viewModel.showBinyAd();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      title: Row(
                        children: [
                          const TitleTextWidget(
                              label: "من منشورات البرطمان", fontSize: 18),
                          const Spacer(),
                          IconButton(
                            onPressed: () => viewModel.shareMessage(index),
                            icon: Icon(
                              Icons.share,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // locator<NavigationService>().goBack();
                              viewModel.copyMessage(index);
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
                            AssetsManager.messageJar,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          ContentTextWidget(
                              label: viewModel.list[index].text,
                              textAlign: TextAlign.center),
                        ],
                      ),
                      actions: [
                        Center(
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  backgroundColor:
                                      Theme.of(context).iconTheme.color,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                viewModel.goBack();
                              },
                              child: SubtitleTextWidget(
                                label: "اغلاق",
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                              )),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: SubtitleTextWidget(
                      label: "بقلم : ${viewModel.list[index].userName}",
                      fontSize: 16,
                      maxLines: 1,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SubtitleTextWidget(
                      label: viewModel.list[index].createdAt,
                      fontSize: 14,
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ContentTextWidget(
                        label: viewModel.list[index].text,
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: Colors.grey, thickness: 1),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: IconButton(
                              onPressed: () {
                                if (!viewModel.list[index].isFavourite) {
                                  viewModel.saveFavoriteMessage(index);
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.success(
                                      backgroundColor:
                                          Theme.of(context).iconTheme.color!,
                                      message: "تمت الإضافة للمفضلة",
                                      icon: Icon(
                                        IconlyBold.heart,
                                        color: Theme.of(context).cardColor,
                                        size: 50,
                                      ),
                                    ),
                                  );
                                } else {
                                  viewModel.removeFavoriteMessage(index);
                                }
                              },
                              icon: viewModel.list[index].isFavourite
                                  ? Icon(IconlyBold.heart,
                                      color: Theme.of(context).iconTheme.color)
                                  : Icon(IconlyLight.heart,
                                      color:
                                          Theme.of(context).iconTheme.color)),
                        ),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              viewModel.showBinyAd();
                              viewModel.copyMessage(index);
                              showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.success(
                                  backgroundColor:
                                      Theme.of(context).iconTheme.color!,
                                  message: "تم النسخ",
                                  icon: Icon(
                                    Icons.copy,
                                    color: Theme.of(context).cardColor,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.copy,
                                color: Theme.of(context).iconTheme.color),
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              viewModel.shareMessage(index);
                            },
                            icon: Icon(Icons.share,
                                color: Theme.of(context).iconTheme.color),
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              viewModel.shareWhatsapp(index);
                            },
                            icon: SvgPicture.asset(
                              AssetsManager.whatsapp,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).iconTheme.color!,
                                  BlendMode.srcIn),
                            ),
                          ),
                        ),
                        if (Platform.isAndroid)
                          Flexible(
                            child: IconButton(
                              onPressed: () {
                                viewModel.shareFacebook(index);
                              },
                              icon: Icon(Icons.facebook,
                                  color: Theme.of(context).iconTheme.color),
                            ),
                          ),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              viewModel.sharePhoto(index, context);
                            },
                            icon: Icon(Icons.photo,
                                color: Theme.of(context).iconTheme.color),
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              viewModel.showBinyAd();
                              viewModel.saveToGallery(index, context);
                            },
                            icon: Icon(Icons.download,
                                color: Theme.of(context).iconTheme.color),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => verticalSpace(20),
      ),
    );
  }
}
