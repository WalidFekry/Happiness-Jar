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
      unselectedWidgetColor: isDarkTheme ? AppColors.darkColor3 : AppColors.lightColor3,
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
        fillColor: Colors.transparent,
        labelStyle: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          fontFamily: "avenir_medium"
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
