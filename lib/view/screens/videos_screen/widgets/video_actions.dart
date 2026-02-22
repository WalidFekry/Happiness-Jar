
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_colors.dart';
import '../../../../helpers/spacing.dart';


Widget VideoActionsItem(IconData icon, String text,
    {SvgPicture? iconSvg, Color? iconColor}) {
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
              color: iconColor ?? AppColors.lightColor1,
            ),
        horizontalSpace(3),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.lightColor1,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
