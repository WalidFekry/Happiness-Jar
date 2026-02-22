import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_jar/view/screens/videos_screen/widgets/video_actions.dart';
import 'package:video_player/video_player.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/assets_manager.dart';
import '../../../../helpers/common_functions.dart';
import '../../../../helpers/spacing.dart';
import '../../../../services/locator.dart';
import '../../../../services/navigation_service.dart';
import '../model/video_response_model.dart';

class VideoReelItem extends StatefulWidget {
  final Data video;
  final VideoPlayerController controller;
  final bool isActive;
  final VoidCallback? onLike;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final bool isDownloaded;

  const VideoReelItem({
    super.key,
    required this.video,
    required this.controller,
    required this.isActive,
    this.onLike,
    this.onDownload,
    this.isDownloaded = false,
    this.onShare,
  });

  @override
  State<VideoReelItem> createState() => _VideoReelItemState();
}

class _VideoReelItemState extends State<VideoReelItem> {
  bool _showActions = true;

  @override
  void didUpdateWidget(VideoReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive) {
      widget.controller.play();
    } else {
      widget.controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
        setState(() {});
      },
      child: Stack(
        children: [
          SizedBox.expand(
            child: Container(
              color: Colors.black,
              child: Center(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
          ),
          if (!_showActions)
            Positioned(
              right: 16,
              bottom: 120,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showActions = true;
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          if (_showActions)
            Positioned(
              top: 40,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.remove_red_eye,
                        color: Colors.white, size: 20),
                    horizontalSpace(6),
                    Text(
                      CommonFunctions.formatNumberArabic(widget.video.views!),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    horizontalSpace(12),
                    GestureDetector(
                      onTap: () {
                        locator<NavigationService>().goBack();
                      },
                      child: const Icon(
                        Icons.arrow_forward_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_showActions)
            Positioned(
              right: 12,
              bottom: 120,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showActions = false;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.onLike != null && !widget.video.isLiked!) {
                        widget.onLike!();
                        widget.video.likes = widget.video.likes! + 1;
                        widget.video.isLiked = true;
                      } else {
                        widget.video.likes = widget.video.likes! - 1;
                        widget.video.isLiked = false;
                      }
                      setState(() {});
                    },
                    child: VideoActionsItem(
                      text: CommonFunctions.formatNumberArabic(
                          widget.video.likes!),
                      iconSvg: SvgPicture.asset(
                        AssetsManager.like,
                        colorFilter: ColorFilter.mode(
                          widget.video.isLiked!
                              ? Theme.of(context).cardColor
                              : Theme.of(context).iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                      onTap: () {
                        if (widget.onShare != null) {
                          widget.onShare!();
                        }
                      },
                      child: const VideoActionsItem(
                          icon: Icons.share, text: 'مشاركة')),
                  const SizedBox(height: 16),
                  if (!widget.isDownloaded)
                    GestureDetector(
                        onTap: () {
                          if (widget.onDownload != null) {
                            widget.onDownload!();
                          }
                        },
                        child: const VideoActionsItem(
                            icon: Icons.download_rounded, text: 'تحميل')),
                ],
              ),
            ),
          if (!controller.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_arrow,
                size: 80,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
