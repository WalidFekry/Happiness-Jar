import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/shared_preferences_constants.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/notifications/widgets/notification_screenshot.dart';

import '../../../../db/app_database.dart';
import '../../../../enums/screen_state.dart';
import '../../../../enums/status.dart';
import '../../../../helpers/common_functions.dart';
import '../../../../models/resources.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/api_service.dart';
import '../../../../services/locator.dart';
import '../../../../services/navigation_service.dart';
import '../../../../services/shared_pref_services.dart';
import '../model/notification_model.dart';

class NotificationsViewModel extends BaseViewModel {
  List<MessagesNotifications> list = [];
  List<String> favoriteIds = [];
  final apiService = locator<ApiService>();
  final appDatabase = locator<AppDatabase>();
  final prefs = locator<SharedPrefServices>();
  bool isDone = true;
  final adsService = locator<AdsService>();
  int limit = 100;
  int offset = 0;
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();

  Future<void> getContent() async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    setState(ViewState.Idle);
    Resource<NotificationsModel> resource = await apiService
        .getMessagesNotificationContent(limit: limit, offset: offset);
    favoriteIds =
        await prefs.getStringList(SharedPrefsConstants.notificationFavoriteIds);
    if (resource.status == Status.SUCCESS) {
      isDone = true;
      list.addAll(resource.data!.content!);
      for (var message in list) {
        message.isFavourite = favoriteIds.contains(message.id.toString());
      }
      await appDatabase.insertData(resource);
      offset += limit;
    } else {
      list = await appDatabase.getMessagesNotificationContent();
      for (var message in list) {
        message.isFavourite = favoriteIds.contains(message.id.toString());
      }
      if (list.isEmpty) {
        isDone = false;
      }
    }
    isLoading = false;
    setState(ViewState.Idle);
  }

  void onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      getContent();
    }
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
        await prefs.getStringList(SharedPrefsConstants.notificationFavoriteIds);
    favoriteIds.add(list[index].id.toString());
    await prefs.saveStringList(
        SharedPrefsConstants.notificationFavoriteIds, favoriteIds);
    list[index].isFavourite = !list[index].isFavourite;
    setState(ViewState.Idle);
  }

  Future<void> removeFavoriteMessage(int index) async {
    await appDatabase.deleteFavoriteMessageByText(list[index].text!);
    favoriteIds =
        await prefs.getStringList(SharedPrefsConstants.notificationFavoriteIds);
    favoriteIds.remove(list[index].id.toString());
    await prefs.saveStringList(
        SharedPrefsConstants.notificationFavoriteIds, favoriteIds);
    list[index].isFavourite = !list[index].isFavourite;
    setState(ViewState.Idle);
  }

  void goBack() {
    locator<NavigationService>().goBack();
  }

  void shareWhatsapp(int index) {
    CommonFunctions.shareWhatsapp(list[index].text);
  }

  void shareFacebook(int index) {
    CommonFunctions.shareFacebook(list[index].text);
  }

  void saveToGallery(int index, BuildContext context) async {
    CommonFunctions.saveToGallery(context, NotificationScreenshot(list[index]));
  }

  void sharePhoto(int index) async {
    CommonFunctions.sharePhoto(
        list[index].text, NotificationScreenshot(list[index]));
  }

  void showBinyAd() {
    adsService.showInterstitialAd();
  }

  void disposeAds() {
    adsService.dispose();
  }

  void disposeScrollController() {
    scrollController.dispose();
  }
}
