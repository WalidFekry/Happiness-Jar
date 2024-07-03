import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happiness_jar/view/screens/messages/widgets/no_internet.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

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
                            InkWell(
                              onTap: () {
                                viewModel.setJarMessages();
                              },
                              child: Visibility(
                                visible: viewModel.showJarMessages,
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
                                         body:
                                         "البرطمان خلص ⌛ \n لقد انتهت رسائلك اليوم ✅ \n عُد غداً لترى رسائلك الجديدة 💙",
                                         imageUrl: null,
                                       ),
                                     ],
                                   ),
                                 ),
                                 const SizedBox(height: 10),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Visibility(
                                       visible: viewModel.prevMessage,
                                       child: IconButton(
                                         icon: const Icon(IconlyBold.arrow_right,
                                             size: 35),
                                         onPressed: () {
                                           viewModel.prevMessages();
                                         },
                                       ),
                                     ),
                                     const SizedBox(width: 10),
                                     IconButton(
                                       icon: const Icon(Icons.copy, size: 25),
                                       onPressed: () {
                                         viewModel
                                             .copyMessage(viewModel.currentPage);
                                       },
                                     ),
                                     IconButton(
                                       icon: const Icon(Icons.share, size: 25),
                                       onPressed: () {
                                         viewModel
                                             .shareMessage(viewModel.currentPage);
                                       },
                                     ),
                                     IconButton(
                                       onPressed: () {
                                         viewModel.shareWhatsapp(viewModel.currentPage);
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
                                         viewModel.shareFacebook(viewModel.currentPage);
                                       },
                                       icon: Icon(Icons.facebook,color:Theme.of(context).iconTheme.color),
                                     ),
                                     const SizedBox(width: 10),
                                     Visibility(
                                       visible: viewModel.nextMessage,
                                       child: IconButton(
                                         icon: const Icon(
                                           IconlyBold.arrow_left,
                                           size: 35,
                                         ),
                                         onPressed: () {
                                           viewModel.nextMessages();
                                         },
                                       ),
                                     ),
                                   ],
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
