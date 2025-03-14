
import 'package:flutter/material.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/favorite/model/favorite_messages_model.dart';

import '../../../../helpers/common_functions.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/navigation_service.dart';
import '../widgets/favorite_screenshot.dart';

class FavoriteViewModel extends BaseViewModel {

  final appDatabase = locator<AppDatabase>();
  List<FavoriteMessagesModel> list = [];
  final adsService = locator<AdsService>();

  Future<void> getFavoriteMessages() async {
    list = await appDatabase.getFavoriteMessages();
    setState(ViewState.Idle);
  }

  Future<void> deleteFavoriteMessage(int index) async {
    await appDatabase.deleteFavoriteMessage(list[index].id);
    getFavoriteMessages();
  }

  void shareMessage(int index) {
    CommonFunctions.shareMessage(list[index].title);
  }

  void copyMessage(int index) {
    CommonFunctions.copyMessage(list[index].title);
  }

  void goBack() {
    locator<NavigationService>().goBack();
  }

  void shareWhatsapp(int index) {
    CommonFunctions.shareWhatsapp(list[index].title);
  }

  void shareFacebook(int index) {
    CommonFunctions.shareFacebook(list[index].title);
  }

  void saveToGallery(int index, BuildContext context) async {
    CommonFunctions.saveToGallery(context, FavoriteScreenshot(list[index]));
  }

  void sharePhoto(int index) async {
    CommonFunctions.sharePhoto(list[index].title, FavoriteScreenshot(list[index]));
  }

  void destroy() {
    adsService.dispose();
  }

  void showBinyAd() {
    adsService.showInterstitialAd();
  }
}