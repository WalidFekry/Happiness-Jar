import 'package:flutter/material.dart';

class ContentTextWidget extends StatelessWidget {
  const ContentTextWidget({
    super.key,
    required this.label,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign = TextAlign.start,
    this.fontFamily = "avenir_regular",
    this.overflew,
    this.maxLines, this.height,
  });

  final String? label;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final String fontFamily;
  final TextAlign? textAlign;
  final TextOverflow? overflew;
  final int? maxLines;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Text(
      label!,
      textAlign: textAlign,
      overflow: overflew,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        height: height,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
