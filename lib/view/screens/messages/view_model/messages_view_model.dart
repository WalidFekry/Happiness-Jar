import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/shared_preferences_constants.dart';
import '../../../../db/app_database.dart';
import '../../../../enums/screen_state.dart';
import '../../../../enums/status.dart';
import '../../../../services/current_session_service.dart';
import '../../../../services/locator.dart';
import '../../../../models/resources.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/api_service.dart';
import '../../../../services/shared_pref_services.dart';
import '../model/messages_model.dart';
import '../model/wheel_model.dart';

class MessagesViewModel extends BaseViewModel {
  List<Messages> list = [];
  List<String> favoriteIds = [];
  String? userName;
  String? lastGetMessagesTime;
  final apiService = locator<ApiService>();
  final prefs = locator<SharedPrefServices>();
  File? image;
  bool showEmptyJar = false;
  bool showMessages = true;
  bool noInternet = false;
  int currentPage = 0;
  bool nextMessage = true;
  bool prevMessage = false;
  bool showJarMessages = true;
  PageController? controller;
  double opacity = 1.0;
  List<WheelImage> wheelImagesList = [];
  final appDatabase = locator<AppDatabase>();
  final adsService = locator<AdsService>();

  Future<void> getUserData() async {
    await CurrentSessionService.getUserName();
    userName = CurrentSessionService.cachedUserName;
    setState(ViewState.Idle);
  }

  void setController() {
    controller = PageController(initialPage: currentPage);
    setState(ViewState.Idle);
  }

  Future<void> getLastMessagesTime() async {
    lastGetMessagesTime =
        await prefs.getString(SharedPrefsConstants.lastGetMessagesTime);
    if (lastGetMessagesTime != "") {
      DateTime lastRunTime = DateTime.parse(lastGetMessagesTime!);
      Duration difference = DateTime.now().difference(lastRunTime);
      await getMessages();
      if (difference.inHours >= 6) {
        showEmptyJar = false;
        showMessages = true;
      } else {
        print('Function has already been run within the last 6 hours.');
        showMessages = false;
        if (noInternet) {
          showEmptyJar = false;
          return;
        }
        showEmptyJar = true;
      }
    } else {
      showEmptyJar = false;
      showMessages = true;
      await getMessages();
    }
    setState(ViewState.Idle);
  }


  Future<void> getMessages() async {
    Resource<MessagesModel> resource = await apiService.getMessages();
    favoriteIds = await prefs.getStringList(SharedPrefsConstants.messageFavoriteIds);
    if (resource.status == Status.SUCCESS) {
      noInternet = false;
      list = resource.data!.content!;
      for (var message in list){
        message.isFavourite = favoriteIds.contains(message.id.toString());
      }
    } else {
      noInternet = true;
      showMessages = false;
    }
    setState(ViewState.Idle);
  }

  Future<void> shareMessage(int index) async {
    await Share.share('${list[index].body} \n\n من تطبيق برطمان السعادة 💙');
  }

  void copyMessage(int index) {
    FlutterClipboard.copy(
      '${list[index].body} \n\n من تطبيق برطمان السعادة 💙',
    );
  }

  nextMessages() {
    if (currentPage == 1) {
      showBinyAd();
    }
    if (currentPage >= 0 && currentPage < 3) {
      currentPage++;
      nextMessage = true;
      prevMessage = true;
    } else if (currentPage == 3) {
      // currentPage++;
      nextMessage = false;
      saveMessagesTime();
    }
    controller?.jumpToPage(currentPage);
    setState(ViewState.Idle);
  }

  prevMessages() {
    if (currentPage <= 4 && currentPage != 1) {
      currentPage--;
      prevMessage = true;
      nextMessage = true;
    } else if (currentPage == 1) {
      currentPage--;
      prevMessage = false;
    }
    controller?.jumpToPage(currentPage);
    setState(ViewState.Idle);
  }

  Future<void> saveMessagesTime() async {
    await prefs.saveString(SharedPrefsConstants.lastGetMessagesTime,
        DateTime.now().toIso8601String());
    getLastMessagesTime();
  }

  void changeOpacity() {
    opacity = 0.0;
    setState(ViewState.Idle);
  }

  void setJarMessages() {
    Duration duration = const Duration(seconds: 2);
    Future.delayed(duration, () {
      showJarMessages = !showJarMessages;
      setState(ViewState.Idle);
    });
  }

  Future<void> shareWhatsapp(int index) async {
    String message = '${list[index].body} \n\n من تطبيق برطمان السعادة 💙';
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
    String message = '${list[index].body} \n\n من تطبيق برطمان السعادة 💙';
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

  Future<void> saveFavoriteMessage(int index) async {
    DateTime now = DateTime.now();
    String createdAt = "${now.year}-${now.month}-${now.day}";
    await appDatabase.saveFavoriteMessage(list[index].body, createdAt);
    favoriteIds = await prefs.getStringList(SharedPrefsConstants.messageFavoriteIds);
    favoriteIds.add(list[index].id.toString());
    await prefs.saveStringList(SharedPrefsConstants.messageFavoriteIds, favoriteIds);
    list[index].isFavourite = !list[index].isFavourite;
    setState(ViewState.Idle);
  }

  void showBinyAd() {
    adsService.showInterstitialAd();
  }

  void destroy() {
    adsService.dispose();
  }

  Future<void> getWheelImages() async {
    wheelImagesList.clear();
    Resource<WheelModel> resource = await apiService.getAllWheelImages();
    if (resource.status == Status.SUCCESS) {
      wheelImagesList = resource.data!.wheel!;
    }else{
      wheelImagesList.add(WheelImage(id: 1, url: "null"));
    }
    setState(ViewState.Idle);
  }

  Future<void> saveImage(String? imageUrl) async {
    try {
      var response = await Dio()
          .get(imageUrl!, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: "hello");
      // if (result['isSuccess']) {
      // } else {}
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> removeFavoriteMessage(index) async {
    await appDatabase.deleteFavoriteMessageByText(list[index].body!);
    favoriteIds = await prefs.getStringList(SharedPrefsConstants.messageFavoriteIds);
    favoriteIds.remove(list[index].id.toString());
    await prefs.saveStringList(SharedPrefsConstants.messageFavoriteIds, favoriteIds);
    list[index].isFavourite = !list[index].isFavourite;
    setState(ViewState.Idle);
  }

}
