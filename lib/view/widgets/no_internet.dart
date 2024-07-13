import 'package:flutter/material.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

import '../../constants/app_consts.dart';
import '../../constants/assets_manager.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

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
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SubtitleTextWidget(
            label: AppConsts.NO_INTERNET_MESSAGE,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
