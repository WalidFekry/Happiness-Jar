import 'package:clipboard/clipboard.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/favorite/model/favorite_messages_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/navigation_service.dart';

class FavoriteViewModel extends BaseViewModel {

  final appDatabase = locator<AppDatabase>();
  List<FavoriteMessagesModel> list = [];

  Future<void> getFavoriteMessages() async {
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

  Future<void> shareWhatsapp(int index) async {
    String message = '${list[index].title} \n\n من تطبيق برطمان السعادة 💙';
    String encodedMessage = Uri.encodeComponent(message);
    String whatsappUrl = "whatsapp://send?text=$encodedMessage";

    Uri uri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Share.share(message);
    }
  }

  Future<void> shareFacebook(int index) async {
    String message = '${list[index].title} \n\n من تطبيق برطمان السعادة 💙';
    String encodedMessage = Uri.encodeComponent(message);
    String facebookUrl = "https://www.facebook.com/sharer/sharer.php?u=$encodedMessage";
    Uri uri = Uri.parse(facebookUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Share.share(message);
    }
  }

}