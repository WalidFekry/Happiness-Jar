import 'package:happiness_jar/services/shared_pref_services.dart';

import '../constants/shared_preferences_constants.dart';
import 'locator.dart';

class CurrentSessionService {
  static final prefs = locator<SharedPrefServices>();
  static String? cachedUserName;
  static String? cachedUserImage;
  static DateTime? cachedUserBirthday;
  static bool isOpenFadfadaPin = false;

  static void setIsOpenFadfadaPin(bool value) {
    isOpenFadfadaPin = value;
  }

  static Future<void> getUserName() async {
    if (cachedUserName != null) {
      return;
    }
    cachedUserName = await prefs.getString(SharedPrefsConstants.userName);
  }

  static Future<void> setUserName(String userName) async {
    await prefs.saveString(SharedPrefsConstants.userName, userName);
    cachedUserName = userName;
  }

  static Future<void> setUserBirthday(DateTime birthday) async {
    await prefs.saveInteger(
      SharedPrefsConstants.userBirthday,
      birthday.millisecondsSinceEpoch,
    );
    cachedUserBirthday = birthday;
  }

  static Future<void> getUserBirthday() async {
    final millis = await prefs.getInteger(SharedPrefsConstants.userBirthday);
    if (millis == 0) {
      cachedUserBirthday = null;
      return;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    cachedUserBirthday = date;
  }


  static Future<void> getUserImage() async {
    if (cachedUserImage != null) {
      return;
    }
    cachedUserImage = await prefs.getString(SharedPrefsConstants.userImage);
  }

  static Future<void> setUserImage(String userImage) async {
    await prefs.saveString(SharedPrefsConstants.userImage, userImage);
    cachedUserImage = userImage;
  }

  static void clearSessionCache() {
    cachedUserName = null;
    cachedUserImage = null;
    cachedUserBirthday = null;
  }
}
