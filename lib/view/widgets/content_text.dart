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
  });

  final String? label;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final String fontFamily;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      label!,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
