import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_jar/view/screens/posts/model/posts_model.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/assets_manager.dart';
import '../../../../helpers/spacing.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';

class PostScreenshot extends StatelessWidget {
  const PostScreenshot(this.postsItem, {super.key});

  final PostItem postsItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        20,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
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
                    AssetsManager.quote,
                    width: 30,
                    height: 30,
                    colorFilter: const ColorFilter.mode(
                        AppColors.lightColor2,
                        BlendMode.srcIn),
                  ),
                  horizontalSpace(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubtitleTextWidget(
                        label: "بقلم : ${postsItem.userName}",
                        color: Colors.black,
                        fontSize: 16,
                        maxLines: 1,
                      ),
                      verticalSpace(2.5),
                      SubtitleTextWidget(
                        label: postsItem.createdAt,
                        color: Colors.black,
                        fontSize: 14,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ContentTextWidget(
                    color: Colors.black,
                    label: postsItem.text,
                    textAlign:  TextAlign.center,
                  )),
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
