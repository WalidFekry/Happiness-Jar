import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/local_notification_constants.dart';
import 'package:happiness_jar/constants/shared_preferences_constants.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/services/current_session_service.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/home/model/refresh_token.dart';
import 'package:happiness_jar/view/screens/home/model/today_advice.dart';
import 'package:happiness_jar/view/screens/home/widgets/open_setting_app_dialog.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../db/app_database.dart';
import '../../../../enums/status.dart';
import '../../../../models/resources.dart';
import '../../../../routs/routs_names.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/api_service.dart';
import '../../../../services/local_notification_service.dart';
import '../../../../services/navigation_service.dart';
import '../model/notifications_count.dart';

class HomeViewModel extends BaseViewModel {
  final prefs = locator<SharedPrefServices>();
  final apiService = locator<ApiService>();
  final appDatabase = locator<AppDatabase>();
  final adsService = locator<AdsService>();
  final localNotificationService = locator<LocalNotificationService>();
  int notificationsCount = 0;
  int postsCount = 0;
  int newNotificationsCount = 0;
  int newPostsCount = 0;

  String? lastRefreshTokenTime;
  String? lastTimeToShowInAppReview;
  String? getTodayAdviceTime;
  File? image;
  String? giftBoxMessage;
  final InAppReview inAppReview = InAppReview.instance;

  /// Fetch today's advice message
  Future<void> getTodayAdvice() async {
    getTodayAdviceTime =
        await prefs.getString(SharedPrefsConstants.getTodayAdviceTime);
    if (getTodayAdviceTime == "" || _isTimeElapsed(getTodayAdviceTime!, 24)) {
      getAdvice();
    }
  }

  /// Show in-app review prompt if 72 hours have passed
  Future<void> showInAppReview() async {
    lastTimeToShowInAppReview =
        await prefs.getString(SharedPrefsConstants.lastTimeToShowInAppReview);
    if (lastTimeToShowInAppReview == "" ||
        _isTimeElapsed(lastTimeToShowInAppReview!, 72)) {
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
      setupLocalNotification();
      await prefs.saveString(SharedPrefsConstants.lastTimeToShowInAppReview,
          DateTime.now().toIso8601String());
    }
  }

  /// Fetch user data such as username and image
  Future<void> getUserData() async {
    await CurrentSessionService.getUserName();
    await CurrentSessionService.getUserImage();
    await CurrentSessionService.getUserBirthday();
    final imagePath = CurrentSessionService.cachedUserImage;
    if (imagePath!.isNotEmpty) {
      image = File(imagePath);
    }
    refreshToken();
    checkBirthdayReminder();
    setState(ViewState.Idle);
  }

  /// Refresh Firebase token if 24 hours have passed
  Future<void> refreshToken() async {
    lastRefreshTokenTime =
        await prefs.getString(SharedPrefsConstants.lastRefreshTokenTime);
    if (lastRefreshTokenTime == "" ||
        _isTimeElapsed(lastRefreshTokenTime!, 24)) {
      await sendToken();
    }
  }

