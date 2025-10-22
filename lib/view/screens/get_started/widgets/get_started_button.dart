import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_colors.dart';
import 'package:happiness_jar/helpers/spacing.dart';
import 'package:happiness_jar/services/firebase_service.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';
import 'package:iconly/iconly.dart';

import '../../../../routs/routs_names.dart';

class GetStartedButton extends StatelessWidget {
  const GetStartedButton(this.route,this.text, {Key? key}) : super(key: key);
  final String route;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if(route == RouteName.GET_NOTIFICATION_SCREEN) {
            locator<NavigationService>().navigateToAndClearStack(route);
            }else {
              if (Platform.isIOS) {
                final status = await AppTrackingTransparency.trackingAuthorizationStatus;
                if (status == TrackingStatus.notDetermined) {
                  await AppTrackingTransparency.requestTrackingAuthorization();
                }
              }
              FirebaseService.requestPermission();
              locator<NavigationService>().navigateToAndClearStack(route);
            }
          },
          borderRadius: BorderRadius.circular(12),
          highlightColor: AppColors.lightColor1.withOpacity(0.4),
          splashColor: AppColors.darkColor1.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleTextWidget(
                  label: text,
                ),
                horizontalSpace(4),
                Icon(IconlyLight.arrow_left_2,
                    size: 20, color: Theme.of(context).iconTheme.color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
