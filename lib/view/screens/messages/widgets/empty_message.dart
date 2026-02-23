import 'package:flutter/material.dart'; // استيراد مكتبة Material لإضافة border
import 'package:happiness_jar/view/screens/messages/widgets/show_rewarded_ad_dialog.dart';
import 'package:happiness_jar/view/screens/messages/widgets/wheel_dialog.dart';
import 'package:happiness_jar/view/widgets/app_text_button.dart';

import '../../../../constants/assets_manager.dart';
import '../../../../helpers/spacing.dart';
import '../../../../services/locator.dart';
import '../../../../services/ads_service.dart';
import '../../../widgets/subtitle_text.dart';

class EmptyMessageWidget extends StatelessWidget {
  EmptyMessageWidget(this.userName, {super.key});

  final String? userName;
  final adsService = locator<AdsService>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AssetsManager.emptyJar,
              width: 150,
              fit: BoxFit.cover,
            ),
            verticalSpace(10),
            Center(
              child: SubtitleTextWidget(
                label:
                    "لقد وصلت إلى نهاية رسائل البرطمان ⌛ \n عُد بعد 6 ساعات 🕕 \n لإكتشاف رسائل جديدة 💙 \n يا $userName 🦋",
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            verticalSpace(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return WheelDialog(userName: userName);
                        },
                      );
                    },
                    label: "عجلة الهدايا"), // AppTextButton(
                GestureDetector(
                  onTap: () async {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ShowRewardedAdDialog();
                            });
                  },
                    child: Image.asset(AssetsManager.socialMedia,
                        width: 100, height: 90, fit: BoxFit.contain)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
