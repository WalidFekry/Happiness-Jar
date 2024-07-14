import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/enums/status.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/models/resources.dart';
import 'package:happiness_jar/services/api_service.dart';
import 'package:happiness_jar/view/screens/base_view_model.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_content_model.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/ads_manager.dart';
import '../../../../enums/screen_state.dart';
import '../../../../routs/routs_names.dart';
import '../../../../services/navigation_service.dart';
import '../model/messages_categories_model.dart';
import '../widgets/categories_screenshot.dart';

class CategoriesViewModel extends BaseViewModel{

  List<MessagesCategories> list = [];
  List<MessagesContent> content = [];
  final apiService = locator<ApiService>();
  final appDatabase = locator<AppDatabase>();
  bool isDone = true;
  bool isDoneContent = true;
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  bool isBottomBannerAdLoaded = false;
  ScreenshotController screenshotController = ScreenshotController();


  Future<void> getCategories() async {
  if(list.isNotEmpty){
    return;
  }
  list = await appDatabase.getMessagesCategories();
  if(list.isEmpty){
    Resource<MessagesCategoriesModel> resource = await apiService.getMessagesCategories();
    if(resource.status == Status.SUCCESS){
      isDone = true;
      await appDatabase.insertData(resource);
      list = await appDatabase.getMessagesCategories();
    }else{
        isDone = false;
    }
  }
  setState(ViewState.Idle);
  }

  Future<void> getContent(int? categorie) async {
    content.clear();
    content = await appDatabase.getMessagesContent(categorie);
    if(content.isEmpty){
      Resource<MessagesContentModel> resource = await apiService.getMessagesContent();
      if(resource.status == Status.SUCCESS){
        isDoneContent = true;
        await appDatabase.insertData(resource);
        content = await appDatabase.getMessagesContent(categorie);
      }else{
        isDoneContent = false;
      }
    }
    setState(ViewState.Idle);
  }

  Future<void> saveFavoriteMessage(int index) async {
    DateTime now = DateTime.now();
    String createdAt = "${now.year}-${now.month}-${now.day}";
    await appDatabase.saveFavoriteMessage(content[index].title,createdAt);
    content[index].isFavourite = !content[index].isFavourite;
    setState(ViewState.Idle);
  }

  void navigateToContent(int index) {
    var navigate = locator<NavigationService>();
    navigate.navigateTo(RouteName.MESSAGES_CATEGORIES_CONTENT,
        arguments: list[index],
        queryParams: {'index': index.toString()});
  }

  Future<void> shareMessage(int index) async {
    await Share.share(
        '${content[index].title} \n\n من تطبيق برطمان السعادة 💙');
  }

  void copyMessage(int index) {
    FlutterClipboard.copy(
      '${content[index].title} \n\n من تطبيق برطمان السعادة 💙',
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
        .captureFromWidget(CategoriesScreenshot(content[index],list[index].title))
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
        .captureFromWidget(CategoriesScreenshot(content[index],list[index].title))
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
            text: content[index].title,
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

  void showBannerAd() {
    BannerAd(
      adUnitId: AdsManager.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
            bannerAd = ad as BannerAd;
            isBottomBannerAdLoaded = true;
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    setState(ViewState.Idle);
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    interstitialAd?.dispose();
    super.dispose();
  }

  void showBinyAd() {
    InterstitialAd.load(
        adUnitId: AdsManager.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            interstitialAd = ad;
            if(interstitialAd != null){
              interstitialAd?.show();
            }
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
            interstitialAd = null;
          },
        ));
  }

}