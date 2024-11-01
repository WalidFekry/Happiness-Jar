import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_jar/view/screens/feelings/view_model/feeling_view_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../constants/assets_manager.dart';
import '../../../../helpers/spacing.dart';
import '../../../widgets/content_text.dart';

class FeelingsContentListView extends StatelessWidget {
  FeelingsContentListView(this.viewModel, {super.key});

  FeelingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: viewModel.listOfFeelingsContent.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: GestureDetector(
              onTap: () {
                // viewModel.showBinyAd();
                // showDialog(
                //   context: context,
                //   builder: (context) {
                //     return ShowPostDialog(viewModel, index);
                //   },
                // );
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        AssetsManager.quote,
                        width: 30,
                        height: 30,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).cardColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ContentTextWidget(
                        label: viewModel.listOfFeelingsContent[index].body,
                        textAlign: TextAlign.center,
                      )),
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
                              // viewModel.showBinyAd();
                              // viewModel.copyMessage(index);
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
                              // viewModel.shareMessage(index);
                            },
                            icon: Icon(Icons.share,
                                color: Theme.of(context).iconTheme.color),
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              // viewModel.shareWhatsapp(index);
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
                                // viewModel.shareFacebook(index);
                              },
                              icon: Icon(Icons.facebook,
                                  color: Theme.of(context).iconTheme.color),
                            ),
                          ),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              // viewModel.sharePhoto(index, context);
                            },
                            icon: Icon(Icons.photo,
                                color: Theme.of(context).iconTheme.color),
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              // viewModel.showBinyAd();
                              // viewModel.saveToGallery(index, context);
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
      ),
    );
  }
}
