import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

import '../../../../constants/assets_manager.dart';


class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget(this.userName, {super.key});
  final String? userName;
  @override
  Widget build(BuildContext context) {
    return Center(
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
            Image.asset(AssetsManager.noInternetJar,width: 200,fit: BoxFit.cover,),
            const SizedBox(height: 10,),
            Center(child: SubtitleTextWidget(label: "لعرض رسائل البرطمان يلزم الاتصال بالانترنت ⚠️ \n يا $userName 💙",textAlign: TextAlign.center,))
          ],
        ),
      ),
    );
  }
}
