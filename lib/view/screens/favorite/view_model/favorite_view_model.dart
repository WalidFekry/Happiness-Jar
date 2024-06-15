import 'package:clipboard/clipboard.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/favorite/model/favorite_messages_model.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../services/navigation_service.dart';

class FavoriteViewModel extends BaseViewModel {

  var appDatabase = locator<AppDatabase>();
  List<FavoriteMessagesModel> list = [];

  Future<void> getFavoriteMessages() async {
    list.clear();
    list = await appDatabase.getFavoriteMessages();
    setState(ViewState.Idle);
  }

  Future<void> deleteFavoriteMessage(int index) async {
    await appDatabase.deleteFavoriteMessage(list[index].id);
    getFavoriteMessages();
  }

  Future<void> shareMessage(int index) async {
    await Share.share(
      '${list[index].title} \n\n من تطبيق برطمان السعادة 💙');
  }

  void copyMessage(int index) {
    FlutterClipboard.copy(
      '${list[index].title} \n\n من تطبيق برطمان السعادة 💙',
    );
  }

  void goBack() {
    locator<NavigationService>().goBack();
  }

}