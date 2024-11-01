import 'package:flutter/material.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

import '../../../../constants/app_constants.dart';
import '../../../../constants/assets_manager.dart';


class EmptyFeelings extends StatelessWidget {
  const EmptyFeelings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          AssetsManager.noInternetJar,
          width: 200,
          fit: BoxFit.cover,
        ),
        verticalSpace(10),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SubtitleTextWidget(
            label: AppConstants.emptyFeeling,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
