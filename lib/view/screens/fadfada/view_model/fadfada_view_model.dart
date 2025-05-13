import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/shared_preferences_constants.dart';
import 'package:happiness_jar/view/screens/fadfada/model/fadfada_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../db/app_database.dart';
import '../../../../enums/screen_state.dart';
import '../../../../routs/routs_names.dart';
import '../../../../services/current_session_service.dart';
import '../../../../services/locator.dart';
import '../../../../services/navigation_service.dart';
import '../../../../services/shared_pref_services.dart';
import '../../base_view_model.dart';

class FadfadaViewModel extends BaseViewModel {
  String selectedCategory = "مشاعر إيجابية 😊";
  final TextEditingController controller = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final int maxChars = 5000;
  final appDatabase = locator<AppDatabase>();
  final prefs = locator<SharedPrefServices>();
  final navigationService = locator<NavigationService>();
  List<FadfadaModel> fadfadaList = [];
  List<String> categories = [];
  List<FadfadaModel> filteredFadfadaList = [];
  String? categoryFilter;
  String sortOrder = "newest";
  final Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  final RecorderController recorderController = RecorderController();
  String? audioPath;
  bool isRecording = false;
  bool isPaused = false;
  final PlayerController player = PlayerController();
  bool isPlaying = false;
  bool isPrepared = false;
  String selectedQuestion = '';
  String errorMessage = '';

  Future<void> checkPin() async {
    final savedPin = await prefs.getString(SharedPrefsConstants.fadfadaPinCode);
    if (pinController.text == savedPin) {
      CurrentSessionService.setIsOpenFadfadaPin(true);
      navigationService.navigateToReplacement(RouteName.FADFADA_SCREEN);
    } else {
      errorMessage = 'الرقم السري غير صحيح.';
      setState(ViewState.Idle);
    }
  }

  Future<void> savePinAndAnswer() async {
    final pin = pinController.text.trim();
    final confirmPin = confirmPinController.text.trim();
    final answer = answerController.text.trim();

    if (pin.length < 4) {
      errorMessage = 'الرقم السري يجب أن يكون ٤ أرقام على الأقل.';
      setState(ViewState.Idle);
      return;
    }

    if (pin != confirmPin) {
      errorMessage = 'الرقمين غير متطابقين.';
      setState(ViewState.Idle);
      return;
    }

    if (selectedQuestion.isEmpty) {
      errorMessage = 'يرجى اختيار سؤال سري.';
      setState(ViewState.Idle);
      return;
    }

    if (answer.isEmpty) {
      errorMessage = 'يرجى إدخال إجابة السؤال السري.';
      setState(ViewState.Idle);
      return;
    }

    await prefs.saveString(SharedPrefsConstants.fadfadaPinCode, pin);
    await prefs.saveString(
        SharedPrefsConstants.fadfadaSecurityQuestion, selectedQuestion);
    await prefs.saveString(
        SharedPrefsConstants.fadfadaSecurityAnswer, answer.toLowerCase());

    navigationService.goBack();
  }

