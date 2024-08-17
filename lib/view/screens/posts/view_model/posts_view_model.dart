import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/view/screens/posts/widgets/post_screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/ads_manager.dart';
import '../../../../constants/shared_preferences_constants.dart';
import '../../../../db/app_database.dart';
import '../../../../enums/status.dart';
import '../../../../models/resources.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/api_service.dart';
import '../../../../services/locator.dart';
import '../../../../services/navigation_service.dart';
import '../../../../services/shared_pref_services.dart';
import '../../base_view_model.dart';
import '../model/add_post_response_model.dart';
import '../model/like_post_response_model.dart';
import '../model/posts_model.dart';

class PostsViewModel extends BaseViewModel {
  final adsService = locator<AdsService>();
  final apiService = locator<ApiService>();
  final appDatabase = locator<AppDatabase>();
  final prefs = locator<SharedPrefServices>();
  List<PostItem> list = [];
  List<String> favoriteIds = [];
  List<String> likeIds = [];
  bool isDone = true;
  bool isLocalDatebase = false;
  String? userName;
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController postController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isBottomBannerAdLoaded = false;
  bool isLoadingAddPost = false;
  bool isLoadingLikePost = false;
  BannerAd? bannerAd;

  Future<void> getPosts() async {
    Resource<PostsModel> resource = await apiService.getPosts();
    await getFavoriteIdsAndLikeIds();
    if (resource.status == Status.SUCCESS) {
      list = resource.data!.content!;
      for (var message in list) {
        message.isFavourite = favoriteIds.contains(message.id.toString());
        message.isLike = likeIds.contains(message.id.toString());
      }
      isDone = true;
      isLocalDatebase = false;
    } else {
      list = await appDatabase.getUserPosts();
      if (list.isEmpty) {
        isDone = false;
      }
      isLocalDatebase = true;
    }
    setState(ViewState.Idle);
  }

  Future<void> getLocalPost() async {
    list = await appDatabase.getUserPosts();
    if (list.isEmpty) {
      isDone = false;
    }
    isLocalDatebase = true;
    setState(ViewState.Idle);
  }

  Future<void> getUserName() async {
    userName = await prefs.getString(SharedPrefsConstants.userName);
    userNameController.text = userName!;
    setState(ViewState.Idle);
  }

  void goBack() {
    locator<NavigationService>().goBack();
  }

  void navigateToPostsUserScreen() {
    locator<NavigationService>().navigateTo(RouteName.POSTS_USER_SCREEN);
  }

  Future<void> shareMessage(int index) async {
    await Share.share('${list[index].text} \n\n من تطبيق برطمان السعادة 💙');
  }

  void copyMessage(int index) {
    FlutterClipboard.copy(
      '${list[index].text} \n\n من تطبيق برطمان السعادة 💙',
    );
  }

  Future<void> saveFavoriteMessage(int index) async {
    DateTime now = DateTime.now();
    String createdAt = "${now.year}-${now.month}-${now.day}";
    await appDatabase.saveFavoriteMessage(list[index].text, createdAt);
    favoriteIds =
        await prefs.getStringList(SharedPrefsConstants.postsFavoriteIds);
    favoriteIds.add(list[index].id.toString());
    await prefs.saveStringList(
        SharedPrefsConstants.postsFavoriteIds, favoriteIds);
    list[index].isFavourite = !list[index].isFavourite;
    setState(ViewState.Idle);
  }

  Future<void> removeFavoriteMessage(int index) async {
    await appDatabase.deleteFavoriteMessageByText(list[index].text!);
    favoriteIds =
        await prefs.getStringList(SharedPrefsConstants.postsFavoriteIds);
    favoriteIds.remove(list[index].id.toString());
    await prefs.saveStringList(
        SharedPrefsConstants.postsFavoriteIds, favoriteIds);
    list[index].isFavourite = !list[index].isFavourite;
    setState(ViewState.Idle);
  }

