import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/feelings/view_model/feeling_view_model.dart';
import 'package:happiness_jar/view/screens/feelings/widgets/empty_feelings.dart';
import 'package:happiness_jar/view/screens/feelings/widgets/feelings_content_list_view.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

import '../../../../helpers/spacing.dart';
import '../../base_screen.dart';
import '../widgets/feelings_dropdown_button.dart';
import '../widgets/feelings_get_started.dart';

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
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Column(
                      children: [
                        verticalSpace(10),
                        const SubtitleTextWidget(
                          label: 'ما هو الإحساس الذي يسيطر عليك الآن؟',
                        ),
                        verticalSpace(10),
                        FeelingsDropdownButton(viewModel),
                        verticalSpace(10),
                        if (viewModel.listOfFeelingsContent.isNotEmpty) ...[
                          FeelingsContentListView(viewModel),
                          verticalSpace(20),
                          ContentTextWidget(
                            label: viewModel.listOfFeelingsContent[3].body,
                            textAlign: TextAlign.center,
                          ),
                        ] else ...[
                          verticalSpace(20),
                          const FeelingsGetStarted()
                        ],
                        verticalSpace(10),
                      ],
                    ))
                : Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: Center(
                      child: Visibility(
                        visible: viewModel.isDone,
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).iconTheme.color,
                          strokeAlign: 5,
                          strokeWidth: 5,
                        ),
                      ),
                    ),
                  ),
            if (!viewModel.isDone) const EmptyFeelings()
          ],
        ),
      ));
    });
  }
}
