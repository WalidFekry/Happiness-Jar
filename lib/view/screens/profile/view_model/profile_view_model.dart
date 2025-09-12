import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:happiness_jar/constants/shared_preferences_constants.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/services/current_session_service.dart';
import 'package:happiness_jar/services/local_notification_service.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/profile/model/delete_account_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/app_constants.dart';
import '../../../../constants/local_notification_constants.dart';
import '../../../../enums/status.dart';
import '../../../../models/resources.dart';
import '../../../../services/api_service.dart';

class ProfileViewModel extends BaseViewModel {
  final prefs = locator<SharedPrefServices>();
  final apiService = locator<ApiService>();
  final localNotificationService = locator<LocalNotificationService>();
  String? userName;
  DateTime? userBirthday;
  String? version;
  File? image;
  bool isNotificationOn = true;
  static const platform = MethodChannel('battery_optimization_channel');

  String get formattedBirthday {
    if (userBirthday == null) return "";
    final d = userBirthday!;
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year;
    return "$year-$month-$day";
  }

  Future<void> getUserData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    userName = CurrentSessionService.cachedUserName;
    userBirthday = CurrentSessionService.cachedUserBirthday;
    final imagePath = CurrentSessionService.cachedUserImage;
    if (imagePath!.isNotEmpty) {
      image = File(imagePath);
    }
    isNotificationOn = await prefs.getBoolean(SharedPrefsConstants.isNotificationOn);
    setState(ViewState.Idle);
  }

  void logOut() {
    CurrentSessionService.clearSessionCache();
    clearPrefs();
    locator<NavigationService>().navigateToAndClearStack(RouteName.REGISTER);
  }

  Future<void> deleteAccount() async {
    final token = await FirebaseMessaging.instance.getToken();
    Resource<DeleteAccountModel> resource = await apiService.deleteAccount(token);
    if (resource.status == Status.SUCCESS) {
      logOut();
    }
  }

  Future<void> openPrivacyPolicy() async {
    final Uri url =
        Uri.parse('https://sites.google.com/view/happinessjar/home');
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> contactWithDeveloper() async {
    final Uri url = Uri.parse('https://www.facebook.com/Waleed.Fikri');
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> shareApp(RenderBox? box) async {
    await Share.share(
      AppConstants.shareApp,
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : const Rect.fromLTWH(0, 0, 1, 1),
    );
  }

  Future<void> contact() async {
    final Uri url = Uri.parse(
        'https://api.whatsapp.com/send/?phone=201094674881&text=%D8%A7%D8%B3%D8%AA%D9%81%D8%B3%D8%A7%D8%B1%20%D8%A8%D8%AE%D8%B5%D9%88%D8%B5%20%D8%AA%D8%B7%D8%A8%D9%8A%D9%82%20%D8%A8%D8%B1%D8%B7%D9%85%D8%A7%D9%86%20%D8%A7%D9%84%D8%B3%D8%B9%D8%A7%D8%AF%D8%A9%20..&type=phone_number&app_absent=0');
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void rateApp() {
    final InAppReview inAppReview = InAppReview.instance;
    inAppReview.openStoreListing(appStoreId: AppConstants.appStoreId);
  }

  Future<void> openFacebookPage() async {
    final Uri url = Uri.parse('https://www.facebook.com/App.Happiness');
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> changeProfileImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      DateTime date = DateTime.now();
      String newFileName = "$date.png";
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final File localImage = await image!.copy('$path/$newFileName');
      CurrentSessionService.setUserImage(localImage.path);
    }
    setState(ViewState.Idle);
  }

  void clearPrefs() {
    prefs.saveString(SharedPrefsConstants.userName, "");
    prefs.saveString(SharedPrefsConstants.userImage, "");
    prefs.saveInteger(SharedPrefsConstants.userBirthday, 0);
    prefs.saveString(SharedPrefsConstants.lastRefreshTokenTime, "");
    prefs.saveBoolean(SharedPrefsConstants.isLogin, false);
    setState(ViewState.Idle);
  }

  Future<void> changeUserName(String newUserName) async {
    final trimmedUserName = newUserName.trim();
    userName = trimmedUserName;
    CurrentSessionService.setUserName(trimmedUserName);

    final token = await FirebaseMessaging.instance.getToken();
    if (token?.isNotEmpty ?? false) {
      updateUserDataOnServer(token, trimmedUserName, userBirthday);
    }

    setState(ViewState.Idle);
  }

  Future<void> moreApps() async {
    String link;
    if (Platform.isAndroid) {
      link = "https://play.google.com/store/apps/dev?id=6257553101128037563";
    } else {
      link = "https://apps.apple.com/app/apple-store/id6450314729";
    }
    final Uri url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> openGithub() async {
    final Uri url =
    Uri.parse('https://github.com/WalidFekry/Happiness-Jar');
    launchUrl(url, mode: LaunchMode.externalApplication);
  }


  Future<void> requestBatteryOptimization() async {
    try {
      await platform.invokeMethod('battery_optimization_channel');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> enableNotification(bool value) async {
    if (value) {
      if(Platform.isAndroid) {
        requestBatteryOptimization();
      }
      localNotificationService.showRepeatedNotification();
      await prefs.saveBoolean(SharedPrefsConstants.isNotificationOn, true);
    }else{
      localNotificationService.cancelNotification(LocalNotificationConstants.notificationId);
      await prefs.saveBoolean(SharedPrefsConstants.isNotificationOn, false);
    }
    isNotificationOn = value;
    setState(ViewState.Idle);
  }

  void changeUserBirthday(result) {
    userBirthday = result;
    CurrentSessionService.setUserBirthday(userBirthday!);
  }

  Future<void> updateUserDataOnServer(String? token, String userName, DateTime? userBirthday) async {
    await apiService.refreshToken(token, userName, userBirthday);
  }
}
