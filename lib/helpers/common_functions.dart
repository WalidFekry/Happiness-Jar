import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vision_gallery_saver/vision_gallery_saver.dart';

class CommonFunctions {
  static ScreenshotController screenshotController = ScreenshotController();

  static Future<void> shareMessage(String? message, {bool showSignature = true}) async {
    String finalMessage = message ?? '';

    if (showSignature) {
      finalMessage += '\n\nمن تطبيق برطمان السعادة 💙';
    }

    await Share.share(finalMessage);
  }

  static void copyMessage(String? message) {
    FlutterClipboard.copy(
      '$message \n\n من تطبيق برطمان السعادة 💙',
    );
  }

  static Future<void> shareWhatsapp(String? message) async {
    String shareMessage = '$message \n\n من تطبيق برطمان السعادة 💙';
    String encodedMessage = Uri.encodeComponent(shareMessage);
    String whatsappUrl = "https://api.whatsapp.com/send?text=$encodedMessage";
    Uri uri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Share.share(shareMessage);
    }
  }

  static Future<void> shareFacebook(String? message) async {
    String shareMessage = '$message \n\n من تطبيق برطمان السعادة 💙';
    String encodedMessage = Uri.encodeComponent(shareMessage);
    String facebookUrl =
        "https://www.facebook.com/sharer/sharer.php?u=$encodedMessage";
    Uri uri = Uri.parse(facebookUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Share.share(shareMessage);
    }
  }

  static Future<void> sharePhoto(String? message,Widget widget) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    screenshotController
        .captureFromWidget(widget)
        .then((image) async {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        final xFile = XFile(imagePath.path);
        await Share.shareXFiles(
          [xFile],
          subject: 'من تطبيق برطمان السعادة 💙',
          text: message,
        );
      } catch (e) {
        if (kDebugMode) {
          print('خطأ أثناء حفظ أو مشاركة الصورة: $e');
        }
      }
    });
  }

  static Future<void> saveToGallery(BuildContext context, Widget widget) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    screenshotController
        .captureFromWidget(widget)
        .then((image) async {
      try {
        final result = await VisionGallerySaver.saveImage(image);
        if (result['isSuccess']) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
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
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
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
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('خطأ أثناء حفظ أو مشاركة الصورة: $e');
        }
      }
    });
  }

  static String formatNumberArabic(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      double result = number / 1000;
      String formatted =
      result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1);
      return '$formatted ألف';
    } else {
      double result = number / 1000000;
      String formatted =
      result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1);
      return '$formatted مليون';
    }
  }
}
