import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/notifications/widgets/notification_screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../db/app_database.dart';
import '../../../../enums/screen_state.dart';
import '../../../../enums/status.dart';
import '../../../../locator.dart';
import '../../../../models/resources.dart';
import '../../../../services/api_service.dart';
import '../../../../services/navigation_service.dart';
import '../model/notification_model.dart';

class NotificationsViewModel extends BaseViewModel {
  List<MessagesNotifications> list = [];
  final apiService = locator<ApiService>();
  final appDatabase = locator<AppDatabase>();
  bool isDone = true;
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> getContent() async {
    // if(list.isNotEmpty){
    //   return;
    // }
    Resource<NotificationsModel> resource =
        await apiService.getMessagesNotificationContent();
    if (resource.status == Status.SUCCESS) {
      isDone = true;
      list = resource.data!.content!;
      await appDatabase.insertData(resource);
    } else {
      list = await appDatabase.getMessagesNotificationContent();
      if (list.isEmpty) {
        isDone = false;
      }
    }
    setState(ViewState.Idle);
  }

  Future<void> shareMessage(int index) async {
    await Share.share('${list[index].text} \n\n من تطبيق برطمان السعادة 💙');
  }

  void copyMessage(int index) {
    FlutterClipboard.copy(
      '${list[index].text} \n\n من تطبيق برطمان السعادة 💙',
    );
  }

  Future<void> saveFavoriteMessage(int index) async {
    DateTime now = DateTime.now();
    String createdAt = "${now.year}-${now.month}-${now.day}";
    await appDatabase.saveFavoriteMessage(list[index].text, createdAt);
    list[index].isFavourite = !list[index].isFavourite;
    setState(ViewState.Idle);
  }

  void goBack() {
    locator<NavigationService>().goBack();
  }

  Future<void> shareWhatsapp(int index) async {
    String message = '${list[index].text} \n\n من تطبيق برطمان السعادة 💙';
    String encodedMessage = Uri.encodeComponent(message);
    String whatsappUrl = "whatsapp://send?text=$encodedMessage";

    Uri uri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Share.share(message);
    }
  }

  Future<void> shareFacebook(int index) async {
    String message = '${list[index].text} \n\n من تطبيق برطمان السعادة 💙';
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
        .captureFromWidget(NotificationScreenshot(list[index]))
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
        .captureFromWidget(NotificationScreenshot(list[index]))
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
            text: list[index].text,
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
}
