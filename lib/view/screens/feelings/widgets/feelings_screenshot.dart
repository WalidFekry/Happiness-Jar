import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_jar/view/screens/feelings/model/FeelingsContentModel.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/assets_manager.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';

class FeelingsScreenshot extends StatelessWidget {
  const FeelingsScreenshot(this.feelingsContent, {super.key});

  final FeelingsContent feelingsContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 30,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.only(right: 5, left: 5, top: 5),
          decoration: BoxDecoration(
            color: AppColors.lightScaffoldColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AssetsManager.quoteDown,
                    width: 25,
                    height: 25,
                    colorFilter: const ColorFilter.mode(
                      AppColors.lightColor2,
                      BlendMode.srcIn,
                    ),
                  ),
                  const Spacer(),
                  SubtitleTextWidget(label: feelingsContent.title,color: Colors.black,),
                  const Spacer(),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ContentTextWidget(
                    color: Colors.black,
                    label: feelingsContent.body,
                    textAlign: TextAlign.center,
                  )),
              Align(
                alignment: Alignment.bottomLeft,
                child: SvgPicture.asset(
                  AssetsManager.quoteUp,
                  width: 25,
                  height: 25,
                  colorFilter: const ColorFilter.mode(
                    AppColors.lightColor2,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.grey, thickness: 1),
              ),
              const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ContentTextWidget(
                      color: Colors.black,
                      label: AppConstants.copyMessage,
                      textAlign: TextAlign.center)),
            ],
          ),
        ),
      ),
    );
  }
}
