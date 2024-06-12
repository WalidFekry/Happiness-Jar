import 'package:flutter/material.dart';
import 'package:happiness_jar/providers/theme_provider.dart';
import 'package:happiness_jar/routs/app_router.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/screens/home/view/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'locator.dart';

Future<void> initServices() async {
  setupLocator();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (
          context,
          themeProvider,
          child,
          ) {
        return MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          title: 'برطمان السعادة',
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          initialRoute: RouteName.HOME,
          navigatorKey: locator<NavigationService>().navigatorKey,
          onGenerateRoute: AppRouter.generateRoute,
        );
      }),
    );
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