  Future<void> shareWhatsapp(int index) async {
    String message = '${list[index].text} \n\n من تطبيق برطمان السعادة 💙';
    String encodedMessage = Uri.encodeComponent(message);
    String whatsappUrl = "https://api.whatsapp.com/send?text=$encodedMessage";
    Uri uri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Share.share(message);
    }
  }

  Future<void> shareFacebook(int index) async {
    String message = '${list[index].text} \n\n من تطبيق برطمان السعادة 💙';
    String encodedMessage = Uri.encodeComponent(message);
    String facebookUrl =
        "https://www.facebook.com/sharer/sharer.php?u=$encodedMessage";
    Uri uri = Uri.parse(facebookUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Share.share(message);
    }
  }

  Future<void> saveToGallery(int index, BuildContext context) async {
    screenshotController
        .captureFromWidget(PostScreenshot(list[index]))
        .then((image) async {
      try {
        final result = await ImageGallerySaver.saveImage(image);
        if (result['isSuccess']) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              backgroundColor: Theme.of(context).iconTheme.color!,
              message: "تم الحفظ كصورة بنجاح",
              icon: Icon(
                Icons.download,
                color: Theme.of(context).cardColor,
                size: 50,
              ),
            ),
          );
        } else {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              backgroundColor: Theme.of(context).cardColor,
              message: "حدث خطأ أثناء حفظ الصورة",
              icon: Icon(
                Icons.download,
                color: Theme.of(context).iconTheme.color,
                size: 50,
              ),
            ),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('خطأ أثناء حفظ أو مشاركة الصورة: $e');
        }
      }
    });
  }

  Future<void> sharePhoto(int index, BuildContext context) async {
    screenshotController
        .captureFromWidget(PostScreenshot(list[index]))
        .then((image) async {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        final xFile = XFile(imagePath.path);
        await Share.shareXFiles(
          [xFile],
          subject: 'من تطبيق برطمان السعادة 💙',
          text: list[index].text,
        );
      } catch (e) {
        if (kDebugMode) {
          print('خطأ أثناء حفظ أو مشاركة الصورة: $e');
        }
      }
    });
  }

  void showBinyAd() {
    adsService.showInterstitialAd();
  }

  void clearUserName() {
    userNameController.clear();
    setState(ViewState.Idle);
  }

  void clearPost() {
    postController.clear();
    setState(ViewState.Idle);
  }

  void initController() {
    userNameController.addListener(() {
      setState(ViewState.Idle);
    });
    postController.addListener(() {
      setState(ViewState.Idle);
    });
  }

  void disposeController() {
    postController.dispose();
    userNameController.dispose();
  }

  Future<String?> getFcmToken() {
    return FirebaseMessaging.instance.getToken();
  }

  Future<bool> addPost() async {
    isLoadingAddPost = true;
    setState(ViewState.Idle);
    final fcmToken = await getFcmToken();
    Resource<AddPostResponseModel> resource = await apiService.addPost(
        fcmToken, postController.text, userNameController.text);
    if (resource.status == Status.SUCCESS && resource.data?.success != null) {
      await addPostToDatabase();
      await checkUserName();
      return true;
    } else {
      isLoadingAddPost = false;
      setState(ViewState.Idle);
      return false;
    }
  }

  Future<void> addPostToDatabase() async {
    DateTime now = DateTime.now();
    String createdAt = "${now.year}-${now.month}-${now.day}";
    PostItem postItem = PostItem(
      userName: userNameController.text,
      text: postController.text,
      createdAt: createdAt,
    );
    await appDatabase.insert(postItem);
  }

  Future<void> refreshPosts() async {
    list.clear();
    setState(ViewState.Idle);
    if (isLocalDatebase) {
      await getLocalPost();
    } else {
      await getPosts();
    }
  }

  void showBannerAd() {
    BannerAd(
      adUnitId: AdsManager.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
          isBottomBannerAdLoaded = true;
          setState(ViewState.Idle);
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  void destroyAds() {
    if (bannerAd != null) {
      bannerAd?.dispose();
      bannerAd = null;
      isBottomBannerAdLoaded = false;
    }
    adsService.dispose();
  }

  Future<void> checkUserName() async {
    if (userName == userNameController.text) {
      return;
    }
    await prefs.saveString(
        SharedPrefsConstants.userName, userNameController.text);
  }

  Future<void> deleteLocalPost(int index) async {
    await appDatabase.deleteLocalPost(list[index].id);
    getLocalPost();
  }

  Future<void> likePost(int index) async {
    isLoadingLikePost = true;
    setState(ViewState.Idle);
    Resource<LikePostResponseModel> resource =
        await apiService.likePost("Like", list[index].id);
    if (resource.status == Status.SUCCESS && resource.data?.success != null) {
      likeIds = await prefs.getStringList(SharedPrefsConstants.postsLikeIds);
      likeIds.add(list[index].id.toString());
      await prefs.saveStringList(SharedPrefsConstants.postsLikeIds, likeIds);
      list[index].isLike = !list[index].isLike;
      list[index].likes = list[index].likes! + 1;
    }
    isLoadingLikePost = false;
    setState(ViewState.Idle);
  }

  Future<void> unLikePost(int index) async {
    isLoadingLikePost = true;
    setState(ViewState.Idle);
    Resource<LikePostResponseModel> resource =
        await apiService.likePost("UnLike", list[index].id);
    if (resource.status == Status.SUCCESS && resource.data?.success != null) {
      likeIds = await prefs.getStringList(SharedPrefsConstants.postsLikeIds);
      likeIds.remove(list[index].id.toString());
      await prefs.saveStringList(SharedPrefsConstants.postsLikeIds, likeIds);
      list[index].isLike = !list[index].isLike;
      list[index].likes = list[index].likes! - 1;
    }
    isLoadingLikePost = false;
    setState(ViewState.Idle);
  }

  Future<void> getFavoriteIdsAndLikeIds() async {
    favoriteIds =
        await prefs.getStringList(SharedPrefsConstants.postsFavoriteIds);
    likeIds = await prefs.getStringList(SharedPrefsConstants.postsLikeIds);
  }
}
