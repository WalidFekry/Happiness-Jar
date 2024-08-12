import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/enums/screen_state.dart';
import 'package:happiness_jar/view/screens/posts/widgets/post_screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/shared_preferences_constants.dart';
import '../../../../db/app_database.dart';
import '../../../../enums/status.dart';
import '../../../../models/resources.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/api_service.dart';
import '../../../../services/locator.dart';
import '../../../../services/navigation_service.dart';
import '../../../../services/shared_pref_services.dart';
import '../../base_view_model.dart';
import '../model/posts_model.dart';

class PostsViewModel extends BaseViewModel {
 final adsService = locator<AdsService>();
 final apiService = locator<ApiService>();
 final appDatabase = locator<AppDatabase>();
 final prefs = locator<SharedPrefServices>();
 List<PostItem> list = [];
 List<String> favoriteIds = [];
 bool isDone = true;
 ScreenshotController screenshotController = ScreenshotController();

 Future<void> getPosts() async {
   if (list.isNotEmpty) {
     return;
   }
   Resource<PostsModel> resource =
   await apiService.getPosts();
   favoriteIds = await prefs.getStringList(SharedPrefsConstants.postsFavoriteIds);
   if (resource.status == Status.SUCCESS) {
     isDone = true;
     list = resource.data!.content!;
     for (var message in list){
       message.isFavourite = favoriteIds.contains(message.id.toString());
     }
   } else {
     // list = await appDatabase.getMessagesNotificationContent();
     // for (var message in list){
     //   message.isFavourite = favoriteIds.contains(message.id.toString());
     // }
     // if (list.isEmpty) {
     //   isDone = false;
     // }
   }
   setState(ViewState.Idle);
 }

 void goBack() {
   locator<NavigationService>().goBack();
 }

 Future<void> shareMessage(int index) async {
   await Share.share(
       '${list[index].text} \n\n من تطبيق برطمان السعادة 💙');
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
   favoriteIds = await prefs.getStringList(SharedPrefsConstants.postsFavoriteIds);
   favoriteIds.add(list[index].id.toString());
   await prefs.saveStringList(SharedPrefsConstants.postsFavoriteIds, favoriteIds);
   list[index].isFavourite = !list[index].isFavourite;
   setState(ViewState.Idle);
 }

 Future<void> removeFavoriteMessage(int index) async {
   favoriteIds = await prefs.getStringList(SharedPrefsConstants.postsFavoriteIds);
   favoriteIds.remove(list[index].id.toString());
   await prefs.saveStringList(SharedPrefsConstants.postsFavoriteIds, favoriteIds);
   list[index].isFavourite = !list[index].isFavourite;
   setState(ViewState.Idle);
 }

 Future<void> shareWhatsapp(int index) async {
   String message = '${list[index].text} \n\n من تطبيق برطمان السعادة 💙';
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
       .captureFromWidget(PostScreenshot(list[index]))
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
       .captureFromWidget(PostScreenshot(list[index]))
       .then((image) async {
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
   });
 }

 void showBinyAd() {
   adsService.showInterstitialAd();
 }
}