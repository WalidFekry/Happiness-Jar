import 'package:clipboard/clipboard.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../db/app_database.dart';
import '../../../../enums/screen_state.dart';
import '../../../../enums/status.dart';
import '../../../../locator.dart';
import '../../../../models/resources.dart';
import '../../../../services/api_service.dart';
import '../../../../services/navigation_service.dart';
import '../../categories/model/messages_content_model.dart';
import '../model/notification_model.dart';

class NotificationsViewModel extends BaseViewModel{
  List<MessagesNotifications> list = [];
  var apiService = locator<ApiService>();
  var appDatabase = locator<AppDatabase>();
  bool isDone = true;


  Future<void> getContent() async {
    Resource<NotificationsModel> resource = await apiService.getMessagesNotificationContent();
    if(resource.status == Status.SUCCESS){
      isDone = true;
      list = resource.data!.content!;
      await appDatabase.insertData(resource);
    }else{
      list = await appDatabase.getMessagesNotificationContent();
      if(list.isEmpty){
        isDone = false;
      }
    }
    setState(ViewState.Idle);
  }

  Future<void> shareMessage(int index) async {
    await Share.share(
        '${list[index].text} \n\n من تطبيق برطمان السعادة 💙');
  }

  void copyMessage(int index) {
    FlutterClipboard.copy(
      '${list[index].text} \n\n من تطبيق برطمان السعادة 💙',
    );
  }

  Future<void> saveFavoriteMessage(int index) async {
    DateTime now = DateTime.now();
    String createdAt = "${now.year}-${now.month}-${now.day}";
    await appDatabase.saveFavoriteMessage(list[index].text,createdAt);
    list[index].isFavourite = !list[index].isFavourite;
    setState(ViewState.Idle);
  }

  void goBack() {
    locator<NavigationService>().goBack();
  }

}