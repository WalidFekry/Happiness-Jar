import 'package:flutter/material.dart';

class SubtitleTextWidget extends StatelessWidget {
  const SubtitleTextWidget({
    super.key,
    required this.label,
    this.fontSize = 20,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.w600,
    this.color,
    this.fontFamily = "avenir_medium",
    this.maxLines, this.overflew,
  });

  final String? label;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final String fontFamily;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflew;
  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxLines,
      overflow: overflew,
      label!,
      textAlign: textAlign,
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
