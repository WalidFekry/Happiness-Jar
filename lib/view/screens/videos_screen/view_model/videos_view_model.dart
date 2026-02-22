import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vision_gallery_saver/vision_gallery_saver.dart';
import '../../../../enums/screen_state.dart';
import '../../../../enums/status.dart';
import '../../../../models/resources.dart';
import '../../../../services/api_service.dart';
import '../../../../services/locator.dart';
import '../../base_view_model.dart';
import '../model/video_response_model.dart';

class VideosViewModel extends BaseViewModel {
  final apiService = locator<ApiService>();
  List<Data> videosList = [];
  final PageController pageController = PageController();
  int currentIndex = 0;
  Map<int, VideoPlayerController> controllers = {};
  Set<int> likedVideos = {};
  Set<int> downloadedVideos = {};
  bool noInternet = false;

  Future<void> getVideos() async {
    Resource<VideoResponseModel> resource = await apiService.getVideos();
    if (resource.status == Status.SUCCESS) {
      videosList = resource.data!.data!.reversed.toList();
      await initializeVideoController(0);
      setCurrentIndex(0);
    }else{
      noInternet = true;
    }
    setState(ViewState.Idle);
  }

  Future<void> videoAction(String action, int id) async {
    await apiService.videoAction(action: action, id: id);
  }

  void likeVideo(int id) {
    if (likedVideos.contains(id)) {
      return;
    }
    likedVideos.add(id);
    videoAction("like", id);
  }

  Future<void> initializeVideoController(int index) async {
    if (controllers.containsKey(index)) return;
    try {
      final controller = VideoPlayerController.networkUrl(
          Uri.parse(videosList[index].videoUrl!));
      await controller.initialize();
      controller.setLooping(true);
      controllers[index] = controller;
      setState(ViewState.Idle);
    } catch (e) {
      debugPrint('Error initializing video controller at index $index: $e');
    }
  }

  void setCurrentIndex(int index) {
    currentIndex = index;

    controllers[currentIndex]?.play();

    controllers.forEach((i, controller) {
      if (i != currentIndex) controller.pause();
    });

    final keysToRemove =
        controllers.keys.where((i) => (i - currentIndex).abs() > 1).toList();
    for (var i in keysToRemove) {
      controllers[i]?.dispose();
      controllers.remove(i);
    }

    if (currentIndex + 1 < videosList.length) {
      initializeVideoController(currentIndex + 1);
    }
    if (currentIndex - 1 >= 0) {
      initializeVideoController(currentIndex - 1);
    }

    videoAction("view", videosList[currentIndex].id!);

    setState(ViewState.Idle);
  }

  Future<void> downloadVideo(int index, BuildContext context) async {
    if (downloadedVideos.contains(videosList[index].id)) return;

    final video = videosList[index];
    final url = video.videoUrl!;

    try {
      downloadedVideos.add(video.id!);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: Theme.of(context)
              .iconTheme
              .color!,
          message: "جاري تحميل الفيديو ⌛",
          icon: Icon(
            IconlyBold.heart,
            color: Theme.of(context).cardColor,
            size: 50,
          ),
        ),
      );
      setState(ViewState.Idle);

      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        if (sdkInt < 30) {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            debugPrint('Storage permission not granted');
            setState(ViewState.Idle);
            return;
          }
        }
      }

      final dir = await getTemporaryDirectory();
      final tempPath = '${dir.path}/video_${video.id}.mp4';


      final dio = Dio();
      await dio.download(url, tempPath);

      await VisionGallerySaver.saveFile(tempPath);

      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        await tempFile.delete();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              backgroundColor: Theme.of(context)
                  .iconTheme
                  .color!,
              message: "تم تحميل الفيديو بنجاح ✅",
              icon: Icon(
                IconlyBold.heart,
                color: Theme.of(context).cardColor,
                size: 50,
              ),
            ),
          );
        });
      }
    } catch (e) {
      debugPrint('Download error: $e');
    }
  }

  bool isDownloaded(int index) {
    return downloadedVideos.contains(videosList[index].id);
  }

  Future<void> shareVideo(int index) async {
    final video = videosList[index];
    final videoUrl = video.videoUrl;

    if (videoUrl == null || videoUrl.isEmpty) return;

    final shareText = '''
📹 شاهد هذا المقطع المميز:
$videoUrl

💚 لو حابب تشوف فيديوهات أكتر في التدبر والقرآن والمقاطع الدينية المؤثرة:

📱 حمّل تطبيق *مكتبتي بلس* الآن!
رفيقك اليومي لكل ما تحتاجه من:
• مواقيت الصلاة
• أذكار وأدعية
• مسابقات دينية
• محتوى إيماني متجدد
— وكل هذا بدون إنترنت وبواجهة سهلة وسريعة

🔹 Google Play:
https://play.google.com/store/apps/details?id=com.maktbti.plus

🔹 App Store:
https://apps.apple.com/app/id6450314729

🌿 شارك الخير وكن سببًا في نشر الفائدة
''';

    SharePlus.instance.share(
        ShareParams(text: shareText)
    );
  }

  void disposeControllers() {
    pageController.dispose();
    controllers.forEach((_, controller) => controller.dispose());
    controllers.clear();
    likedVideos.clear();
    downloadedVideos.clear();
  }
}
