import 'package:flutter/cupertino.dart';

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({
    Key? key,
    required this.label,
    this.fontSize = 22,
    this.color,
    this.maxLines,
    this.fontFamily = "avenir_bold",
  }) : super(key: key);

  final String? label;
  final double fontSize;
  final Color? color;
  final int? maxLines;
  final String fontFamily;
  @override
  Widget build(BuildContext context) {
    return Text(
      label!,
      maxLines: maxLines,
      // textAlign: TextAlign.justify,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis),
    );
  }
}
