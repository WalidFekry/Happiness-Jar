import 'package:flutter/cupertino.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

import '../../../../consts/assets_manager.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget(this.userName, {super.key});
  final String? userName;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AssetsManager.iconAppBar,height: 150,),
        const SizedBox(height: 15,),
        SubtitleTextWidget(label: "لعرض رسائل البرطمان يلزم الاتصال بالانترنت \n يا $userName 💙",textAlign: TextAlign.center,)
      ],
    );
  }
}
