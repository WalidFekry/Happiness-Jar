import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/posts/view_model/posts_view_model.dart';
import 'package:happiness_jar/view/screens/posts/widgets/add_post.dart';
import 'package:happiness_jar/view/screens/posts/widgets/empty_posts.dart';
import 'package:happiness_jar/view/screens/posts/widgets/posts_list_view.dart';

import '../../../../helpers/spacing.dart';
import '../../../widgets/custom_circular_progress_Indicator.dart';
import '../../base_screen.dart';
import '../dialogs/add_post_dialog.dart';
import '../widgets/floating_action_button_add_post.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<PostsViewModel>(onModelReady: (viewModel) {
      viewModel.scrollController.addListener(viewModel.onScroll);
      viewModel.getPosts();
    }, onFinish: (viewModel) {
      viewModel.destroyAds();
      viewModel.disposeScrollController();
    }, builder: (context, viewModel, child) {
      return Scaffold(
         floatingActionButton: const FloatingActionButtonAddPost(),
          body: Stack(
        children: [
          viewModel.list.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Column(
                    children: [
                      if (!viewModel.isLocalDatebase) AddPost(viewModel),
                      verticalSpace(10),
                      PostsListView(viewModel)
                    ],
                  ),
                )
              : CustomCircularProgressIndicator(visible: viewModel.isDone),
          if (viewModel.isLoading)
            CustomCircularProgressIndicator(visible: viewModel.isLoading),
          if (!viewModel.isDone) const EmptyPosts()
        ],
      ));
    });
  }
}
