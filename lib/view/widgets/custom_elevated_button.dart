import 'package:flutter/material.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color? backgroundColor;
  final Color textColor;
  final double horizontal;
  final double vertical;
  final Color? shadowColor;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.horizontal = 50,
    this.vertical = 15,
    this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        shadowColor: shadowColor,
      ),
      child: SubtitleTextWidget(
        color: textColor, label: label,
      ),
    );
  }
}
