import 'package:flutter/material.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/services/ads_service.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/view/widgets/app_text_button.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

class ShowRewardedAdDialog extends StatelessWidget {
  ShowRewardedAdDialog({super.key});

  final adsService = locator<AdsService>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: const SubtitleTextWidget(label: 'يمكنك مشاهدة إعلان مكافئ للحصول على رسائل جديدة من البرطمان.',textAlign: TextAlign.center,),
      actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AppTextButton(onPressed: (){
            adsService.showRewardedAd(context);
          }, label: "مشاهدة"),
          AppTextButton(onPressed: () => locator<NavigationService>().goBack(), label: "لا",backgroundColor: Theme.of(context).cardColor,),
        ],
      )
      ],
    );
  }
}
