import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_jar/constants/assets_manager.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

import '../../../../routs/routs_names.dart';
import '../../../../services/navigation_service.dart';

class MoreMainSectionsScreen extends StatelessWidget {
  const MoreMainSectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSectionCard(
                imagePath: AssetsManager.speaking,
                title: 'فضفضة',
                context: context,
                routeName: RouteName.GET_NOTIFICATION_SCREEN),
            horizontalSpace(20),
            _buildSectionCard(
                imagePath: AssetsManager.feeling,
                title: 'بماذا تشعر؟',
                context: context,
                routeName: RouteName.FEELINGS_SCREEN),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String imagePath,
    required String title,
    required BuildContext context,
    required String routeName,
  }) {
    return GestureDetector(
      onTap: () {
        locator<NavigationService>().navigateTo(routeName);
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SvgPicture.asset(
                  imagePath,
                  width: 75,
                  height: 75,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).iconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              verticalSpace(12),
              SubtitleTextWidget(
                label: title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
