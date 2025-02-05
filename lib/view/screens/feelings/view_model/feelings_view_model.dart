import 'package:flutter/src/widgets/framework.dart';
import 'package:happiness_jar/view/screens/feelings/model/FeelingsCategoriesModel.dart';

import '../../../../db/app_database.dart';
import '../../../../enums/screen_state.dart';
import '../../../../enums/status.dart';
import '../../../../helpers/common_functions.dart';
import '../../../../models/resources.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/api_service.dart';
import '../../../../services/locator.dart';
import '../../../../services/navigation_service.dart';
import '../../../../services/shared_pref_services.dart';
import '../../base_view_model.dart';
import '../model/FeelingsContentModel.dart';
import '../widgets/feelings_screenshot.dart';

class FeelingsViewModel extends BaseViewModel {
  final apiService = locator<ApiService>();
  final appDatabase = locator<AppDatabase>();
  final prefs = locator<SharedPrefServices>();
  final adsService = locator<AdsService>();
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

  Future<void> getListOfFeelingsContent(int? categorie) async {
    listOfFeelingsContent = await appDatabase.getFeelingsContent(categorie);
    if(listOfFeelingsContent.isEmpty){
      Resource<FeelingsContentModel> resource = await apiService.getFeelingsContent();
      if (resource.status == Status.SUCCESS) {
        await appDatabase.insertData(resource);
        listOfFeelingsContent = await appDatabase.getFeelingsContent(categorie);
      }
    }
    setState(ViewState.Idle);
  }

  void setSelectedCategory(int? id) {
    selectedFeeling = (id!-1);
  }

  void showBinyAd() {
    adsService.showInterstitialAd();
  }

  void shareMessage(int index){
    CommonFunctions.shareMessage(listOfFeelingsContent[index].body);
  }

  void copyMessage(int index) {
    CommonFunctions.copyMessage(listOfFeelingsContent[index].body);
  }

  void goBack() {
    locator<NavigationService>().goBack();
  }

  void destroyAds() {
    adsService.dispose();
  }

  void shareWhatsapp(int index) {
    CommonFunctions.shareWhatsapp(listOfFeelingsContent[index].body);
  }

  void shareFacebook(int index) {
    CommonFunctions.shareFacebook(listOfFeelingsContent[index].body);
  }

  void sharePhoto(int index) {
    CommonFunctions.sharePhoto(listOfFeelingsContent[index].body, FeelingsScreenshot(listOfFeelingsContent[index]));
  }

  void saveToGallery(int index, BuildContext context) {
    CommonFunctions.saveToGallery(context, FeelingsScreenshot(listOfFeelingsContent[index]));
  }
}
