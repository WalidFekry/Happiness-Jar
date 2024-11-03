import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/favorite/model/favorite_messages_model.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../helpers/common_functions.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/navigation_service.dart';
import '../widgets/favorite_screenshot.dart';

class FavoriteViewModel extends BaseViewModel {

  final appDatabase = locator<AppDatabase>();
  List<FavoriteMessagesModel> list = [];
  ScreenshotController screenshotController = ScreenshotController();
  final adsService = locator<AdsService>();

  Future<void> getFavoriteMessages() async {
    list = await appDatabase.getFavoriteMessages();
    setState(ViewState.Idle);
  }

  Future<void> deleteFavoriteMessage(int index) async {
    await appDatabase.deleteFavoriteMessage(list[index].id);
    getFavoriteMessages();
  }

  void shareMessage(int index) {
    CommonFunctions.shareMessage(list[index].title);
  }

  void copyMessage(int index) {
    CommonFunctions.copyMessage(list[index].title);
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
        .captureFromWidget(FavoriteScreenshot(list[index]))
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
        .captureFromWidget(FavoriteScreenshot(list[index]))
        .then((image) async {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        final xFile = XFile(imagePath.path);
        await Share.shareXFiles(
          [xFile],
          subject: 'من تطبيق برطمان السعادة 💙',
          text: list[index].title,
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