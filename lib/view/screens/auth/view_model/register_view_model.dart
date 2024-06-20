import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:happiness_jar/consts/shared_preferences_constants.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../routs/routs_names.dart';
import '../../../../services/navigation_service.dart';

class RegisterViewModel extends BaseViewModel {

  var prefs = locator<SharedPrefServices>();
  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? image;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
        image = File(pickedFile.path);
    }
    setState(ViewState.Idle);
  }

  Future<void> saveData() async {
    await prefs.saveString(SharedPrefsConstants.USER_NAME, nameController.text.trim());
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      const fileName = 'profile_image.png';
      final File localImage = await image!.copy('$path/$fileName');
      await prefs.saveString(SharedPrefsConstants.USER_IMAGE, localImage.path);
    }
    await prefs.saveBoolean(SharedPrefsConstants.IS_LOGIN, true);
    locator<NavigationService>().navigateToAndClearStack(RouteName.HOME);
  }

}