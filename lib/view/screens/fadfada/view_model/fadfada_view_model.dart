import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/fadfada/model/fadfada_model.dart';

import '../../../../db/app_database.dart';
import '../../../../enums/screen_state.dart';
import '../../../../routs/routs_names.dart';
import '../../../../services/locator.dart';
import '../../../../services/navigation_service.dart';
import '../../base_view_model.dart';

class FadfadaViewModel extends BaseViewModel {
  String selectedCategory = "مشاعر إيجابية 😊";
  final TextEditingController controller = TextEditingController();
  final int maxChars = 5000;
  final appDatabase = locator<AppDatabase>();
  final navigationService = locator<NavigationService>();
  List<FadfadaModel> fadfadaList = [];

  void getFadfadaList() async {
    fadfadaList = await appDatabase.getFadfadaList();
    setState(ViewState.Idle);
  }

  String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate =
        DateFormat('EEEE، d MMMM yyyy - hh:mm a', 'ar').format(dateTime);
    return formattedDate;
  }

  Future<void> addFadfada() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    FadfadaModel fadfadaItem = FadfadaModel(
      category: selectedCategory,
      text: controller.text,
      createdAt: timestamp,
    );
    await appDatabase.insert(fadfadaItem);
    controller.clear();
    getFadfadaList();
    navigationService.goBack();
  }

  Future<void> deleteFadfada(int id) async {
    int deletedRows = await appDatabase.deleteById(id, "fadfada");
    if (deletedRows > 0) {
      getFadfadaList();
    }
  }

  void navigateToContent(int index) {
    navigationService.navigateTo(RouteName.VIEW_FADFADA_SCREEN,
        arguments: fadfadaList[index]);
  }

  void updateFadfada(int? id, int? createdAt) {
    FadfadaModel fadfadaItem = FadfadaModel(
        id: id,
        category: selectedCategory,
        text: controller.text,
        createdAt: createdAt);
    appDatabase.insert(fadfadaItem);
    getFadfadaList();
    navigationService.goBack();
  }

  void setFadfada(FadfadaModel fadfada) {
    controller.text = fadfada.text!;
    selectedCategory = fadfada.category!;
    setState(ViewState.Idle);
  }

  void navigateToEditFadfada(int index) {
    navigationService.navigateTo(RouteName.EDIT_FADFADA_SCREEN,
        arguments: fadfadaList[index]);
  }

  void clearController() {
    controller.clear();
  }
}
