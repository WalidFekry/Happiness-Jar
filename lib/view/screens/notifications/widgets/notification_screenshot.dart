import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_colors.dart';
import 'package:happiness_jar/constants/app_consts.dart';

import '../../../../constants/assets_manager.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';
import '../model/notification_model.dart';

class NotificationScreenshot extends StatelessWidget {
  const NotificationScreenshot(this.messagesNotifications, {super.key});

  final MessagesNotifications messagesNotifications;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SubtitleTextWidget(
                        label: messagesNotifications.createdAt?.split(" ")[0],
                        fontSize: 16,
                        color: Colors.black),
                    Image.asset(
                      AssetsManager.notificationJar,
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                    ),
                    SubtitleTextWidget(
                      label: "إشعار رقم : ${messagesNotifications.id}",
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ContentTextWidget(
                      color: Colors.black,
                      label: messagesNotifications.text,
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
      ),
    );
  }
}
