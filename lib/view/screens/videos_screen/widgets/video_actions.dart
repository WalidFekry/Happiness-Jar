import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../helpers/spacing.dart';

class VideoActionsItem extends StatelessWidget {
  const VideoActionsItem(
      {super.key, this.icon, required this.text, this.iconSvg, this.iconColor});

  final IconData? icon;
  final String text;
  final SvgPicture? iconSvg;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          iconSvg ??
              Icon(
                icon,
                size: 20,
                color: iconColor ?? Theme.of(context).iconTheme.color,
              ),
          horizontalSpace(3),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).iconTheme.color,
              fontSize: 16,
              fontFamily: 'bar',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
