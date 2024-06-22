import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../consts/shared_preferences_constants.dart';
import '../../../../enums/screen_state.dart';
import '../../../../enums/status.dart';
import '../../../../locator.dart';
import '../../../../models/resources.dart';
import '../../../../services/api_service.dart';
import '../../../../services/shared_pref_services.dart';
import '../model/messages_model.dart';

class MessagesViewModel extends BaseViewModel {
  List<Messages> list = [];
  String? userName;
  String? lastGetMessagesTime;
  var apiService = locator<ApiService>();
  var prefs = locator<SharedPrefServices>();
  File? image;
  bool showEmptyJar = false;
  bool showMessages = true;
  bool noInternet = false;
  int currentPage = 0;
  bool nextMessage = true;
  bool prevMessage = true;
  PageController? controller;

  Future<void> getUserData() async {
    userName = await prefs.getString(SharedPrefsConstants.USER_NAME);
    setState(ViewState.Idle);
  }

  void setController() {
    controller = PageController(initialPage: currentPage);
    setState(ViewState.Idle);
  }

  Future<void> getLastMessagesTime() async {
    lastGetMessagesTime =
        await prefs.getString(SharedPrefsConstants.LAST_GET_MESSAGES_TIME);
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
        if(noInternet){
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
    if (list.isNotEmpty) {
      return;
    }
    Resource<MessagesModel> resource = await apiService.getMessages();
    if (resource.status == Status.SUCCESS) {
      noInternet = false;
      list = resource.data!.content!;
    }else{
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
    if (currentPage >= 0 && currentPage < 3) {
      currentPage++;
      nextMessage = true;
      prevMessage = true;
    } else if (currentPage == 3) {
      currentPage++;
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
    await prefs.saveString(SharedPrefsConstants.LAST_GET_MESSAGES_TIME, DateTime.now().toIso8601String());
  }
}
