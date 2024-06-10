import 'package:flutter/material.dart';

import 'app_colors.dart';

class Styles {
  static ThemeData themeData({
    required bool isDarkTheme,
    required BuildContext context,
  }) {
    return ThemeData(
      useMaterial3: true,
      primaryColor: isDarkTheme ? Colors.white : Colors.black,
      iconTheme: IconThemeData(color: isDarkTheme ? AppColors.darkColor1 : AppColors.lightColor1,),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: kBottomNavigationBarHeight,
        backgroundColor: isDarkTheme ? AppColors.darkScaffoldColor : AppColors.lightScaffoldColor,
        indicatorColor:
            isDarkTheme ? AppColors.darkColor1 : AppColors.lightColor1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(AppColors.lightColor2),
        trackColor: MaterialStateProperty.all(AppColors.darkColor2),
      ),
      scaffoldBackgroundColor: isDarkTheme
          ? AppColors.darkScaffoldColor
          : AppColors.lightScaffoldColor,
      cardColor: isDarkTheme ? AppColors.darkColor2 : AppColors.lightColor2,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        backgroundColor: isDarkTheme
            ? AppColors.darkScaffoldColor
            : AppColors.lightScaffoldColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}