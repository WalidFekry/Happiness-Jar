import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/helpers/common_functions.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/view/screens/posts/widgets/post_screenshot.dart';

import '../../../../constants/shared_preferences_constants.dart';
import '../../../../db/app_database.dart';
import '../../../../enums/status.dart';
import '../../../../models/resources.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/api_service.dart';
import '../../../../services/current_session_service.dart';
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
  bool isLoading = false;
  bool isLocalDatebase = false;
  String? userName;
  TextEditingController userNameController = TextEditingController();
  TextEditingController postController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();
  bool isLoadingAddPost = false;
  bool isLoadingLikePost = false;
  int limit = 10;
  int offset = 0;

  Future<void> getPosts() async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    setState(ViewState.Idle);
    Resource<PostsModel> resource =
        await apiService.getPosts(limit: limit, offset: offset);
    await getFavoriteIdsAndLikeIds();
    if (resource.status == Status.SUCCESS) {
      list.addAll(resource.data!.content!);
      for (var message in list) {
        message.isFavourite = favoriteIds.contains(message.id.toString());
        message.isLike = likeIds.contains(message.id.toString());
      }
      isDone = true;
      isLocalDatebase = false;
      offset += limit;
    } else {
      list = await appDatabase.getUserPosts();
      if (list.isEmpty) {
        isDone = false;
      }
      isLocalDatebase = true;
    }
    isLoading = false;
    setState(ViewState.Idle);
  }

  void onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      getPosts();
    }
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
    userName = CurrentSessionService.cachedUserName;
    userNameController.text = userName!;
    setState(ViewState.Idle);
  }

  void goBack() {
    locator<NavigationService>().goBack();
  }

  void navigateToPostsUserScreen() {
    locator<NavigationService>().navigateTo(RouteName.POSTS_USER_SCREEN);
  }

  void shareMessage(int index) {
    CommonFunctions.shareMessage(list[index].text);
  }

  void copyMessage(int index) {
    CommonFunctions.copyMessage(list[index].text);
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

  void shareWhatsapp(int index) {
    CommonFunctions.shareWhatsapp(list[index].text);
  }

  void shareFacebook(int index) {
    CommonFunctions.shareFacebook(list[index].text);
  }

  void saveToGallery(int index, BuildContext context) async {
    CommonFunctions.saveToGallery(context, PostScreenshot(list[index]));
  }

  void sharePhoto(int index) async {
    CommonFunctions.sharePhoto(list[index].text, PostScreenshot(list[index]));
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

  void disposeScrollController() {
    scrollController.dispose();
  }

  Future<bool> addPost() async {
    isLoadingAddPost = true;
    setState(ViewState.Idle);

    String? token =
        await FirebaseMessaging.instance.getToken() ?? "no fcm token";

    Resource<AddPostResponseModel> resource = await apiService.addPost(
      token,
      postController.text,
      userNameController.text,
    );
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
      offset = 0;
      await getPosts();
    }
  }

  void destroyAds() {
    adsService.dispose();
  }

  Future<void> checkUserName() async {
    if (userName == userNameController.text) {
      return;
    }
    CurrentSessionService.setUserName(userNameController.text);
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
