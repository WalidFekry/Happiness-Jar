import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_jar/view/screens/feelings/widgets/show_feelings_content_dialog.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/assets_manager.dart';
import '../../../../helpers/spacing.dart';
import '../../../widgets/content_text.dart';
import '../../posts/dialogs/show_post_dialog.dart';
import '../view_model/feelings_view_model.dart';

class FeelingsContentListView extends StatelessWidget {
  FeelingsContentListView(this.viewModel, {super.key});

  FeelingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.listOfFeelingsContent.length - 1,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 2),
          ),
          child: GestureDetector(
            onTap: () {
              viewModel.showBinyAd();
              showDialog(
                context: context,
                builder: (context) {
                  return ShowFeelingsContentDialog(viewModel, index);
                },
              );
            },
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AssetsManager.quoteDown,
                      width: 25,
                      height: 25,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).cardColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Spacer(),
                    SubtitleTextWidget(
                        label: viewModel.listOfFeelingsContent[index].title),
                    const Spacer(),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ContentTextWidget(
                      label: viewModel.listOfFeelingsContent[index].body,
                      textAlign: TextAlign.center,
                    )),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SvgPicture.asset(
                    AssetsManager.quoteUp,
                    width: 25,
                    height: 25,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).cardColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color: Colors.grey, thickness: 1),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: IconButton(
                          onPressed: () {
                            viewModel.showBinyAd();
                            viewModel.copyMessage(index);
                            showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.success(
                                backgroundColor:
                                    Theme.of(context).iconTheme.color!,
                                message: "تم النسخ",
                                icon: Icon(
                                  Icons.copy,
                                  color: Theme.of(context).cardColor,
                                  size: 50,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.copy,
                              color: Theme.of(context).iconTheme.color),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          onPressed: () {
                            viewModel.shareMessage(index);
                          },
                          icon: Icon(Icons.share,
                              color: Theme.of(context).iconTheme.color),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          onPressed: () {
                            viewModel.shareWhatsapp(index);
                          },
                          icon: SvgPicture.asset(
                            AssetsManager.whatsapp,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).iconTheme.color!,
                                BlendMode.srcIn),
                          ),
                        ),
                      ),
                      if (Platform.isAndroid)
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              viewModel.shareFacebook(index);
                            },
                            icon: Icon(Icons.facebook,
                                color: Theme.of(context).iconTheme.color),
                          ),
                        ),
                      Flexible(
                        child: IconButton(
                          onPressed: () {
                            viewModel.sharePhoto(index);
                          },
                          icon: Icon(Icons.photo,
                              color: Theme.of(context).iconTheme.color),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          onPressed: () {
                            viewModel.showBinyAd();
                            viewModel.saveToGallery(index, context);
                          },
                          icon: Icon(Icons.download,
                              color: Theme.of(context).iconTheme.color),
                        ),
                      ),
                    ]),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => verticalSpace(20),
    );
  }
}
