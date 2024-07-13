import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_colors.dart';
import 'package:happiness_jar/constants/app_consts.dart';

import '../../../../constants/assets_manager.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';
import '../model/messages_content_model.dart';

class CategoriesScreenshot extends StatelessWidget {
  const CategoriesScreenshot(this.messagesContent,this.categorie, {super.key});

  final MessagesContent messagesContent;
  final String? categorie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        padding: const EdgeInsets.only(
            right: 5, left: 5, top: 5),
        decoration: BoxDecoration(
          color: AppColors.lightScaffoldColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
            const Color.fromARGB(178, 158, 158, 158),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                SubtitleTextWidget(
                  label: categorie,
                  fontSize: 16,
                  color: Colors.black,
                ),
                Image.asset(
                  AssetsManager.categoriesJar,
                  height: 50,
                  width: 50,
                  fit:  BoxFit.cover,
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ContentTextWidget(
                  label: messagesContent.title,
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
