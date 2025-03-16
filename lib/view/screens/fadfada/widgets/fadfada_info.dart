import 'package:flutter/material.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';

class FadfadaInfoWidget extends StatelessWidget {
  const FadfadaInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey,
              width: 2.0,
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleTextWidget(
                label: " مرحبًا بك في الركن الدافئ! ✨ 🏡",
              ),
              verticalSpace(10),
              const ContentTextWidget(
                label: "هذا القسم هو مساحتك الخاصة للتعبير بحرية تامة. هنا يمكنك كتابة أفكارك، مشاعرك، وتسجيل لحظاتك المهمة دون أي قيود.",
              ),
              verticalSpace(8),
              const ContentTextWidget(
                label: "🛡️ لا أحد سيراها غيرك، لأن جميع الفضفضات تُحفظ محليًا على هاتفك فقط، مما يضمن لك أقصى درجات الخصوصية والأمان.",
              ),
              verticalSpace(8),
              const ContentTextWidget(
                label: "✍️ سواء كنت تريد التعبير عن يومك، تدوين فكرة، كتابة رسالة لنفسك، أو حتى تسجيل أهدافك، فهذا المكان مصمم لك خصيصًا.",
              ),
              verticalSpace(12),
              const SubtitleTextWidget(
                label: "📝 ابدأ الآن وأضف أول فضفضة لك!",
              ),
            ],
          ),
        ),
    );
  }
}
