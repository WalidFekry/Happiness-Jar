import 'dart:io';

class AdsManager {

  static bool testAds = true;

  static String get bannerAdUnitId {
    if (!testAds) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-4380347337966794/3106571416';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-4380347337966794/1500659906';
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
        return "ca-app-pub-1264835814900584/7461169229";
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
        return "ca-app-pub-1264835814900584/3585493651";
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
        return "ca-app-pub-1264835814900584/6403228681";
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