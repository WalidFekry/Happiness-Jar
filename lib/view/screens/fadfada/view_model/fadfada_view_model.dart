import 'dart:async';

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
  List<String> categories = [];
  List<FadfadaModel> filteredFadfadaList = [];
  String? categoryFilter;
  String sortOrder = "newest";
  final Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  void startTimer() {
    if (stopwatch.isRunning) {
      resetTimer();
      return;
    }
    stopwatch.start();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      stopwatch.elapsed.inSeconds;
      setState(ViewState.Idle);
    });
  }

  void stopTimer() {
    stopwatch.stop();
    timer?.cancel();
  }

  void resetTimer() {
    stopwatch.reset();
  }

  void getFadfadaList() async {
    fadfadaList = await appDatabase.getFadfadaList();
    fadfadaList
        .sort((a, b) => (b.isPinned ? 1 : 0).compareTo(a.isPinned ? 1 : 0));
    categories =
        fadfadaList.map((fadfada) => fadfada.category!).toSet().toList();
    categories.insert(0, "كل الفئات");
    filteredFadfadaList =
        categoryFilter == null || categoryFilter == "كل الفئات"
            ? fadfadaList
            : fadfadaList
                .where((fadfada) => fadfada.category == categoryFilter)
                .toList();
    setState(ViewState.Idle);
  }

  void sortFadfadaList() {
    if (sortOrder == "newest") {
      filteredFadfadaList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    } else {
      filteredFadfadaList.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    }

    setState(ViewState.Idle);
  }

  void setSortOrder(String order) {
    sortOrder = order;
    sortFadfadaList();
  }

  void setSelectedCategory(String category) {
    categoryFilter = category;
    filteredFadfadaList =
        categoryFilter == null || categoryFilter == "كل الفئات"
            ? fadfadaList
            : fadfadaList
                .where((fadfada) => fadfada.category == categoryFilter)
                .toList();
    setState(ViewState.Idle);
  }

  Future<void> addFadfada() async {
    stopTimer();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    FadfadaModel fadfadaItem = FadfadaModel(
      category: selectedCategory,
      text: controller.text,
      createdAt: timestamp,
      timeSpent: stopwatch.elapsed.inSeconds,
    );
    await appDatabase.insert(fadfadaItem);
    resetTimer();
    clearController();
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

  void updateFadfada(int? id, int? createdAt, int? oldTimeSpent) {
    stopTimer();
    FadfadaModel fadfadaItem = FadfadaModel(
        id: id,
        category: selectedCategory,
        text: controller.text,
        createdAt: createdAt,
        timeSpent: oldTimeSpent! + stopwatch.elapsed.inSeconds);
    appDatabase.insert(fadfadaItem);
    resetTimer();
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

  void togglePinFadfada(int id) {
    int index = fadfadaList.indexWhere((fadfada) => fadfada.id == id);
    if (index != -1) {
      fadfadaList[index].isPinned = !fadfadaList[index].isPinned;
      appDatabase.insert(fadfadaList[index]);
      fadfadaList
          .sort((a, b) => (b.isPinned ? 1 : 0).compareTo(a.isPinned ? 1 : 0));
      setState(ViewState.Idle);
    }
  }
}
