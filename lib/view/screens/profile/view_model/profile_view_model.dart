import 'dart:io';

import 'package:happiness_jar/consts/shared_preferences_constants.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';

class ProfileViewModel extends BaseViewModel {

  var prefs = locator<SharedPrefServices>();
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

}