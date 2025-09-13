import 'dart:math';

import 'package:flutter/material.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';

import '../../../helpers/common_functions.dart';

class BirthdayCelebrationScreen extends StatefulWidget {
  final String? userName;
  final DateTime? birthday;

  const BirthdayCelebrationScreen({super.key, required this.userName, required this.birthday});

  @override
  State<BirthdayCelebrationScreen> createState() =>
      _BirthdayCelebrationScreenState();
}

class _BirthdayCelebrationScreenState extends State<BirthdayCelebrationScreen>
    with TickerProviderStateMixin {
  late AnimationController _balloonController;
  late AnimationController _cakeBounceController;

  @override
  void initState() {
    super.initState();

    _balloonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _cakeBounceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _balloonController.dispose();
    _cakeBounceController.dispose();
    super.dispose();
  }

  String _calculateAge(DateTime birthday) {
    final today = DateTime.now();
    int years = today.year - birthday.year;
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      years--;
    }
    return "$years سنة 🎂";
  }

  String _formatBirthday(DateTime birthday) {
    final months = [
      "يناير",
      "فبراير",
      "مارس",
      "أبريل",
      "مايو",
      "يونيو",
      "يوليو",
      "أغسطس",
      "سبتمبر",
      "أكتوبر",
      "نوفمبر",
      "ديسمبر"
    ];
    return "${birthday.day} ${months[birthday.month - 1]} ${birthday.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _balloonController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _BalloonPainter(_balloonController.value),
                  child: Container(),
                );
              },
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade200, Colors.orange.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: _cakeBounceController,
                        child: const Icon(Icons.cake,
                            size: 60, color: Colors.white),
                      ),
                      verticalSpace(10),
                      const TitleTextWidget(
                        label: "عيد ميلاد سعيد 🎉",
                        color: Colors.white,
                      ),
                      verticalSpace(8),
                      SubtitleTextWidget(
                        label: "كل سنة وانت بخير يا ${widget.userName} 🌸",
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildAnimatedCard(
                          title: "📅 عُمر مزدهر",
                          content:
                              "عمرك الآن: ${_calculateAge(widget.birthday!)} \n"
                              "تاريخ ميلادك: ${_formatBirthday(widget.birthday!)} 💙 \n"
                              "رحلة طويلة مليانة لحظات تستاهل الاحتفال والامتنان 🥰.",
                        ),
                        _buildDivider(),
                        _buildAnimatedCard(
                          title: "🎈 تهنئة خاصة",
                          content:
                              "عيد ميلادك مش مجرد تاريخ، ده محطة جديدة في رحلة حياتك.\n"
                              "خلي دايمًا قلبك عامر بالحب، وابتسامتك منورة الطريق لكل اللي حواليك.\n"
                              "نتمنى لك أيام مليانة راحة بال، وذكريات حلوة، وإنك تحقق كل اللي نفسك فيه.\n"
                              "كل لحظة في السنة الجديدة دي هتكون فرصة جديدة تكتب فيها قصة نجاحك 🥳.",
                        ),
                        _buildDivider(),
                        _buildAnimatedCard(
                          title: "💡 نصيحة لسنة جديدة",
                          content:
                              "ابدأ السنة دي بقرار بسيط: حب نفسك أكتر، واهتم براحتك النفسية.\n"
                              "خلي أهدافك صغيرة بس ثابتة، وافتكر إن التغيير الحقيقي بيبدأ بخطوة صغيرة.\n"
                              "خصص وقت كل يوم لراحة قلبك سواء بذكر الله، أو قراية، أو حتى لحظة هدوء.\n"
                              "وافتكر دايمًا إن السعادة مش في الحاجات الكبيرة، لكن في التفاصيل الصغيرة 🌿.",
                        ),
                        _buildDivider(),
                        _buildAnimatedCard(
                          title: "🌟 رسالة إلهام",
                          content:
                              "في كل يوم جديد عندك فرصة تعيش حياة أعمق، تكون شخص أفضل، وتسيب أثر حقيقي.\n"
                              "خلي يوم ميلادك بداية لنسخة أقوى وأهدأ من نفسك.\n"
                              "خليك صبور على أحلامك، وافتكر إن كل حاجة حلوة بتاخد وقتها.\n"
                              "أنت مش بس بتكبر في العمر، أنت كمان بتكبر في الحكمة والخبرة 💫.",
                        ),
                        _buildDivider(),
                        _buildAnimatedCard(
                          title: "🤲 دعاء السنة الجديدة",
                          content:
                              "اللهم اجعل هذه السنة فاتحة خير وبركة على حياتك.\n"
                              "اللهم ارزقك فيها راحة بال، وصحة في الجسد، ونور في القلب.\n"
                              "واجعل أيامك عامرة بالرضا والطمأنينة، وأحاطك الله فيها بحفظه ورعايته دائمًا.\n"
                              "اللهم اجعلها سنة مليئة بالإنجازات والفرح، ومليانة بذكر الله ورضاه ❤️.",
                        ),
                        _buildDivider(),
                        _buildAnimatedCard(
                          title: "📤 شارك فرحتك",
                          content: "خلي حبك وسعادتك يوصلوا لكل اللي بتحبهم.\n"
                              "شارك اللحظة دي مع أصحابك وأهلك، وخليهم جزء من فرحتك.\n"
                              "الفرحة لما تتشارك بتكبر وتدفي القلب أكتر 👀.",
                          action: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    CommonFunctions.shareMessage(
                                        "🎉 عيد ميلادي النهاردة! كل سنة وأنا بخير \n"
                                        "🥰 بداية جديدة وسنة كلها أمل ونجاحات \n\n"
                                        "💙 شكراً لتطبيق برطمان السعادة اللي فاجئني بالتهنئة");
                                  },
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                  label: const SubtitleTextWidget(
                                    label: "شارك فرحتك",
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              horizontalSpace(10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await CommonFunctions.sharePhoto(
                                      "🎉 شوفوا صفحة التهنئة بتاعتي!",
                                      MediaQuery(
                                        data: MediaQueryData.fromView(
                                            View.of(context)),
                                        child: BirthdayCelebrationScreen(userName: widget.userName, birthday: widget.birthday,),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.card_giftcard,
                                    color: Colors.white,
                                  ),
                                  label: const SubtitleTextWidget(
                                    label: "شارك التهنئة",
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildDivider(),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                            locator<NavigationService>().goBack();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.shade400,
                                    Colors.orange.shade400,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const TitleTextWidget(label: "الدخول للتطبيق 🚀",fontSize: 14,color: Colors.white,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required String title,
    required String content,
    Widget? action,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        final safeValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: safeValue,
          child: Opacity(opacity: safeValue, child: child),
        );
      },
      child:
          _buildCard(context, title: title, content: content, action: action),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      height: 2,
      width: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade200, Colors.orange.shade200],
        ),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String content,
    Widget? action,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubtitleTextWidget(
            label: title,
            color: Colors.pink.shade400,
            fontSize: 18,
          ),
          verticalSpace(10),
          ContentTextWidget(
            label: content,
            color: Colors.grey.shade700,
            height: 1.5,
            fontSize: 16,
          ),
          if (action != null) ...[
            verticalSpace(15),
            Center(child: action),
          ]
        ],
      ),
    );
  }
}

class _BalloonPainter extends CustomPainter {
  final double progress;
  final Random random = Random();

  _BalloonPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      final dx = (i * 60.0) + 30;
      final dy = size.height - (progress * size.height) - (i * 80.0);

      paint.color = Colors.primaries[i % Colors.primaries.length].shade300;

      final balloonCenter = Offset(dx % size.width, dy % size.height);
      canvas.drawCircle(balloonCenter, 20, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BalloonPainter oldDelegate) => true;
}
