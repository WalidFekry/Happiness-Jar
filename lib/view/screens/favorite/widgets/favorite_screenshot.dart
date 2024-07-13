import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_consts.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/assets_manager.dart';
import '../../../widgets/content_text.dart';
import '../model/favorite_messages_model.dart';

class FavoriteScreenshot extends StatelessWidget {
  const FavoriteScreenshot(this.favoriteMessagesModel, {super.key});

  final FavoriteMessagesModel favoriteMessagesModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Image.asset(
                  AssetsManager.favoriteJar,
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ContentTextWidget(
                  label: favoriteMessagesModel.title,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Colors.grey, thickness: 1),
            ),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: ContentTextWidget(
                    color: Colors.black,
                    label: AppConsts.COPY_MESSAGE,
                    textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}
