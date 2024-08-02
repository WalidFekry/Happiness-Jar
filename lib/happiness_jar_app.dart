import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:happiness_jar/constants/theme_data.dart';
import 'package:happiness_jar/providers/theme_provider.dart';
import 'package:happiness_jar/routs/app_router.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/firebase_options.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'locator.dart';

Future<void> initServices() async {
  MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupLocator();
}

class HappinessJarApp extends StatelessWidget {
  const HappinessJarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            title: 'برطمان السعادة',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            initialRoute: RouteName.HOME,
            navigatorKey: locator<NavigationService>().navigatorKey,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}

EasyLocalization easyLocalization(Widget child) {
  return EasyLocalization(
    supportedLocales: const [Locale('en'),Locale('ar')],
    startLocale: const Locale('ar'),
    saveLocale: true,
    path: 'assets/translations',
    useOnlyLangCode: true,
    child: child,
  );
}