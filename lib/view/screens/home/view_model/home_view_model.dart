import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:happiness_jar/consts/shared_preferences_constants.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/home/model/refresh_token.dart';
import 'package:happiness_jar/view/screens/home/model/today_advice.dart';
import 'package:happiness_jar/view/screens/home/widgets/open_setting_app_dialog.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../enums/status.dart';
import '../../../../models/resources.dart';
import '../../../../services/api_service.dart';
import '../widgets/greeting_dialog.dart';

class HomeViewModel extends BaseViewModel {
  final prefs = locator<SharedPrefServices>();
  final apiService = locator<ApiService>();
  bool isLogin = false;
  bool getStarted = false;
  String? lastRefreshTokenTime;
  String? lastTimeToShowInAppReview;
  String? getTodayAdviceTime;
  File? image;
  String? giftBoxMessage;
  final GreetingDialog greetingDialog = GreetingDialog();
  final InAppReview inAppReview = InAppReview.instance;

  Future<void> getTodayAdvice() async {
    getTodayAdviceTime =
        await prefs.getString(SharedPrefsConstants.GET_TODAY_ADVICE_TIME);
    if (getTodayAdviceTime == "") {
      getAdvice();
    } else {
      DateTime lastRunTime = DateTime.parse(getTodayAdviceTime!);
      Duration difference = DateTime.now().difference(lastRunTime);
      if (difference.inHours >= 24) {
        getAdvice();
      }
    }
  }

  Future<void> showInAppReview() async {
    lastTimeToShowInAppReview = await prefs
        .getString(SharedPrefsConstants.LAST_TIME_TO_SHOW_IN_APP_REVIEW);
    if (lastTimeToShowInAppReview == "") {
      await prefs.saveString(
          SharedPrefsConstants.LAST_TIME_TO_SHOW_IN_APP_REVIEW,
          DateTime.now().toIso8601String());
    } else {
      DateTime lastRunTime = DateTime.parse(lastTimeToShowInAppReview!);
      Duration difference = DateTime.now().difference(lastRunTime);
      if (difference.inHours >= 72) {
        if (await inAppReview.isAvailable()) {
          inAppReview.requestReview();
        }
        await prefs.saveString(
            SharedPrefsConstants.LAST_TIME_TO_SHOW_IN_APP_REVIEW,
            DateTime.now().toIso8601String());
      }
    }
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
      if (difference.inHours >= 48) {
        await sendToken();
      } else {
        print('Function has already been run within the last 48 hours.');
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
      Resource<RefreshTokenModel> resource =
          await apiService.refreshToken(value!, userName);
      if (resource.status == Status.SUCCESS) {
        await prefs.saveString(SharedPrefsConstants.LAST_REFRESH_TOKEN_TIME,
            DateTime.now().toIso8601String());
      }
    });
  }

  void showGreetingDialog(BuildContext context) {
    greetingDialog.showGreeting(context);
  }

  Future<void> checkNotificationsPermission(BuildContext context) async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
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

  Future<void> getAdvice() async {
    Resource<TodayAdviceModel> resource = await apiService.getAdviceMessage();
    if (resource.status == Status.SUCCESS) {
      giftBoxMessage = resource.data!.body;
    }
  }
}
