import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/screens/messages/widgets/no_internet.dart';
import 'package:happiness_jar/view/widgets/custom_circular_progress_Indicator.dart';
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
      onFinish: (viewModel) {
        viewModel.destroy();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNoInternetWidget(viewModel),
                _buildEmptyJarWidget(viewModel),
                _buildMessagesWidget(viewModel, size, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoInternetWidget(MessagesViewModel viewModel) {
    return Visibility(
      visible: viewModel.noInternet,
      child: Column(
        children: [
          NoInternetWidget(viewModel.userName),
          verticalSpace(25),
        ],
      ),
    );
  }

  Widget _buildEmptyJarWidget(MessagesViewModel viewModel) {
    return Visibility(
      visible: viewModel.showEmptyJar,
      child: EmptyMessageWidget(viewModel.userName),
    );
  }

  Widget _buildMessagesWidget(MessagesViewModel viewModel, Size size, BuildContext context) {
    return Visibility(
      visible: viewModel.showMessages,
      child: viewModel.list.isEmpty
          ? const CustomCircularProgressIndicator(visible: true)
          : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildJarMessageButton(viewModel, context),
          _buildMessagesPageView(viewModel, size, context),
        ],
      ),
    );
  }

  Widget _buildJarMessageButton(MessagesViewModel viewModel, BuildContext context) {
    return GestureDetector(
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
              border: Border.all(color: Colors.grey, width: 1.0),
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
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TitleTextWidget(label: "إضغط لفتح رسائل البرطمان 💙"),
                  TitleTextWidget(label: 'يا ${viewModel.userName} 👇'),
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
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesPageView(MessagesViewModel viewModel, Size size, BuildContext context) {
    return Visibility(
      visible: !viewModel.showJarMessages,
      child: Column(
        children: [
          TitleTextWidget(label: "رسالتك اليوم يا ${viewModel.userName} 🦋"),
          const TitleTextWidget(label: "من البرطمان 💙"),
          verticalSpace(20),
          SizedBox(
            height: size.height * 0.5,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: viewModel.controller,
              children: List.generate(viewModel.list.length, (index) {
                return CardMessageWidget(
                  body: viewModel.list[index].body,
                  imageUrl: viewModel.list[index].imageUrl,
                );
              }),
            ),
          ),
          verticalSpace(10),
          _buildMessageActions(viewModel, context),
        ],
      ),
    );
  }

  Widget _buildMessageActions(MessagesViewModel viewModel, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPrevMessageButton(viewModel),
          horizontalSpace(10),
          _buildCopyButton(viewModel),
          _buildShareButton(viewModel),
          _buildFavoriteButton(viewModel, context),
          _buildWhatsappShareButton(viewModel, context),
          if (Platform.isAndroid) _buildFacebookShareButton(viewModel, context),
          horizontalSpace(10),
          _buildNextMessageButton(viewModel),
        ],
      ),
    );
  }

  Widget _buildPrevMessageButton(MessagesViewModel viewModel) {
    return Visibility(
      visible: viewModel.prevMessage,
      child: Flexible(
        child: IconButton(
          icon: const Icon(IconlyBold.arrow_right, size: 35),
          onPressed: () {
            viewModel.prevMessages();
          },
        ),
      ),
    );
  }

  Widget _buildNextMessageButton(MessagesViewModel viewModel) {
    return Visibility(
      visible: viewModel.nextMessage,
      child: Flexible(
        child: IconButton(
          icon: const Icon(IconlyBold.arrow_left, size: 35),
          onPressed: () {
            viewModel.nextMessages();
          },
        ),
      ),
    );
  }

  Widget _buildCopyButton(MessagesViewModel viewModel) {
    return Flexible(
      child: IconButton(
        icon: const Icon(Icons.copy, size: 25),
        onPressed: () {
          viewModel.copyMessage(viewModel.currentPage);
        },
      ),
    );
  }

  Widget _buildShareButton(MessagesViewModel viewModel) {
    return Flexible(
      child: IconButton(
        icon: const Icon(Icons.share, size: 25),
        onPressed: () {
          viewModel.shareMessage(viewModel.currentPage);
        },
      ),
    );
  }

  Widget _buildFavoriteButton(MessagesViewModel viewModel, BuildContext context) {
    return Flexible(
      child: IconButton(
        icon: viewModel.list[viewModel.currentPage].isFavourite
            ? Icon(IconlyBold.heart, color: Theme.of(context).iconTheme.color)
            : Icon(IconlyLight.heart, color: Theme.of(context).iconTheme.color),
        onPressed: () {
          if (!viewModel.list[viewModel.currentPage].isFavourite) {
            viewModel.saveFavoriteMessage(viewModel.currentPage);
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                backgroundColor: Theme.of(context).iconTheme.color!,
                message: "تمت الإضافة للمفضلة",
                icon: Icon(
                  IconlyBold.heart,
                  color: Theme.of(context).cardColor,
                  size: 50,
                ),
              ),
            );
          } else {
            viewModel.removeFavoriteMessage(viewModel.currentPage);
          }
        },
      ),
    );
  }

  Widget _buildWhatsappShareButton(MessagesViewModel viewModel, BuildContext context) {
    return Flexible(
      child: IconButton(
        onPressed: () {
          viewModel.shareWhatsapp(viewModel.currentPage);
        },
        icon: SvgPicture.asset(
          AssetsManager.whatsapp,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            Theme.of(context).iconTheme.color!,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildFacebookShareButton(MessagesViewModel viewModel, BuildContext context) {
    return Flexible(
      child: IconButton(
        onPressed: () {
          viewModel.shareFacebook(viewModel.currentPage);
        },
        icon: Icon(Icons.facebook, color: Theme.of(context).iconTheme.color),
      ),
    );
  }
}
