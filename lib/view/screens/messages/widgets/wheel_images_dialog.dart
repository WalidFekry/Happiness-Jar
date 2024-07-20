import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_colors.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';

import '../../../widgets/app_text_button.dart';

class WheelImagesDialog extends StatelessWidget {
  const WheelImagesDialog(
      {required this.imageUrl, required this.userName, Key? key})
      : super(key: key);
  final String? imageUrl;
  final String? userName;
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
            padding: const EdgeInsets.all(5),
            clipBehavior: Clip.hardEdge,
            height: 450,
            width: 450,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleTextWidget(
                  label: "رسالتك يا $userName 💙",
                  fontSize: 18,
                ),
                SizedBox(
                  height: 350,
                  width: 350,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    progressIndicatorBuilder:
                    (context, url, downloadProgress) => Container(
                      padding: const EdgeInsets.all(100),
                      child: CircularProgressIndicator(color: Theme.of(context).iconTheme.color,),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (imageUrl != "")
                      AppTextButton(
                        onPressed: () {
                          locator<NavigationService>().goBackWithData(true);
                        },
                        label: "حفظ الصورة",
                      ),
                    AppTextButton(
                      onPressed: () {
                        locator<NavigationService>().goBackWithData(false);
                      },
                      label: "حسناً",
                      backgroundColor: Theme.of(context).cardColor,
                    ),
                  ],
                ),
              ],
            )));
  }
}
