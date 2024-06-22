import 'package:flutter/cupertino.dart';

import '../../../../services/assets_manager.dart';
import '../../../widgets/subtitle_text.dart';

class EmptyMessageWidget extends StatelessWidget {
  const EmptyMessageWidget(this.userName, {super.key});
  final String? userName;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AssetsManager.imageJar30,height: 150,),
        const SizedBox(height: 15,),
        Center(child: SubtitleTextWidget(label: "لا توجد رسائل في البرطمان ⏳ \n يتم التحديث كل 6 ساعات \n يا $userName 💙",textAlign: TextAlign.center,))
      ],
    );
  }
}
