import 'package:flutter/material.dart';

class SubtitleTextWidget extends StatelessWidget {
  const SubtitleTextWidget({
    super.key,
    required this.label,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w600,
    this.color,
    this.fontFamily = "avenir_medium",
  });

  final String? label;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final String fontFamily;
  @override
  Widget build(BuildContext context) {
    return Text(
      label!,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: color,
      ),
    );
  }
}
