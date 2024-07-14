import 'dart:io';

class AdsManager {

  static bool testAds = true;

  static String get bannerAdUnitId {
    if (!testAds) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3274459976571317/3287724576';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3274459976571317/4943752917';
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    } else {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
  }

  static String get interstitialAdUnitId {
    if (!testAds) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3274459976571317/9240845011";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3274459976571317/1322721032";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
  }

  static String get rewardedAdUnitId {
    if (!testAds) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3274459976571317/7976325927";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3274459976571317/6451758783";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      return "ca-app-pub-3940256099942544/5224354917";
    }
  }

  static String get openAdUnitId {
    if (!testAds) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3274459976571317/8059942551";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3274459976571317/9538701526";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      return "ca-app-pub-3940256099942544/3419835294";
    }
  }

}