  Future<void> startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    audioPath =
        '${dir.path}/fadfada_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await recorderController.record(path: audioPath!);
    isRecording = true;
    isPaused = false;
    setState(ViewState.Idle);
  }

  Future<void> pauseRecording() async {
    await recorderController.pause();
    isPaused = true;
    setState(ViewState.Idle);
  }

  Future<void> resumeRecording() async {
    await recorderController.record();
    isPaused = false;
    setState(ViewState.Idle);
  }

  Future<void> stopRecording({bool save = true}) async {
    await recorderController.stop();
    isRecording = false;
    isPaused = false;
    if (!save && audioPath != null && File(audioPath!).existsSync()) {
      await File(audioPath!).delete();
      audioPath = null;
    }
    setState(ViewState.Idle);
  }

  Future<void> playAudio() async {
    if (audioPath == null) return;
    if (!isPrepared) {
      isPrepared = true;
      await player.preparePlayer(path: audioPath!);
      player.setFinishMode(finishMode: FinishMode.pause);
      player.onCompletion.listen((_) async {
        isPlaying = false;
        setState(ViewState.Idle);
      });
    }
    await player.startPlayer();
    isPlaying = true;
    setState(ViewState.Idle);
  }

  Future<void> pauseAudio() async {
    await player.pausePlayer();
    isPlaying = false;
    setState(ViewState.Idle);
  }

  Future<void> deleteAudio() async {
    if (audioPath != null && File(audioPath!).existsSync()) {
      await File(audioPath!).delete();
      audioPath = null;
      isPlaying = false;
      isPrepared = false;
    }
    setState(ViewState.Idle);
  }

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
      audioPath: audioPath,
      hasAudio: audioPath != null,
    );
    await appDatabase.insert(fadfadaItem);
    resetTimer();
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
        arguments: filteredFadfadaList[index]);
  }

  void updateFadfada(int? id, int? createdAt, int? oldTimeSpent) {
    stopTimer();
    FadfadaModel fadfadaItem = FadfadaModel(
        id: id,
        category: selectedCategory,
        text: controller.text,
        createdAt: createdAt,
        timeSpent: oldTimeSpent! + stopwatch.elapsed.inSeconds,
        audioPath: audioPath,
        hasAudio: audioPath != null);
    appDatabase.insert(fadfadaItem);
    resetTimer();
    navigationService.goBack();
  }

  void setFadfada(FadfadaModel fadfada) {
    controller.text = fadfada.text!;
    selectedCategory = fadfada.category!;
    audioPath = fadfada.audioPath;
    setState(ViewState.Idle);
  }

  void navigateToEditFadfada(int index) {
    navigationService
        .navigateTo(RouteName.EDIT_FADFADA_SCREEN,
            arguments: filteredFadfadaList[index])
        .then((_) => getFadfadaList());
  }

  void navigateToAddFadfada() {
    navigationService
        .navigateTo(RouteName.ADD_FADFADA_SCREEN)
        .then((_) => getFadfadaList());
  }

  void navigateToResetFadfadaPin() {
    navigationService.navigateTo(RouteName.FORGOT_FADFADA_PIN_SCREEN);
  }

  void navigateToSetFadfadaPin() {
    navigationService.navigateTo(RouteName.SET_FADFADA_PIN_SCREEN);
  }

  void clearController() {
    controller.clear();
  }

  void togglePinFadfada(int id) {
    int index = filteredFadfadaList.indexWhere((fadfada) => fadfada.id == id);
    if (index != -1) {
      filteredFadfadaList[index].isPinned =
          !filteredFadfadaList[index].isPinned;
      appDatabase.insert(filteredFadfadaList[index]);
      filteredFadfadaList
          .sort((a, b) => (b.isPinned ? 1 : 0).compareTo(a.isPinned ? 1 : 0));
      setState(ViewState.Idle);
    }
  }

  void disposeController() {
    controller.dispose();
    recorderController.dispose();
    player.dispose();
    stopwatch.stop();
  }

  Future<void> checkPinBeforeAccess() async {
    if (CurrentSessionService.isOpenFadfadaPin) return;
    final storedPin =
        await prefs.getString(SharedPrefsConstants.fadfadaPinCode);
    if (storedPin.isNotEmpty) {
      navigationService.navigateToReplacement(RouteName.LOGIN_FADFADA_PIN_SCREEN);
    }
  }

  Future<void> verifyAnswer() async {
    final savedQuestion =
        await prefs.getString(SharedPrefsConstants.fadfadaSecurityQuestion);
    final savedAnswer =
        await prefs.getString(SharedPrefsConstants.fadfadaSecurityAnswer);

    if (selectedQuestion == savedQuestion &&
        answerController.text.trim().toLowerCase() ==
            savedAnswer.trim().toLowerCase()) {
      navigationService.navigateToReplacement(RouteName.SET_FADFADA_PIN_SCREEN);
    } else {
      errorMessage = 'إجابة غير صحيحة';
      setState(ViewState.Idle);
    }
  }
}
