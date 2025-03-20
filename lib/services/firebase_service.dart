import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'firebase_options.dart';

class FirebaseService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      FlutterError.onError = (errorDetails) {
        crashlytics.recordFlutterFatalError(errorDetails);
      };
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        crashlytics.recordError(error, stack, fatal: true);
        return true;
      };
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      messaging.subscribeToTopic("all_users");
      MobileAds.instance.initialize();
    }catch(e) {
      if (kDebugMode) {
        print("Firebase initialization failed: $e");
      }
    }
  }

  static Future<void> requestPermission() async {
    await messaging.requestPermission(
      sound: true,
      alert: true,
      badge: true,
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    if (kDebugMode) {
      print('Handling a background message: ${message.messageId}');
    }
  }
}
