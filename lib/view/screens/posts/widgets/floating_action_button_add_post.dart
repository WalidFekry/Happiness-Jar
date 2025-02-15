import 'package:flutter/material.dart';

import '../dialogs/add_post_dialog.dart';

class FloatingActionButtonAddPost extends StatelessWidget {
  const FloatingActionButtonAddPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const AddPostDialog();
          },
        );
      },
      backgroundColor: Theme.of(context).iconTheme.color,
      elevation: 6.0,
      tooltip: 'إضافة اقتباس جديد',
      child: const Icon(Icons.add, size: 28),
    );
  }
}
