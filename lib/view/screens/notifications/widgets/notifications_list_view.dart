import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_jar/view/screens/notifications/view_model/notifications_view_model.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../constants/assets_manager.dart';
import '../../../../helpers/spacing.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';
class NotificationsListView extends StatelessWidget {
  const NotificationsListView({required this.viewModel,super.key});

  final NotificationsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: viewModel.scrollController,
      itemCount: viewModel.list.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Container(
            padding:
            const EdgeInsets.only(right: 5, left: 5, top: 5),
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
                      backgroundColor: Theme.of(context)
                          .scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(18)),
                      title: Row(
                        children: [
                          const TitleTextWidget(
                              label: "من إشعارات البرطمان",
                              fontSize: 18),
                          const Spacer(),
                          IconButton(
                            onPressed: () =>
                                viewModel.shareMessage(index),
                            icon: Icon(
                              Icons.share,
                              color: Theme.of(context)
                                  .iconTheme
                                  .color,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // locator<NavigationService>().goBack();
                              viewModel.copyMessage(index);
                            },
                            icon: Icon(
                              CupertinoIcons
                                  .doc_on_clipboard_fill,
                              color: Theme.of(context)
                                  .iconTheme
                                  .color,
                            ),
                          ),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AssetsManager.notificationJar,
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
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10),
                                  backgroundColor:
                                  Theme.of(context)
                                      .iconTheme
                                      .color,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          15))),
                              onPressed: () {
                                viewModel.goBack();
                              },
                              child: SubtitleTextWidget(
                                label: "اغلاق",
                                color: Theme.of(context)
                                    .primaryColor,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        SubtitleTextWidget(
                          label:
                          "إشعار رقم : ${viewModel.list[index].id}",
                          fontSize: 16,
                        ),
                        Image.asset(
                          AssetsManager.notificationJar,
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        ),
                        SubtitleTextWidget(
                          label: viewModel.list[index].createdAt
                              ?.split(" ")[0],
                          fontSize: 16,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ContentTextWidget(
                        label: viewModel.list[index].text,
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child:
                    Divider(color: Colors.grey, thickness: 1),
                  ),
                  Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: IconButton(
                              onPressed: () {
                                if (!viewModel
                                    .list[index].isFavourite) {
                                  viewModel
                                      .saveFavoriteMessage(index);
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.success(
                                      backgroundColor:
                                      Theme.of(context)
                                          .iconTheme
                                          .color!,
                                      message:
                                      "تمت الإضافة للمفضلة",
                                      icon: Icon(
                                        IconlyBold.heart,
                                        color: Theme.of(context)
                                            .cardColor,
                                        size: 50,
                                      ),
                                    ),
                                  );
                                } else {
                                  viewModel.removeFavoriteMessage(
                                      index);
                                }
                              },
                              icon: viewModel
                                  .list[index].isFavourite
                                  ? Icon(IconlyBold.heart,
                                  color: Theme.of(context)
                                      .iconTheme
                                      .color)
                                  : Icon(IconlyLight.heart,
                                  color: Theme.of(context)
                                      .iconTheme
                                      .color)),
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
                                  Theme.of(context)
                                      .iconTheme
                                      .color!,
                                  message: "تم النسخ",
                                  icon: Icon(
                                    Icons.copy,
                                    color: Theme.of(context)
                                        .cardColor,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.copy,
                                color: Theme.of(context)
                                    .iconTheme
                                    .color),
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              viewModel.shareMessage(index);
                            },
                            icon: Icon(Icons.share,
                                color: Theme.of(context)
                                    .iconTheme
                                    .color),
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
                                  Theme.of(context)
                                      .iconTheme
                                      .color!,
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
                                  color: Theme.of(context)
                                      .iconTheme
                                      .color),
                            ),
                          ),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              viewModel.sharePhoto(
                                  index);
                            },
                            icon: Icon(Icons.photo,
                                color: Theme.of(context)
                                    .iconTheme
                                    .color),
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              viewModel.showBinyAd();
                              viewModel.saveToGallery(
                                  index, context);
                            },
                            icon: Icon(Icons.download,
                                color: Theme.of(context)
                                    .iconTheme
                                    .color),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => verticalSpace(20),
    );
  }
}
