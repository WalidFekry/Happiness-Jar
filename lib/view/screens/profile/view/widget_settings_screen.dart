import 'dart:io';

import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_colors.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/services/widget_service.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/custom_app_bar.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';
import 'package:home_widget/home_widget.dart';

import '../../../../constants/assets_manager.dart';

class WidgetSettingsScreen extends StatelessWidget {
  const WidgetSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'ويدجت برطمان السعادة',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            verticalSpace(20),
            _buildWidgetPreview(context),
            verticalSpace(30),
            const TitleTextWidget(
              label: "رسالتك من البرطمان على شاشتك",
              fontSize: 20,
            ),
            verticalSpace(10),
            const ContentTextWidget(
              label:
                  "أضف ويدجت برطمان السعادة لشاشتك الرئيسية لتصلك رسالة إيجابية وسعيدة تتغير تلقائياً طوال اليوم.",
              textAlign: TextAlign.center,
            ),
            verticalSpace(30),
            _buildFeatureItem(
              context,
              icon: Icons.auto_awesome,
              title: "تحديث تلقائي",
              description: "تتغير الرسالة بشكل دوري لتفاجئك بكل ما هو جميل.",
            ),
            verticalSpace(40),
            ElevatedButton(
              onPressed: () => _requestPinWidget(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightColor1,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const SubtitleTextWidget(
                label: "إضافة الويدجت",
                color: Colors.white,
              ),
            ),
            verticalSpace(20),
            if (Platform.isIOS)
              const ContentTextWidget(
                label:
                    "* في iOS، يرجى إضافتها من خلال الضغط المطول على الشاشة الرئيسية ثم اختيار 'برطمان السعادة'.",
                fontSize: 12,
                color: Colors.grey,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.darkScaffoldColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AssetsManager.appLogoNoTitle,
            height: 46,
            width: 46,
            fit: BoxFit.contain,
          ),
          verticalSpace(10),
          const Text(
            "\"كن على يقين أن القادم أجمل بإذن الله، فالله لا يضيع أجر من أحسن عملاً.\"",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.lightScaffoldColor,
              fontFamily: "avenir_medium",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String description}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.lightColor1.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.lightColor1),
        ),
        horizontalSpace(15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubtitleTextWidget(label: title),
              ContentTextWidget(
                label: description,
                fontSize: 13,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _requestPinWidget() {
    if (Platform.isAndroid) {
      HomeWidget.requestPinWidget(
        androidName: 'HappinessJarWidgetProvider',
      );
    } else if (Platform.isIOS) {
      // iOS doesn't support requestPinWidget in the same way, we show a guide or open settings
      // Usually we just tell the user how to add it.
    }
  }
}
