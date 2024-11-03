import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_jar/helpers/common_functions.dart';
import 'package:happiness_jar/view/screens/posts/view_model/posts_view_model.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../constants/assets_manager.dart';
import '../../../../helpers/spacing.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';
import '../dialogs/show_post_dialog.dart';

class PostsListView extends StatelessWidget {
  PostsListView(this.viewModel, {super.key});

  PostsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        color: Theme.of(context).cardColor,
        onRefresh: viewModel.refreshPosts,
        child: ListView.separated(
          itemCount: viewModel.list.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: GestureDetector(
                onTap: () {
                  viewModel.showBinyAd();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ShowPostDialog(viewModel, index);
                    },
                  );
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AssetsManager.quote,
                                width: 30,
                                height: 30,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).cardColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              horizontalSpace(10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SubtitleTextWidget(
                                    label:
                                        "بقلم : ${viewModel.list[index].userName}",
                                    fontSize: 16,
                                    maxLines: 1,
                                    overflew: TextOverflow.ellipsis,
                                  ),
                                  verticalSpace(2.5),
                                  SubtitleTextWidget(
                                    label: viewModel.list[index].createdAt,
                                    fontSize: 14,
                                    maxLines: 1,
                                    overflew: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!viewModel.isLocalDatebase)
                          Row(
                            children: [
                              SubtitleTextWidget(
                                label: '[${viewModel.list[index].likes}]',
                                fontSize: 16,
                                maxLines: 1,
                              ),
                              horizontalSpace(2.5),
                              !viewModel.isLoadingLikePost
                                  ? GestureDetector(
                                      onTap: () {
                                        if (!viewModel.list[index].isLike) {
                                          viewModel.likePost(index);
                                        } else {
                                          viewModel.unLikePost(index);
                                        }
                                      },
                                      child: SvgPicture.asset(
                                        viewModel.list[index].isLike
                                            ? AssetsManager.liked
                                            : AssetsManager.like,
                                        width: 25,
                                        height: 25,
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(context).cardColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    )
                                  : CircularProgressIndicator(
                                backgroundColor: Theme.of(context).cardColor,
                                strokeAlign: -2,
                                strokeWidth: 5,
                              ),
                            ],
                          ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ContentTextWidget(
                          label: viewModel.list[index].text,
                          textAlign: TextAlign.center,
                        )),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(color: Colors.grey, thickness: 1),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (!viewModel.isLocalDatebase)
                            Flexible(
                              child: IconButton(
                                  onPressed: () {
                                    if (!viewModel.list[index].isFavourite) {
                                      viewModel.saveFavoriteMessage(index);
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        CustomSnackBar.success(
                                          backgroundColor: Theme.of(context)
                                              .iconTheme
                                              .color!,
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
                                          color:
                                              Theme.of(context).iconTheme.color)
                                      : Icon(IconlyLight.heart,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color)),
                            ),
                          if (viewModel.isLocalDatebase)
                            Flexible(
                              child: IconButton(
                                onPressed: () {
                                  viewModel.deleteLocalPost(index);
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.error(
                                      backgroundColor:
                                          Theme.of(context).cardColor,
                                      message: "تم الحذف",
                                      icon: Icon(
                                        Icons.delete,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        size: 50,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(IconlyLight.delete,
                                    color: Theme.of(context).cardColor),
                              ),
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
                                viewModel.sharePhoto(index);
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
      ),
    );
  }
}
