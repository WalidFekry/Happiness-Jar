import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/screens/messages/widgets/no_internet.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../constants/assets_manager.dart';
import '../../../widgets/title_text.dart';
import '../../base_screen.dart';
import '../view_model/messages_view_model.dart';
import '../widgets/card_message.dart';
import '../widgets/empty_message.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<MessagesViewModel>(
      onModelReady: (viewModel) {
        viewModel.getUserData();
        viewModel.setController();
        viewModel.getLastMessagesTime();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                    visible: viewModel.noInternet,
                    child: NoInternetWidget(viewModel.userName)),
                Visibility(
                    visible: viewModel.noInternet,
                    child: verticalSpace(25)),
                Visibility(
                    visible: viewModel.showEmptyJar,
                    child: EmptyMessageWidget(viewModel.userName)),
                Visibility(
                  visible: viewModel.showMessages,
                  child: viewModel.list.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).iconTheme.color,
                            strokeAlign: 5,
                            strokeWidth: 5,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                viewModel.changeOpacity();
                                viewModel.setJarMessages();
                              },
                              child: Visibility(
                                visible: viewModel.showJarMessages,
                                child: AnimatedOpacity(
                                  opacity: viewModel.opacity,
                                  duration: const Duration(seconds: 2),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            const TitleTextWidget(
                                                label: "إضغط لفتح رسائل البرطمان 💙"),
                                            TitleTextWidget(
                                                label: 'يا ${viewModel.userName} 👇'),
                                            verticalSpace(15),
                                            Center(
                                              child: Image.asset(
                                                AssetsManager.appLogo,
                                                width: 150,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          bottom: -20,
                                          left: -100,
                                          child: Lottie.asset(
                                            AssetsManager.openBox,
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ]
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !viewModel.showJarMessages,
                              child: Column(
                                children: [
                                  TitleTextWidget(
                                      label:
                                          "رسالتك اليوم يا ${viewModel.userName} 🦋"),
                                  const TitleTextWidget(
                                      label: "من البرطمان 💙"),
                                  verticalSpace(20),
                                  SizedBox(
                                    height: size.height * 0.5,
                                    child: PageView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      controller: viewModel.controller,
                                      children: [
                                        CardMessageWidget(
                                          body: viewModel.list[0].body,
                                          imageUrl: viewModel.list[0].imageUrl,
                                        ),
                                        CardMessageWidget(
                                          body: viewModel.list[1].body,
                                          imageUrl: viewModel.list[1].imageUrl,
                                        ),
                                        CardMessageWidget(
                                          body: viewModel.list[2].body,
                                          imageUrl: viewModel.list[2].imageUrl,
                                        ),
                                        CardMessageWidget(
                                          body: viewModel.list[3].body,
                                          imageUrl: viewModel.list[3].imageUrl,
                                        ),
                                      ],
                                    ),
                                  ),
                                  verticalSpace(10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Visibility(
                                          visible: viewModel.prevMessage,
                                          child: Flexible(
                                            child: IconButton(
                                              icon: const Icon(
                                                  IconlyBold.arrow_right,
                                                  size: 35),
                                              onPressed: () {
                                                viewModel.prevMessages();
                                              },
                                            ),
                                          ),
                                        ),
                                        horizontalSpace(10),
                                        Flexible(
                                          child: IconButton(
                                            icon: const Icon(Icons.copy,
                                                size: 25),
                                            onPressed: () {
                                              viewModel.copyMessage(
                                                  viewModel.currentPage);
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: IconButton(
                                            icon: const Icon(Icons.share,
                                                size: 25),
                                            onPressed: () {
                                              viewModel.shareMessage(
                                                  viewModel.currentPage);
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: IconButton(
                                            icon: viewModel
                                                    .list[viewModel.currentPage]
                                                    .isFavourite
                                                ? Icon(IconlyBold.heart,
                                                    color: Theme.of(context)
                                                        .iconTheme
                                                        .color)
                                                : Icon(IconlyLight.heart,
                                                    color: Theme.of(context)
                                                        .iconTheme
                                                        .color),
                                            onPressed: () {
                                              viewModel.saveFavoriteMessage(
                                                  viewModel.currentPage);
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
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: IconButton(
                                            onPressed: () {
                                              viewModel.shareWhatsapp(
                                                  viewModel.currentPage);
                                            },
                                            icon: SvgPicture.asset(
                                              AssetsManager.whatsapp,
                                              width: 24,
                                              height: 24,
                                              colorFilter: ColorFilter.mode(
                                                Theme.of(context)
                                                    .iconTheme
                                                    .color!,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if(Platform.isAndroid)
                                        Flexible(
                                          child: IconButton(
                                            onPressed: () {
                                              viewModel.shareFacebook(
                                                  viewModel.currentPage);
                                            },
                                            icon: Icon(Icons.facebook,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color),
                                          ),
                                        ),
                                        horizontalSpace(10),
                                        Visibility(
                                          visible: viewModel.nextMessage,
                                          child: Flexible(
                                            child: IconButton(
                                              icon: const Icon(
                                                  IconlyBold.arrow_left,
                                                  size: 35),
                                              onPressed: () {
                                                viewModel.nextMessages();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
