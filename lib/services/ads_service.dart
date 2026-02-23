import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../constants/ads_manager.dart';
import '../constants/shared_preferences_constants.dart';
import '../view/screens/home/widgets/greeting_dialog.dart';
import 'navigation_service.dart';

class AdsService {
  InterstitialAd? interstitialAd;
  AppOpenAd? openAd;
  RewardedAd? rewardedAd;
  final prefs = locator<SharedPrefServices>();
  final greetingDialog = locator<GreetingDialog>();
  final int oneHourInMillis = 3600000;

  // Load and show an interstitial ad
  Future<void> showInterstitialAd() async {
    int adDisplayCount =
        await prefs.getInteger(SharedPrefsConstants.interstitialAdDisplayCount);
    int lastAdDisplayTime = await prefs
        .getInteger(SharedPrefsConstants.interstitialLastAdDisplayTime);
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    // Reset the ad display count if more than one hour has passed since the last ad display
    if (currentTime - lastAdDisplayTime > oneHourInMillis) {
      adDisplayCount = 0;
    }
    if (adDisplayCount < 2) {
      InterstitialAd.load(
          adUnitId: AdsManager.interstitialAdUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            // Called when an ad is successfully received.
            onAdLoaded: (ad) {
              interstitialAd = ad;
              if (interstitialAd != null) {
                interstitialAd?.show();
              }
              // Increment the ad display count and update the last ad display time
              adDisplayCount++;
              prefs.saveInteger(SharedPrefsConstants.interstitialAdDisplayCount,
                  adDisplayCount);
              prefs.saveInteger(
                  SharedPrefsConstants.interstitialLastAdDisplayTime,
                  currentTime);
            }, // Called when an ad request failed.
            onAdFailedToLoad: (LoadAdError error) {
              debugPrint('InterstitialAd failed to load: $error');
              interstitialAd = null;
            },
          ));
    } else {
      debugPrint(
          'InterstitialAd limit reached: only 2 ads per hour are allowed.');
    }
  }

  // Load and show an app open ad
  Future<void> showOpenAd(BuildContext context) async {
    int adDisplayCount =
        await prefs.getInteger(SharedPrefsConstants.openAdDisplayCount);
    int lastAdDisplayTime =
        await prefs.getInteger(SharedPrefsConstants.openLastAdDisplayTime);
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    // Reset the ad display count if more than one hour has passed since the last ad display
    if (currentTime - lastAdDisplayTime > oneHourInMillis) {
      adDisplayCount = 0;
    }
    if (adDisplayCount < 1) {
      await AppOpenAd.load(
          adUnitId: AdsManager.openAdUnitId,
          request: const AdRequest(),
          adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
            openAd = ad;
            if (openAd != null) {
              openAd?.show();
            }
            // Increment the ad display count and update the last ad display time
            adDisplayCount++;
            prefs.saveInteger(
                SharedPrefsConstants.openAdDisplayCount, adDisplayCount);
            prefs.saveInteger(
                SharedPrefsConstants.openLastAdDisplayTime, currentTime);
          }, onAdFailedToLoad: (error) {
            greetingDialog.showGreeting(context);
            debugPrint('Ad failed to load $error');
          }));
    } else {
      greetingDialog.showGreeting(context);
      debugPrint('OpenAd limit reached: only 1 ads per hour are allowed.');
    }
  }

  // Load a rewarded ad
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdsManager.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          rewardedAd = null;
        },
      ),
    );
  }

  // Show a rewarded ad
  void showRewardedAd(BuildContext context) {
    if (rewardedAd != null) {
      rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) =>
            debugPrint('$ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          debugPrint('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
        },
        onAdImpression: (RewardedAd ad) =>
            debugPrint('$ad impression occurred.'),
      );
      rewardedAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        debugPrint('$ad with reward $rewardItem');
        setRewardedAdItem(context);
      });
    } else {
      locator<NavigationService>().goBack();
      loadRewardedAd();
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          backgroundColor: Theme.of(context).cardColor,
          message:
              "لا توجد إعلانات متوفرة للعرض حاليا، الرجاء المحاولة مرة أخرى.",
        ),
      );
    }
  }

  // Handle rewarded ad item
  void setRewardedAdItem(BuildContext context) {
    prefs.saveString(SharedPrefsConstants.lastGetMessagesTime, "");
    locator<NavigationService>().navigateToAndClearStack(RouteName.HOME);
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        backgroundColor: Theme.of(context).iconTheme.color!,
        message: "تم الحصول على رسائل جديدة من البرطمان.",
      ),
    );
  }

  // Dispose ads
  void dispose() {
    if (interstitialAd != null) {
      interstitialAd?.dispose();
      interstitialAd = null;
    }
    if (openAd != null) {
      openAd?.dispose();
      openAd = null;
    }
    if (rewardedAd != null) {
      rewardedAd?.dispose();
      rewardedAd = null;
    }
  }
}
