import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:happiness_jar/constants/app_consts.dart';
import 'package:happiness_jar/constants/shared_preferences_constants.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../enums/status.dart';
import '../../../../models/resources.dart';
import '../../../../services/api_service.dart';
import '../../home/model/refresh_token.dart';

class ProfileViewModel extends BaseViewModel {
  final prefs = locator<SharedPrefServices>();
  final apiService = locator<ApiService>();
  String? userName;
  String? version;
  File? image;

  Future<void> getUserData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    userName = await prefs.getString(SharedPrefsConstants.userName);
    final imagePath = await prefs.getString(SharedPrefsConstants.userImage);
    if (imagePath.isNotEmpty) {
      image = File(imagePath);
    }
    setState(ViewState.Idle);
  }

  void logOut() {
    clearPrefs();
    locator<NavigationService>().navigateToAndClearStack(RouteName.REGISTER);
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

  Future<void> shareApp() async {
    await Share.share(AppConsts.shareApp);
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
    inAppReview.openStoreListing(appStoreId: AppConsts.appStoreId);
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
      await prefs.saveString(SharedPrefsConstants.userImage, localImage.path);
    }
    setState(ViewState.Idle);
  }

  void clearPrefs() {
    prefs.saveString(SharedPrefsConstants.userName, "");
    prefs.saveString(SharedPrefsConstants.userImage, "");
    prefs.saveBoolean(SharedPrefsConstants.isLogin, false);
    setState(ViewState.Idle);
  }

  Future<void> changeUserName(String newUserName) async {
    userName = newUserName;
    await prefs.saveString(SharedPrefsConstants.userName, newUserName);
    final fcmToken = await getFcmToken();
    await apiService.refreshToken(fcmToken, newUserName);
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

  Future<String?> getFcmToken() {
    return FirebaseMessaging.instance.getToken();
  }
}
