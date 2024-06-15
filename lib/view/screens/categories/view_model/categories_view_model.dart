import 'package:clipboard/clipboard.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/enums/status.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/models/resources.dart';
import 'package:happiness_jar/services/api_service.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_content_model.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../enums/screen_state.dart';
import '../../../../routs/routs_names.dart';
import '../../../../services/navigation_service.dart';
import '../model/messages_categories_model.dart';

class CategoriesViewModel extends BaseViewModel{

  List<MessagesCategories> list = [];
  List<MessagesCategories> content = [];
  var apiService = locator<ApiService>();
  var appDatabase = locator<AppDatabase>();

  Future<void> getCategories() async {
  list.clear();
  list = await appDatabase.getMessagesCategories();
  if(list.isEmpty){
    Resource<MessagesCategoriesModel> resource = await apiService.getMessagesCategories();
    if(resource.status == Status.SUCCESS){
      await appDatabase.insertData(resource);
      list = await appDatabase.getMessagesCategories();
    }
  }
  setState(ViewState.Idle);
  }

  Future<void> getContent(int? categorie) async {
    content.clear();
    content = await appDatabase.getMessagesContent(categorie);
    if(content.isEmpty){
      Resource<MessagesContentModel> resource = await apiService.getMessagesContent();
      if(resource.status == Status.SUCCESS){
        await appDatabase.insertData(resource);
        content = await appDatabase.getMessagesContent(categorie);
      }
    }
    setState(ViewState.Idle);
  }

  Future<void> saveFavoriteMessage(int index) async {
    DateTime now = DateTime.now();
    String createdAt = "${now.year}-${now.month}-${now.day}";
    await appDatabase.saveFavoriteMessage(content[index].title,createdAt);
    content[index].isFavourite = !content[index].isFavourite;
    setState(ViewState.Idle);
  }

  void navigateToContent(int index) {
    var navigate = locator<NavigationService>();
    navigate.navigateTo(RouteName.MESSAGES_CATEGORIES_CONTENT,
        arguments: list[index],
        queryParams: {'index': index.toString()});
  }

  Future<void> shareMessage(int index) async {
    await Share.share(
        '${content[index].title} \n\n من تطبيق برطمان السعادة 💙');
  }

  void copyMessage(int index) {
    FlutterClipboard.copy(
      '${content[index].title} \n\n من تطبيق برطمان السعادة 💙',
    );
  }

  void goBack() {
    locator<NavigationService>().goBack();
  }

}