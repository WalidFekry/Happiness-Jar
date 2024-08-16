import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/posts/view_model/posts_view_model.dart';
import 'package:happiness_jar/view/screens/posts/dialogs/add_post_dialog.dart';
import 'package:iconly/iconly.dart';

import '../../../widgets/title_text.dart';

class AddPost extends StatelessWidget {
  AddPost(this.viewModel,{super.key});

  PostsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TitleTextWidget(label: "كُن إيجابياً 💙"),
        const Spacer(),
        Icon(
          IconlyLight.arrow_left,
          color: Theme.of(context).iconTheme.color,
          size: 30,
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return const AddPostDialog();
              },
            );
          },
          icon: Icon(
            Icons.post_add,
            color: Theme.of(context).cardColor,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () {
            viewModel.navigateToPostsUserScreen();
          },
          icon: Icon(
            Icons.history,
            color: Theme.of(context).cardColor,
            size: 30,
          ),
        )
      ],
    );
  }
}
