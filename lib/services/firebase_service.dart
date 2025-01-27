import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';

class FirebaseService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      // Pass all uncaught "fatal" errors from the framework to Crashlytics
      FlutterError.onError = crashlytics.recordFlutterFatalError;
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      messaging.subscribeToTopic("all");
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
