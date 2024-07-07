import 'package:app_settings/app_settings.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../constants/assets_manager.dart';
import '../../../../constants/shared_preferences_constants.dart';
import '../../../../services/navigation_service.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';

class TodayAdviceDialog {
  static void show(BuildContext context, String? body) {
    final prefs = locator<SharedPrefServices>();
    showDialog(context: context, builder: (context) =>
        Dialog(backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),),
          child: Padding(padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
              Column(mainAxisSize: MainAxisSize.min,
              children: [
                const SubtitleTextWidget(label: "نصيحة اليوم من البرطمان 🎁",
                  textAlign: TextAlign.center,),
                const SizedBox(height: 10),
                Image.asset(
                  AssetsManager.giftBox,
                  width: 100,
                  height: 100,
                  fit:  BoxFit.cover,
                ),
                const SizedBox(height: 20),
                ContentTextWidget(label: body, textAlign: TextAlign.center,),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: () async => await Share.share(
                        '$body \n\n من تطبيق برطمان السعادة 💙'),
                      icon: Icon(Icons.share, color: Theme
                          .of(context)
                          .iconTheme
                          .color,),),
                    IconButton(onPressed: () {
                      FlutterClipboard.copy(
                          '$body \n\n من تطبيق برطمان السعادة 💙');
                    },
                      icon: Icon(
                        CupertinoIcons.doc_on_clipboard_fill, color: Theme
                          .of(context)
                          .iconTheme
                          .color,),),
                  ],),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(onPressed: () async {
                      await prefs.saveString(
                          SharedPrefsConstants.GET_TODAY_ADVICE_TIME,
                          DateTime.now().toIso8601String());
                      locator<NavigationService>().goBack();
                    },
                      style: TextButton.styleFrom(backgroundColor: Theme
                          .of(context)
                          .iconTheme
                          .color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),),
                      child: SubtitleTextWidget(label: "شكراً 🎉", color: Theme
                          .of(context)
                          .primaryColor, fontSize: 18,),),
                  ],
                ),
              ],),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Image.asset(
                    AssetsManager.teacher,
                    width: 100,
                  ),
                ),
              ]
               ,),
            ),),);
  }

}