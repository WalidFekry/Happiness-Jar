import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/favorite/model/favorite_messages_model.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/ads_manager.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/navigation_service.dart';
import '../widgets/favorite_screenshot.dart';

class FavoriteViewModel extends BaseViewModel {

  final appDatabase = locator<AppDatabase>();
  List<FavoriteMessagesModel> list = [];
  InterstitialAd? interstitialAd;
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
    String whatsappUrl = "https://api.whatsapp.com/send?text=$encodedMessage";
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
    String facebookUrl =
        "https://www.facebook.com/sharer/sharer.php?u=$encodedMessage";
    Uri uri = Uri.parse(facebookUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Share.share(message);
    }
  }

  Future<void> saveToGallery(int index, BuildContext context) async {
    screenshotController
        .captureFromWidget(FavoriteScreenshot(list[index]))
        .then((image) async {
      if (image != null) {
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
    });
  }

  Future<void> sharePhoto(int index, BuildContext context) async {
    screenshotController
        .captureFromWidget(FavoriteScreenshot(list[index]))
        .then((image) async {
      if (image != null) {
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
      } else {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            backgroundColor: Theme.of(context).cardColor,
            message: "حدث خطأ أثناء مشاركة الصورة",
            icon: Icon(
              Icons.share,
              color: Theme.of(context).iconTheme.color,
              size: 50,
            ),
          ),
        );
      }
    });
  }

  void showBinyAd() {
    adsService.showInterstitialAd();
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

}