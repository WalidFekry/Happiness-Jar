import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/consts/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class AppBarTextWidget extends StatelessWidget {
  const AppBarTextWidget({super.key, this.fontSize = 30, required this.title});
  final double fontSize;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 15),
      baseColor: AppColors.lightColor2,
      highlightColor: AppColors.lightColor1,
      child: Text(
      title!,
      style: TextStyle(
          fontSize: fontSize,
          fontFamily: "bar",
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis),
    )
    );
  }
}
