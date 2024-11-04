import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/shared_preferences_constants.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/notifications/widgets/notification_screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../db/app_database.dart';
import '../../../../enums/screen_state.dart';
import '../../../../enums/status.dart';
import '../../../../helpers/common_functions.dart';
import '../../../../services/locator.dart';
import '../../../../models/resources.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/api_service.dart';
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

  Future<void> getContent() async {
    Resource<NotificationsModel> resource =
        await apiService.getMessagesNotificationContent();
    favoriteIds = await prefs.getStringList(SharedPrefsConstants.notificationFavoriteIds);
    if (resource.status == Status.SUCCESS) {
      isDone = true;
      list = resource.data!.content!;
      for (var message in list){
        message.isFavourite = favoriteIds.contains(message.id.toString());
      }
      await appDatabase.insertData(resource);
    } else {
      list = await appDatabase.getMessagesNotificationContent();
      for (var message in list){
        message.isFavourite = favoriteIds.contains(message.id.toString());
      }
      if (list.isEmpty) {
        isDone = false;
      }
    }
    setState(ViewState.Idle);
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
    favoriteIds = await prefs.getStringList(SharedPrefsConstants.notificationFavoriteIds);
    favoriteIds.add(list[index].id.toString());
    await prefs.saveStringList(SharedPrefsConstants.notificationFavoriteIds, favoriteIds);
    list[index].isFavourite = !list[index].isFavourite;
    setState(ViewState.Idle);
  }

  Future<void> removeFavoriteMessage(int index) async {
    await appDatabase.deleteFavoriteMessageByText(list[index].text!);
    favoriteIds = await prefs.getStringList(SharedPrefsConstants.notificationFavoriteIds);
    favoriteIds.remove(list[index].id.toString());
    await prefs.saveStringList(SharedPrefsConstants.notificationFavoriteIds, favoriteIds);
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
    CommonFunctions.sharePhoto(list[index].text, NotificationScreenshot(list[index]));
  }

  void showBinyAd() {
  adsService.showInterstitialAd();
  }

  void destroy() {
    adsService.dispose();
  }


}
