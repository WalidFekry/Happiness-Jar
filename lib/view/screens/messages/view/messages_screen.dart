import 'package:flutter/material.dart';
import 'package:happiness_jar/services/assets_manager.dart';
import 'package:happiness_jar/view/screens/base_screen.dart';
import 'package:happiness_jar/view/screens/messages/view_model/messages_view_model.dart';
import 'package:iconly/iconly.dart';

import '../../../widgets/app_name_text.dart';
import '../widgets/card_message.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late PageController controller;
  int currentPage = 0;
  bool lastMessage = true;

  @override
  void initState() {
    controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<MessagesViewModel>(
      onModelReady: (viewModel){
      },
      builder: (context, viewModel, child){
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.6,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller,
                    children: const [
                      CardMessageWidget(
                        color: Color(0xFF037884),
                      ),
                      CardMessageWidget(
                        color: Colors.black,
                      ),
                      CardMessageWidget(
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(IconlyBold.arrow_right,size: 35),
                      onPressed: () {
                        setState(() {
                          if(currentPage > 0){
                            currentPage--;
                            lastMessage = true;
                          }
                          controller.jumpToPage(currentPage);
                          print(currentPage);
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.share,size: 25),
                      onPressed: () {
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy,size: 25),
                      onPressed: () {
                      },
                    ),
                    const SizedBox(width: 10),
                    Visibility(
                      visible: lastMessage,
                      child:  IconButton(
                        icon: const Icon(IconlyBold.arrow_left,size: 35,),
                        onPressed: () {
                          setState(() {
                            if (currentPage < 2) {
                              currentPage++;
                            } else {
                              lastMessage = false;
                            }
                            controller.jumpToPage(currentPage);
                            print(currentPage);
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
