import 'dart:io';

import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_colors.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/custom_app_bar.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';
import 'package:home_widget/home_widget.dart';

import '../../../constants/assets_manager.dart';
import '../../../services/widget_service.dart';

class WidgetSettingsScreen extends StatelessWidget {
  const WidgetSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'ويدجت السعادة',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SubtitleTextWidget(
              label: "مثال للويدجت",
              fontSize: 16,
              color: Colors.grey,
            ),
            verticalSpace(10),
            _buildWidgetPreview(context),
            verticalSpace(30),
            const TitleTextWidget(
              label: "رسالتك من البرطمان على شاشتك",
              fontSize: 20,
            ),
            verticalSpace(10),
            const ContentTextWidget(
              label:
                  "أضف ويدجت السعادة لشاشتك الرئيسية لتصلك رسائل من البرطمان تتغير تلقائياً طوال اليوم.",
              textAlign: TextAlign.center,
            ),
            verticalSpace(30),
            _buildInstructionSection(context),
            verticalSpace(30),
            if(Platform.isAndroid) ... [
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
                  label: "إضافة تلقائية",
                  color: Colors.white,
                ),
              ),
              verticalSpace(15),
              ContentTextWidget(
                label: "* قد لا تدعم بعض أجهزة أندرويد الإضافة التلقائية، استخدم الطريقة اليدوية أعلاه في هذه الحالة.",
                fontSize: 14,
                color: Theme.of(context).cardColor,
                textAlign: TextAlign.center,
              ),
              verticalSpace(30),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray300.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubtitleTextWidget(
            label: "طريقة الإضافة اليدوية:",
            fontSize: 18,
          ),
          verticalSpace(12),
          if (Platform.isAndroid) ...[
            _buildStepItem("1", "اضغط مطولاً على أي مساحة فارغة في الشاشة الرئيسية."),
            _buildStepItem("2", "اختر 'الأدوات' أو 'Widgets'."),
            _buildStepItem("3", "ابحث عن تطبيق 'برطمان السعادة'."),
            _buildStepItem("4", "قم بسحب الويدجت ووضعها في المكان المناسب لك."),
          ] else ...[
            _buildStepItem("1", "اضغط مطولاً على أي مساحة فارغة في الشاشة الرئيسية حتى تهتز الأيقونات."),
            _buildStepItem("2", "اضغط على زر (+) الموجود في أعلى الشاشة."),
            _buildStepItem("3", "ابحث عن 'برطمان السعادة' في قائمة الأدوات."),
            _buildStepItem("4", "اختر الحجم المفضل واضغط على 'إضافة أداة'."),
          ],
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.lightColor1,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          horizontalSpace(10),
          Expanded(
            child: ContentTextWidget(
              label: text,
              fontSize: 14,
            ),
          ),
        ],
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

  Future<void> _requestPinWidget() async {
      await locator<WidgetService>().refreshWidgetMessages();
      HomeWidget.requestPinWidget(
        androidName: 'HappinessJarWidgetProvider',
      );
  }
}
