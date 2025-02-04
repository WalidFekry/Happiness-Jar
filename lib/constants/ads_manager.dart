import 'dart:io';

class AdsManager {

  static bool testAds = true;

  static String get bannerAdUnitId {
    if (!testAds) {
      if (Platform.isAndroid) {
        return 'null';
      } else if (Platform.isIOS) {
        return 'null';
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
        return "ca-app-pub-3354189036871191/4546963710";
      } else if (Platform.isIOS) {
        return "ca-app-pub-1264835814900584/7385137864";
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
        return "ca-app-pub-3354189036871191/4322993626";
      } else if (Platform.isIOS) {
        return "ca-app-pub-1264835814900584/1278904258";
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
        return "ca-app-pub-3354189036871191/6573187791";
      } else if (Platform.isIOS) {
        return "ca-app-pub-1264835814900584/1917188763";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      return "ca-app-pub-3940256099942544/3419835294";
    }
  }

}