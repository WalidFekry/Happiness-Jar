import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/enums/status.dart';
import 'package:happiness_jar/models/resources.dart';
import 'package:happiness_jar/services/api_service.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_content_model.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/shared_preferences_constants.dart';
import '../../../../enums/screen_state.dart';
import '../../../../helpers/common_functions.dart';
import '../../../../routs/routs_names.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/navigation_service.dart';
import '../../../../services/shared_pref_services.dart';
import '../model/messages_categories_model.dart';
import '../widgets/categories_screenshot.dart';

class CategoriesViewModel extends BaseViewModel {
  List<MessagesCategories> list = [];
  List<MessagesContent> content = [];
  List<String> favoriteIds = [];
  final apiService = locator<ApiService>();
  final appDatabase = locator<AppDatabase>();
  final prefs = locator<SharedPrefServices>();
  bool isDone = true;
  bool isDoneContent = true;
  ScreenshotController screenshotController = ScreenshotController();
  final adsService = locator<AdsService>();

  Future<void> getCategories() async {
    if (list.isNotEmpty) {
      return;
    }
    list = await appDatabase.getMessagesCategories();
    if (list.isEmpty) {
      Resource<MessagesCategoriesModel> resource =
          await apiService.getMessagesCategories();
      if (resource.status == Status.SUCCESS) {
        isDone = true;
        await appDatabase.insertData(resource);
        list = await appDatabase.getMessagesCategories();
      } else {
        isDone = false;
      }
    }
    setState(ViewState.Idle);
  }

  Future<void> getContent(int? categorie) async {
    content.clear();
    content = await appDatabase.getMessagesContent(categorie);
    favoriteIds =
        await prefs.getStringList(SharedPrefsConstants.categoryFavoriteIds);
    if (content.isEmpty) {
      Resource<MessagesContentModel> resource =
          await apiService.getMessagesContent();
      if (resource.status == Status.SUCCESS) {
        isDoneContent = true;
        await appDatabase.insertData(resource);
        content = await appDatabase.getMessagesContent(categorie);
      } else {
        isDoneContent = false;
      }
    }
    for (var message in content) {
      message.isFavourite = favoriteIds.contains(message.id.toString());
    }
    setState(ViewState.Idle);
  }

  Future<void> saveFavoriteMessage(int index) async {
    DateTime now = DateTime.now();
    String createdAt = "${now.year}-${now.month}-${now.day}";
    await appDatabase.saveFavoriteMessage(content[index].title, createdAt);
    favoriteIds =
        await prefs.getStringList(SharedPrefsConstants.categoryFavoriteIds);
    favoriteIds.add(content[index].id.toString());
    await prefs.saveStringList(
        SharedPrefsConstants.categoryFavoriteIds, favoriteIds);
    content[index].isFavourite = !content[index].isFavourite;
    setState(ViewState.Idle);
  }

  Future<void> removeFavoriteMessage(int index) async {
    await appDatabase.deleteFavoriteMessageByText(content[index].title!);
    favoriteIds =
        await prefs.getStringList(SharedPrefsConstants.categoryFavoriteIds);
    favoriteIds.remove(content[index].id.toString());
    await prefs.saveStringList(
        SharedPrefsConstants.categoryFavoriteIds, favoriteIds);
    content[index].isFavourite = !content[index].isFavourite;
    setState(ViewState.Idle);
  }

  void navigateToContent(int index) {
    var navigate = locator<NavigationService>();
    navigate.navigateTo(RouteName.MESSAGES_CATEGORIES_CONTENT,
        arguments: list[index], queryParams: {'index': index.toString()});
  }

  void shareMessage(int index) {
    CommonFunctions.shareMessage(content[index].title);
  }

  void copyMessage(int index) {
    CommonFunctions.copyMessage(content[index].title);
  }

  void goBack() {
    locator<NavigationService>().goBack();
  }

  void shareWhatsapp(int index) {
    CommonFunctions.shareWhatsapp(list[index].title);
  }

  void shareFacebook(int index) {
    CommonFunctions.shareFacebook(list[index].title);
  }

  Future<void> saveToGallery(int index, BuildContext context) async {
    screenshotController
        .captureFromWidget(
            CategoriesScreenshot(content[index], list[index].title))
        .then((image) async {
      try {
        final result = await ImageGallerySaver.saveImage(image);
        if (result['isSuccess']) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              backgroundColor: Theme.of(context).iconTheme.color!,
              message: "تم الحفظ كصورة بنجاح",
              icon: Icon(
                Icons.download,
                color: Theme.of(context).cardColor,
                size: 50,
              ),
            ),
          );
        } else {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              backgroundColor: Theme.of(context).cardColor,
              message: "حدث خطأ أثناء حفظ الصورة",
              icon: Icon(
                Icons.download,
                color: Theme.of(context).iconTheme.color,
                size: 50,
              ),
            ),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('خطأ أثناء حفظ أو مشاركة الصورة: $e');
        }
      }
    });
  }

  Future<void> sharePhoto(int index, BuildContext context) async {
    screenshotController
        .captureFromWidget(
            CategoriesScreenshot(content[index], list[index].title))
        .then((image) async {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        final xFile = XFile(imagePath.path);
        await Share.shareXFiles(
          [xFile],
          subject: 'من تطبيق برطمان السعادة 💙',
          text: content[index].title,
        );
      } catch (e) {
        if (kDebugMode) {
          print('خطأ أثناء حفظ أو مشاركة الصورة: $e');
        }
      }
    });
  }

  void destroy() {
    adsService.dispose();
  }

  void showBinyAd() {
    adsService.showInterstitialAd();
  }
}
