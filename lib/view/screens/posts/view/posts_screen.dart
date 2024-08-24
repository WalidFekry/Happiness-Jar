
import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/posts/view_model/posts_view_model.dart';
import 'package:happiness_jar/view/screens/posts/widgets/add_post.dart';
import 'package:happiness_jar/view/screens/posts/widgets/empty_posts.dart';
import 'package:happiness_jar/view/screens/posts/widgets/posts_list_view.dart';

import '../../../../helpers/spacing.dart';
import '../../base_screen.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<PostsViewModel>(onModelReady: (viewModel) {
       viewModel.getPosts();
    }, onFinish: (viewModel) {
      viewModel.destroyAds();
    }, builder: (context, viewModel, child) {
      return Scaffold(
          body: Stack(
            children: [
              viewModel.list.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  children: [
                    if(!viewModel.isLocalDatebase)
                    AddPost(viewModel),
                    verticalSpace(10),
                    PostsListView(viewModel)
                  ],
                ),
              )
                  : Center(
                child: Visibility(
                  visible: viewModel.isDone,
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).iconTheme.color,
                    strokeAlign: 5,
                    strokeWidth: 5,
                  ),
                ),
              ),
              if (!viewModel.isDone) const EmptyPosts()
            ],
          ));
    });
  }
}
