import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happiness_jar/view/screens/notifications/view_model/notifications_view_model.dart';
import 'package:happiness_jar/view/screens/notifications/widgets/notifications_list_view.dart';
import 'package:happiness_jar/view/widgets/no_internet.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../constants/assets_manager.dart';
import '../../../../helpers/spacing.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/custom_circular_progress_Indicator.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';
import '../../base_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationsViewModel>(onModelReady: (viewModel) {
      viewModel.scrollController.addListener(viewModel.onScroll);
      viewModel.getContent();
    }, onFinish: (viewModel) {
      viewModel.disposeAds();
      viewModel.disposeScrollController();
    }, builder: (context, viewModel, child) {
      return Scaffold(
          body: Stack(
        children: [
          viewModel.list.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: NotificationsListView(viewModel: viewModel)
                )
              : CustomCircularProgressIndicator(visible: viewModel.isDone),
          if (viewModel.isLoading)
            CustomCircularProgressIndicator(visible: viewModel.isLoading),
          if (!viewModel.isDone) const NoInternetWidget()
        ],
      ));
    });
  }
}
