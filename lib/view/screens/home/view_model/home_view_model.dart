import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:happiness_jar/consts/shared_preferences_constants.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/home/model/refresh_token.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../enums/status.dart';
import '../../../../models/resources.dart';
import '../../../../services/api_service.dart';
import '../../categories/view/categories_screen.dart';
import '../../favorite/view/favorite_screen.dart';
import '../../messages/view/messages_screen.dart';
import '../../notifications/view/notifications_screen.dart';
import '../../profile/view/profile_screen.dart';
import '../widgets/greeting_dialog.dart';

class HomeViewModel extends BaseViewModel {
  int selectedIndex = 0;
  PageController? controller;
  String? appBarTitle = "الرئيسية";
  var prefs = locator<SharedPrefServices>();
  var apiService = locator<ApiService>();
  bool isLogin = false;
  bool getStarted = false;
  String? lastRefreshTokenTime;
  File? image;
  final GreetingDialog greetingDialog = GreetingDialog();

  List<Widget> screens = [
    const MessagesScreen(),
    const NotificationsScreen(),
    const CategoriesScreen(),
    const FavoriteScreen(),
  ];

  void setController() {
    controller = PageController(initialPage: selectedIndex);
    setState(ViewState.Idle);
  }

  void jumpToPage(int index) {
    selectedIndex = index;
    controller?.jumpToPage(selectedIndex);
    switch (index) {
      case 0:
        appBarTitle = "رسائل البرطمان";
        break;
      case 1:
        appBarTitle = "إشعارات البرطمان";
        break;
      case 2:
        appBarTitle = "الأقسام";
        break;
      case 3:
        appBarTitle = "المفضلة";
        break;
      default:
        appBarTitle = "الرئيسية";
    }
    setState(ViewState.Idle);
  }

  setFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      jumpToPage(1);
    });
  }

  Future<void> getUserData() async {
    final imagePath = await prefs.getString(SharedPrefsConstants.USER_IMAGE);
    if (imagePath.isNotEmpty) {
      image = File(imagePath);
    }
  }

  Future<void> refreshToken() async {
    lastRefreshTokenTime =
        await prefs.getString(SharedPrefsConstants.LAST_REFRESH_TOKEN_TIME);
    if (lastRefreshTokenTime != "") {
      DateTime lastRunTime = DateTime.parse(lastRefreshTokenTime!);
      Duration difference = DateTime.now().difference(lastRunTime);
      if (difference.inHours >= 24) {
        await sendToken();
      } else {
        print('Function has already been run within the last 24 hours.');
      }
    } else {
      await sendToken();
    }
    setState(ViewState.Idle);
  }

  sendToken() async {
    String? userName = await prefs.getString(SharedPrefsConstants.USER_NAME);
    FirebaseMessaging.instance.subscribeToTopic("all");
    FirebaseMessaging.instance.getToken().then((value) async {
      Resource<RefreshTokenModel> resource = await apiService.refreshToken(value!,userName);
      if (resource.status == Status.SUCCESS) {
        await prefs.saveString(
            SharedPrefsConstants.LAST_REFRESH_TOKEN_TIME, DateTime.now().toIso8601String());
      }
    });
  }

  void showGreetingDialog(BuildContext context) {
      greetingDialog.showGreeting(context);
  }
}
