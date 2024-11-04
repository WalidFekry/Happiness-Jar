import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';

import '../../../../constants/app_constants.dart';
import '../../../../constants/assets_manager.dart';

class FeelingsGetStarted extends StatelessWidget {
  const FeelingsGetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AssetsManager.happyFeelings,
          width: 100,
          height: 100,
          colorFilter: ColorFilter.mode(
            Theme.of(context).cardColor,
            BlendMode.srcIn,
          ),
        ),
        verticalSpace(10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const ContentTextWidget(
            label: AppConstants.feelingsGetStarted,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