  /// Send Firebase token to the server
  Future<void> sendToken() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("all");
    messaging.subscribeToTopic(Platform.isAndroid ? "android" : "ios");
    final String? userName = CurrentSessionService.cachedUserName;
    final DateTime? birthdate = CurrentSessionService.cachedUserBirthday;
    final String? token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) {
      return;
    }
    Resource<RefreshTokenModel> resource =
        await apiService.refreshToken(token, userName, birthdate);
    if (resource.status == Status.SUCCESS) {
      await prefs.saveString(SharedPrefsConstants.lastRefreshTokenTime,
          DateTime.now().toIso8601String());
    }
  }

  /// Fetch notifications count and update local values
  Future<void> getNotificationsCount() async {
    Resource<NotificationsCountModel> resource =
        await apiService.getNotificationsCount();
    if (resource.status == Status.SUCCESS) {
      notificationsCount = resource.data?.notificationsCount ?? 0;
      postsCount = resource.data?.postsCount ?? 0;
      int savedPostsCount =
          await prefs.getInteger(SharedPrefsConstants.postsCount);
      int savedNotificationsCount =
          await prefs.getInteger(SharedPrefsConstants.notificationsCount);
      newPostsCount = postsCount - savedPostsCount;
      newNotificationsCount = notificationsCount - savedNotificationsCount;
      if (newPostsCount > 99) {
        newPostsCount = 99;
      }
      if (newNotificationsCount > 99) {
        newNotificationsCount = 99;
      }
    }
    setState(ViewState.Idle);
  }

  /// Save notification counts locally
  void saveNotificationsCountLocal(String key) async {
    if (key == "notifications") {
      await prefs.saveInteger(
          SharedPrefsConstants.notificationsCount, notificationsCount);
    } else {
      await prefs.saveInteger(SharedPrefsConstants.postsCount, postsCount);
    }
  }

  /// Check for notification permission and request if necessary
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
              context: context,
              builder: (context) {
                return const OpenSettingAppDialog();
              });
        });
      }
    }
  }

  /// Fetch advice message from the database or API
  Future<void> getAdvice() async {
    giftBoxMessage = await appDatabase.getAdviceMessage();
    if (giftBoxMessage == null) {
      Resource<TodayAdviceModel> resource = await apiService.getAdviceMessage();
      if (resource.status == Status.SUCCESS) {
        await appDatabase.insertData(resource);
        giftBoxMessage = await appDatabase.getAdviceMessage();
      }
    }
    setState(ViewState.Idle);
  }

  /// Show an ad
  void showOpenAd(BuildContext context) {
    adsService.showOpenAd(context);
  }

  /// Dispose of ad services
  void destroy() {
    adsService.dispose();
  }

  /// Setup local notification
  Future<void> setupLocalNotification() async {
    final bool isNotificationOn =
        await prefs.getBoolean(SharedPrefsConstants.isNotificationOn);
    if (!isNotificationOn) {
      return;
    }
    await localNotificationService
        .cancelNotification(LocalNotificationConstants.notificationId);
    await localNotificationService.showRepeatedNotification();
  }

  /// Helper method to check if the required time has passed
  bool _isTimeElapsed(String lastTime, int hours) {
    DateTime lastRunTime = DateTime.parse(lastTime);
    return DateTime.now().difference(lastRunTime).inHours >= hours;
  }

  Future<void> checkBirthdayReminder() async {
    final DateTime? birthday = CurrentSessionService.cachedUserBirthday;
    final String? userName = CurrentSessionService.cachedUserName;
    if (birthday == null || userName == null || userName.isEmpty) return;


    final String lastSentBirthdayDate = await prefs.getString(SharedPrefsConstants.lastSentBirthdayDate);
    final String today = DateTime.now().toIso8601String().substring(0, 10);

    final daysLeft = daysUntilBirthday(birthday);

    if (daysLeft == 0){
      locator<NavigationService>().navigateTo(RouteName.BIRTHDAY_CELEBRATION_SCREEN);
    }

    if (lastSentBirthdayDate == today) return;

    if (daysLeft == 3) {
      localNotificationService.showBirthdayNotification(
        " قرب يومك يا $userName! 🎂",
        "باقي 3 أيام على يوم ميلادك 🌸 أسأل الله أن يجعلها أيام فرح وخير لك 🤲",
      );
      await prefs.saveString(SharedPrefsConstants.lastSentBirthdayDate, today);
    } else if (daysLeft == 2) {
      localNotificationService.showBirthdayNotification(
        " يومك المميز بيقترب يا $userName 💙",
        "باقي يومين 🎉 ربنا يبارك في عمرك ويكتب لك السعادة 🙏",
      );
      await prefs.saveString(SharedPrefsConstants.lastSentBirthdayDate, today);
    } else if (daysLeft == 1) {
      localNotificationService.showBirthdayNotification(
        " بكرة يوم ميلادك يا $userName! 🥳",
        "جعله الله بداية سنة جديدة مليانة بركة وطاعات 🌙",
      );
      await prefs.saveString(SharedPrefsConstants.lastSentBirthdayDate, today);
    } else if (daysLeft == 0) {
      localNotificationService.showBirthdayNotification(
        " عيد ميلاد سعيد يا $userName 🎉",
        "كل سنة وأنت بخير 🌸 نسأل الله أن يرزقك السعادة والرضا ويجعل عمرك في طاعته 🤲",
      );
      await prefs.saveString(SharedPrefsConstants.lastSentBirthdayDate, today);
    }
  }

  int daysUntilBirthday(DateTime birthday) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var nextBirthday = DateTime(today.year, birthday.month, birthday.day);

    if (nextBirthday.isBefore(today)) {
      nextBirthday = DateTime(today.year + 1, birthday.month, birthday.day);
    }

    return nextBirthday.difference(today).inDays;
  }
}
