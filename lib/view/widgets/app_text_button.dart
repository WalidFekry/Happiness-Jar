import 'package:flutter/material.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({required this.onPressed, super.key, required this.label, this.backgroundColor});
  final Function()? onPressed;
  final String? label;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: backgroundColor ?? Theme
            .of(context)
            .iconTheme
            .color,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),),
        elevation: 5.0, // Elevation for shadow effect
      ),
      child: SubtitleTextWidget(label: label),);
  }
}
