import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/notifications/view_model/notifications_view_model.dart';
import 'package:happiness_jar/view/screens/notifications/widgets/notifications_list_view.dart';
import 'package:happiness_jar/view/widgets/no_internet.dart';
import 'package:iconly/iconly.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../helpers/spacing.dart';
import '../../../widgets/custom_circular_progress_Indicator.dart';
import '../../base_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationsViewModel>(
      onModelReady: (viewModel) {
        viewModel.scrollController.addListener(viewModel.onScroll);
        viewModel.getContent();
      },
      onFinish: (viewModel) {
        viewModel.disposeAds();
        viewModel.disposeScrollController();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Stack(
            children: [
              _buildContent(context, viewModel),
              if (viewModel.isLoading)
                CustomCircularProgressIndicator(visible: viewModel.isLoading),
              if (!viewModel.isDone) const NoInternetWidget(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, NotificationsViewModel viewModel) {
    return viewModel.list.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          _buildSearchBar(context, viewModel),
          verticalSpace(10),
          Expanded(child: NotificationsListView(viewModel: viewModel)),
        ],
      ),
    )
        : CustomCircularProgressIndicator(visible: viewModel.isDone);
  }

  Widget _buildSearchBar(BuildContext context, NotificationsViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: viewModel.searchController,
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  await _performSearch(context, viewModel);
                  viewModel.previousSearch = value;
                }
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                labelText: 'ابحث عن الرسالة برقم الإشعار',
                prefixIcon: Icon(
                  IconlyLight.notification,
                  color: Theme.of(context).cardColor,
                ),
                suffixIcon: IconButton(
                  color: Theme.of(context).cardColor,
                  onPressed: () async {
                    if (viewModel.searchController.text.isNotEmpty) {
                      if (viewModel.searchController.text == viewModel.previousSearch) {
                        viewModel.onClearSearch();
                      } else {
                        await _performSearch(context, viewModel);
                        viewModel.previousSearch = viewModel.searchController.text;
                      }
                    }
                  },
                  icon: viewModel.searchController.text.isEmpty
                      ? const Icon(IconlyLight.search)
                      : const Icon(IconlyLight.close_square),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _performSearch(BuildContext context, NotificationsViewModel viewModel) async {
    bool isDone = await viewModel.getContentBySearch(
      int.parse(viewModel.searchController.text),
    );
    if (!isDone) {
      _showErrorSnackBar(context);
    }
  }

  void _showErrorSnackBar(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          backgroundColor: Theme.of(context).cardColor,
          message: "لم يتم العثور على الرسالة المطلوبة.",
        ),
      );
    });
  }
}

