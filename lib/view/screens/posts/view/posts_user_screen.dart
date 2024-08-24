import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:happiness_jar/view/screens/posts/view_model/posts_view_model.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../base_screen.dart';
import '../widgets/empty_posts_user.dart';
import '../widgets/posts_list_view.dart';

class PostsUserScreen extends StatelessWidget {
  const PostsUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<PostsViewModel>(onModelReady: (viewModel) {
      viewModel.getLocalPost();
      viewModel.showBannerAd();
    }, onFinish: (viewModel) {
      viewModel.destroyAds();
    }, builder: (context, viewModel, child) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'منشوراتي',),
        body: Stack(
          children: [
            viewModel.list.isNotEmpty
                ? Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      children: [
                        PostsListView(viewModel),
                      ],
                    ),
                  )
                : Visibility(
                    visible: viewModel.isDone,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).iconTheme.color,
                        strokeAlign: 5,
                        strokeWidth: 5,
                      ),
                    ),
                  ),
            if (!viewModel.isDone) const EmptyPostsUser()
          ],
        ),
        bottomNavigationBar: viewModel.isBottomBannerAdLoaded
            ? SizedBox(
                height: viewModel.bannerAd?.size.height.toDouble(),
                width: viewModel.bannerAd?.size.width.toDouble(),
                child: AdWidget(ad: viewModel.bannerAd!),
              )
            : const SizedBox(),
      );
    });
  }
}
