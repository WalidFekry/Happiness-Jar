import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:happiness_jar/consts/shared_preferences_constants.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/home/model/refresh_token.dart';
import 'package:happiness_jar/view/screens/home/widgets/open_setting_app_dialog.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
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

  Future<void> checkNotificationsPermission(BuildContext context) async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      sound: true,
      alert: true,
      badge: true,
    );
     if (settings.authorizationStatus == AuthorizationStatus.denied) {
      var status = await Permission.notification.request();
      if (status.isPermanentlyDenied || status.isDenied) {
        OpenSettingAppDialog.show(context);
      } else {
        if (kDebugMode) {
          print('Permission denied with another status');
        }
      }
    }
  }

  void jumpToPage() {}


}
