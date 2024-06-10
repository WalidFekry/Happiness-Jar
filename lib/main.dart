import 'package:flutter/material.dart';
import 'package:happiness_jar/providers/theme_provider.dart';
import 'package:happiness_jar/view/screens/home/view/home_screen.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
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
          title: 'Shop Smart AR',
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          home: const Directionality(
              textDirection: TextDirection.rtl, // set it to rtl
              child: HomeScreen()),
        );
      }),
    );
  }
}

