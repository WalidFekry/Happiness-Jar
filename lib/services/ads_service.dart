import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants/ads_manager.dart';

class AdsService {
  InterstitialAd? interstitialAd;
  AppOpenAd? openAd;

  void showInterstitialAd() {
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
          }, // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
            interstitialAd = null;
          },
        ));
  }

  Future<void> showOpenAd() async {
    await AppOpenAd.load(
        adUnitId: AdsManager.openAdUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
          openAd = ad;
          openAd!.show();
        }, onAdFailedToLoad: (error) {
          debugPrint('Ad failed to load $error');
        }));
  }
}
