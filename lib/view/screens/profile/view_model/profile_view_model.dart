import 'dart:io';

import 'package:happiness_jar/consts/app_consts.dart';
import 'package:happiness_jar/consts/shared_preferences_constants.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileViewModel extends BaseViewModel {

  final prefs = locator<SharedPrefServices>();
  String? userName;
  File? image;

  Future<void> getUserData() async {
   userName = await prefs.getString(SharedPrefsConstants.USER_NAME);
   final imagePath = await prefs.getString(SharedPrefsConstants.USER_IMAGE);
   if (imagePath.isNotEmpty) {
     image = File(imagePath);
   }
   setState(ViewState.Idle);
  }

  void logOut() {
    clearPrefs();
    locator<NavigationService>().navigateToAndClearStack(RouteName.REGISTER);
  }

  void openPrivacyPolicy(){
    final Uri url = Uri.parse('https://sites.google.com/view/happinessjar/home');
    launchUrl(url);
    }

  void contactWithDeveloper() {
    final Uri url = Uri.parse('https://www.facebook.com/Waleed.Fikri');
    launchUrl(url,mode: LaunchMode.externalApplication);
  }

  Future<void> shareApp() async {
    await Share.share(
        AppConsts.SHARE_APP);
  }

  void contact() {
    final Uri url = Uri.parse('https://api.whatsapp.com/send/?phone=201094674881&text=%D8%A7%D8%B3%D8%AA%D9%81%D8%B3%D8%A7%D8%B1%20%D8%A8%D8%AE%D8%B5%D9%88%D8%B5%20%D8%AA%D8%B7%D8%A8%D9%8A%D9%82%20%D8%A8%D8%B1%D8%B7%D9%85%D8%A7%D9%86%20%D8%A7%D9%84%D8%B3%D8%B9%D8%A7%D8%AF%D8%A9%20..&type=phone_number&app_absent=0');
    launchUrl(url,mode: LaunchMode.externalApplication);
  }

  void rateApp() {
    final InAppReview inAppReview = InAppReview.instance;
    inAppReview.openStoreListing(appStoreId: '284815942');
  }

  void openFacebookPage() {
    final Uri url = Uri.parse('https://www.facebook.com/App.Happiness');
    launchUrl(url,mode: LaunchMode.externalApplication);
  }

  Future<void> changeProfileImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      DateTime date = DateTime.now();
      String newFileName = "$date.png";
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final File localImage = await image!.copy('$path/$newFileName');
      await prefs.saveString(SharedPrefsConstants.USER_IMAGE, localImage.path);
    }
    setState(ViewState.Idle);
  }

  void clearPrefs() {
    prefs.saveString(SharedPrefsConstants.USER_NAME, "");
    prefs.saveString(SharedPrefsConstants.USER_IMAGE, "");
    prefs.saveBoolean(SharedPrefsConstants.IS_LOGIN, false);
    setState(ViewState.Idle);
  }

  void changeUserName(String newUserName) {
    userName = newUserName;
    prefs.saveString(SharedPrefsConstants.USER_NAME, newUserName);
    setState(ViewState.Idle);
  }

  void moreApps() {
    final Uri url = Uri.parse('https://play.google.com/store/apps/dev?id=6257553101128037563');
    launchUrl(url,mode: LaunchMode.externalApplication);
  }



}