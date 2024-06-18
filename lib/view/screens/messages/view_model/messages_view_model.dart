import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../consts/shared_preferences_constants.dart';
import '../../../../enums/screen_state.dart';
import '../../../../enums/status.dart';
import '../../../../locator.dart';
import '../../../../models/resources.dart';
import '../../../../services/api_service.dart';
import '../../../../services/shared_pref_services.dart';
import '../model/messages_model.dart';

class MessagesViewModel extends BaseViewModel{
  List<Messages> list = [];
  String? userName;
  var apiService = locator<ApiService>();
  var prefs = locator<SharedPrefServices>();
  File? image;

  Future<void> getUserData() async {
    userName = await prefs.getString(SharedPrefsConstants.USER_NAME);
    final imagePath = await prefs.getString(SharedPrefsConstants.USER_IMAGE);
    if (imagePath.isNotEmpty) {
      image = File(imagePath);
    }
    setState(ViewState.Idle);
  }

  Future<void> getMessages() async {
    Resource<MessagesModel> resource = await apiService.getMessages();
    if(resource.status == Status.SUCCESS){
      list = resource.data!.content!;
    }
    setState(ViewState.Idle);
  }

  Future<void> shareMessage(int index) async {
    await Share.share(
        '${list[index].body} \n\n من تطبيق برطمان السعادة 💙');
  }

  void copyMessage(int index) {
    FlutterClipboard.copy(
      '${list[index].body} \n\n من تطبيق برطمان السعادة 💙',
    );
  }


}