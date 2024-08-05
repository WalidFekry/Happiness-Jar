import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/constants/assets_manager.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';

import '../../../../helpers/spacing.dart';
import '../../../../routs/routs_names.dart';
import '../../../../services/navigation_service.dart';

class ExitAppScreen extends StatelessWidget {
  const ExitAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsManager.welcomeJar,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
            verticalSpace(20),
            const TitleTextWidget(
              label: "هل ترغب في الخروج من التطبيق؟",
            ),
            verticalSpace(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    locator<NavigationService>().navigateTo(RouteName.HOME);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).iconTheme.color,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const SubtitleTextWidget(
                    label: "لا",
                    color: Colors.white,
                  ),
                ),
                horizontalSpace(20),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).cardColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const SubtitleTextWidget(
                    label: "نعم",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
