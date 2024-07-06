import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // استيراد مكتبة Material لإضافة border
import '../../../../consts/assets_manager.dart';
import '../../../widgets/subtitle_text.dart';

class EmptyMessageWidget extends StatelessWidget {
  const EmptyMessageWidget(this.userName, {super.key});
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
            Image.asset(
              AssetsManager.emptyJar,
              width: 150,
            ),
            const SizedBox(height: 10),
            Center(
              child: SubtitleTextWidget(
                label:
                "لقد وصلت إلى نهاية رسائل البرطمان ⌛ \n عُد بعد 6 ساعات 🕕 \n لإكتشاف رسائل جديدة 💙 \n يا $userName 🦋",
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
