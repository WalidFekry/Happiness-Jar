import 'package:happiness_jar/view/screens/feelings/model/FeelingsCategoriesModel.dart';

import '../../../../db/app_database.dart';
import '../../../../enums/screen_state.dart';
import '../../../../enums/status.dart';
import '../../../../models/resources.dart';
import '../../../../services/api_service.dart';
import '../../../../services/locator.dart';
import '../../../../services/shared_pref_services.dart';
import '../../base_view_model.dart';
import '../../posts/model/posts_model.dart';
import '../model/FeelingsContentModel.dart';

class FeelingViewModel extends BaseViewModel {
  final apiService = locator<ApiService>();
  final appDatabase = locator<AppDatabase>();
  final prefs = locator<SharedPrefServices>();
  List<FeelingsCategories> listOfFeelingsCategories = [];
  List<FeelingsContent> listOfFeelingsContent = [];
  bool isDone = true;
  int? selectedFeeling = 0;

  void getListOfFeelingsCategories() async {
    listOfFeelingsCategories = await appDatabase.getFeelingsCategories();
    if (listOfFeelingsCategories.isEmpty) {
      Resource<FeelingsCategoriesModel> resource = await apiService.getFeelingsCategories();
      if (resource.status == Status.SUCCESS) {
        await appDatabase.insertData(resource);
        Resource<FeelingsContentModel> resource2 = await apiService.getFeelingsContent();
        if (resource2.status == Status.SUCCESS) {
          await appDatabase.insertData(resource2);
        }
        listOfFeelingsCategories = resource.data!.content!;
        isDone = true;
      } else {
          isDone = false;
      }
    }
    setState(ViewState.Idle);
    listOfFeelingsCategories[0].title;
  }

  void getListOfFeelingsContent(int? categorie) async {
    listOfFeelingsContent = await appDatabase.getFeelingsContent(categorie);
    if(listOfFeelingsContent.isEmpty){
      Resource<FeelingsContentModel> resource = await apiService.getFeelingsContent();
      if (resource.status == Status.SUCCESS) {
        await appDatabase.insertData(resource);
        listOfFeelingsContent = await appDatabase.getFeelingsContent(categorie);
      }
    }
    // print(listOfFeelingsContent.length);
    // print(listOfFeelingsContent[0].title);
    // print(listOfFeelingsContent[1].title);
    // print(listOfFeelingsContent[2].title);
    // print(listOfFeelingsContent[3].title);
    setState(ViewState.Idle);
  }

  void setSelectedCategory(int? id) {
    selectedFeeling = (id!-1);
  }
}
