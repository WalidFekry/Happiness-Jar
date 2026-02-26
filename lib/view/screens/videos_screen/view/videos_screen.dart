import 'package:flutter/material.dart';

import '../../../widgets/custom_circular_progress_Indicator.dart';
import '../../../widgets/custom_linear_progress_Indicator.dart';
import '../../base_screen.dart';
import '../view_model/videos_view_model.dart';
import '../widgets/video_reel_item.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<VideosViewModel>(
      onModelReady: (viewModel) {
        viewModel.getVideos();
        viewModel.addListener(() {
          if (viewModel.noInternet) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('لا يوجد اتصال بالانترنت'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('اغلاق'),
                      ),
                    ],
                  );
                },
              );
            });
          }
        });
      },
      onFinish: (viewModel) {
        viewModel.disposeControllers();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          body: SafeArea(
            child: viewModel.videosList.isNotEmpty
                ? PageView.builder(
                    controller: viewModel.pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: viewModel.videosList.length,
                    onPageChanged: (index) {
                      viewModel.setCurrentIndex(index);
                    },
                    itemBuilder: (context, index) {
                      final controller = viewModel.controllers[index];
                      if (controller == null ||
                          !controller.value.isInitialized) {
                        return const Center(
                            child: CustomCircularProgressIndicator());
                      }
                      return VideoReelItem(
                        video: viewModel.videosList[index],
                        controller: controller,
                        isActive: index == viewModel.currentIndex,
                        onLike: () {
                          viewModel.likeVideo(viewModel.videosList[index].id!);
                        },
                        onDownload: () {
                          viewModel.downloadVideo(index, context);
                        },
                        onShare: () {
                          viewModel.shareVideo(index);
                        },
                        isDownloaded: viewModel.isDownloaded(index),
                      );
                    },
                  )
                : const Center(child: CustomLinearProgressIndicator()),
          ),
        );
      },
    );
  }
}
