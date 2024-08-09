import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:happiness_jar/constants/app_colors.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/view/screens/messages/view_model/messages_view_model.dart';

import '../../base_screen.dart';
import 'wheel_images_dialog.dart';

class WheelDialog extends StatelessWidget {
  WheelDialog({Key? key, required this.userName}) : super(key: key);
  final String? userName;
  StreamController<int> tabIndex = StreamController<int>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: BaseView<MessagesViewModel>(
          onModelReady: (viewModel) {},
          builder: (context, viewModel, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                     ),
                  height: 250,
                  width: 250,
                  child: FortuneWheel(
                    physics: CircularPanPhysics(
                      duration: const Duration(seconds: 1),
                      curve: Curves.decelerate,
                    ),
                    onAnimationStart: () {
                      viewModel.getWheelImages();
                      tabIndex.add(Random().nextInt(6));
                    },
                    onAnimationEnd: () async {
                      locator<NavigationService>().goBack();
                      var confirmation = await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return WheelImagesDialog(
                            imageUrl: viewModel.wheelImagesList[0].url,
                            userName: userName,
                          );
                        },
                      );
                      if (confirmation) {
                        viewModel.saveImage(viewModel.wheelImagesList[0].url);
                      }
                    },
                    selected: tabIndex.stream,
                    items: const [
                      FortuneItem(
                        style: FortuneItemStyle(
                          color: AppColors.lightColor1,
                          borderColor: Colors.grey,
                        ),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(90 / 360),
                        ),
                      ),
                      FortuneItem(
                        style: FortuneItemStyle(
                          color: AppColors.lightColor2,
                          borderColor: Colors.grey,
                        ),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(90 / 360),
                        ),
                      ),
                      FortuneItem(
                        style: FortuneItemStyle(
                          color: AppColors.lightColor3,
                          borderColor: Colors.grey,
                        ),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(90 / 360),
                        ),
                      ),
                      FortuneItem(
                        style: FortuneItemStyle(
                          color: AppColors.darkColor1,
                          borderColor: Colors.grey,
                        ),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(90 / 360),
                        ),
                      ),
                      FortuneItem(
                        style: FortuneItemStyle(
                          color: AppColors.darkColor2,
                          borderColor: Colors.grey,
                        ),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(90 / 360),
                        ),
                      ),
                      FortuneItem(
                        style: FortuneItemStyle(
                          color: AppColors.darkColor3,
                          borderColor: Colors.grey,
                        ),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(90 / 360),
                        ),
                      ),
                    ],
                  ),
                ), // Inner circular widget
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
