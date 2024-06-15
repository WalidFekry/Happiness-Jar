import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../services/navigation_service.dart';

class MessageDialog{

  static void show(BuildContext context, MessageViewModel viewModel, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(20)),
          title: Row(
            children: [
              const Text('رسالة مكتبتي'),
              const Spacer(),
              IconButton(
                onPressed: () =>
                    viewModel.onShare(
                        viewModel.messagesList[index]),
                icon: const Icon(
                  Icons.share,
                  color: Color(0xff30894A),
                ),
              ),
              IconButton(
                onPressed: () {
                  locator<NavigationService>().goBack();
                  viewModel.copyMessage(
                      viewModel.messagesList[index]);
                },
                icon: const Icon(
                  CupertinoIcons.doc_on_clipboard_fill,
                  color: Color(0xff30894A),
                ),
              ),
            ],
          ),
          content: Text(
              '${viewModel.messagesList[index].body}'
          ),
          actions: [
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xff30894A),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            15))),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('حسناً',
                    style: TextStyle(
                        color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }
}