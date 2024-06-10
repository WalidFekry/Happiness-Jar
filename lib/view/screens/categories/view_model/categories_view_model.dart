import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/enums/status.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/models/resources.dart';
import 'package:happiness_jar/services/api_service.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_content_model.dart';

import '../../../../enums/screen_state.dart';
import '../../../../routs/routs_names.dart';
import '../../../../services/navigation_service.dart';
import '../model/messages_categories_model.dart';

class CategoriesViewModel extends BaseViewModel{

  List<MessagesCategories> list = [];
  List<MessagesCategories> content = [];
  bool isDone = true;
  var apiService = locator<ApiService>();
  var appDatabase = locator<AppDatabase>();

  Future<void> getCategories() async {
  list = await appDatabase.getMessagesCategories();
  if(list.isEmpty){
    Resource<MessagesCategoriesModel> resource = await apiService.getMessagesCategories();
    if(resource.status == Status.SUCCESS){
      await appDatabase.insertData(resource);
      list = await appDatabase.getMessagesCategories();
      isDone = true;
    }else{
      isDone = false;
    }
  }
  setState(ViewState.Idle);
  }

  Future<void> getContent(int? categorie) async {
    content = await appDatabase.getMessagesContent(categorie);
    if(content.isEmpty){
      Resource<MessagesContentModel> resource = await apiService.getMessagesContent();
      if(resource.status == Status.SUCCESS){
        await appDatabase.insertData(resource);
        list = await appDatabase.getMessagesContent(categorie);
        isDone = true;
      }else{
        isDone = false;
      }
    }
    setState(ViewState.Idle);
  }

  void navigateToContent(int index) {
    var navigate = locator<NavigationService>();
    navigate.navigateTo(RouteName.MESSAGES_CATEGORIES_CONTENT,
        arguments: list[index],
        queryParams: {'index': index.toString()});
  }

}