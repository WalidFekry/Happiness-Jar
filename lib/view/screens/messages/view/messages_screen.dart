import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happiness_jar/view/screens/messages/widgets/no_internet.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../consts/assets_manager.dart';
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
                    visible: viewModel.showEmptyJar,
                    child: EmptyMessageWidget(viewModel.userName)),
                Visibility(
                  visible: viewModel.showMessages,
                  child: viewModel.list.isEmpty
                      ? Center(child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).iconTheme.color,
                    strokeAlign: 5,
                    strokeWidth: 5,
                  ),)
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const TitleTextWidget(
                                          label:
                                          "إضغط لفتح رسائل البرطمان 💙"),
                                      TitleTextWidget(label: 'يا ${viewModel.userName} 👇'),
                                      Center(
                                        child: Lottie.asset(
                                          AssetsManager.openBox,
                                          width: 300,
                                          height: 300,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
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
                                 const TitleTextWidget(label: "من البرطمان 💙"),
                                 const SizedBox(height: 20),
                                 SizedBox(
                                   height: size.height * 0.5,
                                   child: PageView(
                                     physics: const NeverScrollableScrollPhysics(),
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
                                       const CardMessageWidget(
                                         body: "لقد وصلت إلى نهاية رسائل البرطمان ⌛ \n عُد بعد 6 ساعات 🕕 \n لإكتشاف رسائل جديدة 💙",
                                       imageUrl: null,
                                       ),
                                     ],
                                   ),
                                 ),
                                 const SizedBox(height: 10),
                                 Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 20),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Visibility(
                                         visible: viewModel.prevMessage,
                                         child: Flexible(
                                           child: IconButton(
                                             icon: const Icon(IconlyBold.arrow_right, size: 35),
                                             onPressed: () {
                                               viewModel.prevMessages();
                                             },
                                           ),
                                         ),
                                       ),
                                       const SizedBox(width: 10),
                                       if (viewModel.currentPage != 4)
                                       Flexible(
                                         child: IconButton(
                                           icon: const Icon(Icons.copy, size: 25),
                                           onPressed: () {
                                             viewModel.copyMessage(viewModel.currentPage);
                                           },
                                         ),
                                       ),
                                       if (viewModel.currentPage != 4)
                                       Flexible(
                                         child: IconButton(
                                           icon: const Icon(Icons.share, size: 25),
                                           onPressed: () {
                                             viewModel.shareMessage(viewModel.currentPage);
                                           },
                                         ),
                                       ),
                                       if (viewModel.currentPage != 4)
                                       Flexible(
                                         child: IconButton(
                                           icon: viewModel.list[viewModel.currentPage]
                                               .isFavourite
                                               ? Icon(IconlyBold.heart,
                                               color:
                                               Theme.of(context)
                                                   .iconTheme
                                                   .color)
                                               : Icon(IconlyLight.heart,
                                               color:
                                               Theme.of(context)
                                                   .iconTheme
                                                   .color),
                                           onPressed: () {
                                             viewModel
                                                 .saveFavoriteMessage(
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
                                                   color:
                                                   Theme.of(context)
                                                       .cardColor,
                                                   size: 50,
                                                 ),
                                               ),
                                             );
                                           },
                                         ),
                                       ),
                                       if (viewModel.currentPage != 4)
                                       Flexible(
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
                                       ),
                                       if (viewModel.currentPage != 4)
                                       Flexible(
                                         child: IconButton(
                                           onPressed: () {
                                             viewModel.shareFacebook(viewModel.currentPage);
                                           },
                                           icon: Icon(Icons.facebook, color: Theme.of(context).iconTheme.color),
                                         ),
                                       ),
                                       const SizedBox(width: 10),
                                       Visibility(
                                         visible: viewModel.nextMessage,
                                         child: Flexible(
                                           child: IconButton(
                                             icon: const Icon(IconlyBold.arrow_left, size: 35),
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
