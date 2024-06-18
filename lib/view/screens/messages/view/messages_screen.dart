import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/base_screen.dart';
import 'package:happiness_jar/view/screens/messages/view_model/messages_view_model.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';
import 'package:iconly/iconly.dart';

import '../../../../services/assets_manager.dart';
import '../../../widgets/subtitle_text.dart';
import '../widgets/card_message.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late PageController controller;
  int currentPage = 0;
  bool nextMessage = true;
  bool prevMessage = true;

  @override
  void initState() {
    controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<MessagesViewModel>(
      onModelReady: (viewModel) {
        viewModel.getUserData();
        viewModel.getMessages();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleTextWidget(
                    label: "رسالتك اليوم يا ${viewModel.userName} 🦋"),
                const TitleTextWidget(
                    label: "من البرطمان 💙"),
                const SizedBox(height: 10),
                SizedBox(
                  height: size.height * 0.5,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller,
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
                      visible: prevMessage,
                      child: IconButton(
                        icon: const Icon(IconlyBold.arrow_right, size: 35),
                        onPressed: () {
                          setState(() {
                            print(currentPage);
                            if (currentPage <= 4 && currentPage != 1) {
                              currentPage--;
                              prevMessage = true;
                              nextMessage = true;
                            } else if (currentPage == 1) {
                              currentPage--;
                              prevMessage = false;
                            }
                            controller.jumpToPage(currentPage);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.share, size: 25),
                      onPressed: () {
                        viewModel.shareMessage(currentPage);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 25),
                      onPressed: () {
                        viewModel.copyMessage(currentPage);
                      },
                    ),
                    const SizedBox(width: 10),
                    Visibility(
                      visible: nextMessage,
                      child: IconButton(
                        icon: const Icon(
                          IconlyBold.arrow_left,
                          size: 35,
                        ),
                        onPressed: () {
                          setState(() {
                            if (currentPage >= 0 && currentPage < 3) {
                              currentPage++;
                              nextMessage = true;
                              prevMessage = true;
                            } else if (currentPage == 3) {
                              currentPage++;
                              nextMessage = false;
                            }
                            controller.jumpToPage(currentPage);
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
