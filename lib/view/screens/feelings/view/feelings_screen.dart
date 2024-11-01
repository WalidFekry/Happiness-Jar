
import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/feelings/view_model/feeling_view_model.dart';
import 'package:happiness_jar/view/screens/feelings/widgets/feelings_content_list_view.dart';
import 'package:happiness_jar/view/screens/posts/view_model/posts_view_model.dart';
import 'package:happiness_jar/view/screens/posts/widgets/add_post.dart';
import 'package:happiness_jar/view/screens/posts/widgets/empty_posts.dart';
import 'package:happiness_jar/view/screens/posts/widgets/posts_list_view.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';

import '../../../../helpers/spacing.dart';
import '../../base_screen.dart';
import '../model/FeelingsCategoriesModel.dart';
import '../widgets/feelings_dropdown_button.dart';

class FeelingsScreen extends StatelessWidget {
  const FeelingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<FeelingViewModel>(onModelReady: (viewModel) {
      viewModel.getListOfFeelingsCategories();
    }, onFinish: (viewModel) {
      // viewModel.destroyAds();
    }, builder: (context, viewModel, child) {
      return Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                viewModel.listOfFeelingsCategories.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Column(
                    children: [
                      verticalSpace(20),
                      const SubtitleTextWidget(label: 'ما هو الإحساس الذي يسيطر عليك الآن؟',),
                      verticalSpace(10),
                      FeelingsDropdownButton(viewModel),
                      verticalSpace(20),
                      FeelingsContentListView(viewModel),
                      verticalSpace(20),
                      ContentTextWidget(label: viewModel.listOfFeelingsContent[3].body, textAlign: TextAlign.center,),
                      verticalSpace(10),
                    ],
                  )
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
            ),
          ));
    });
  }
}
