import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constants/assets_manager.dart';
import '../../../widgets/content_text.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';
import '../view_model/feelings_view_model.dart';

class ShowFeelingsContentDialog extends StatelessWidget {
  const ShowFeelingsContentDialog(this.viewModel, this.index, {super.key});

  final FeelingsViewModel viewModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: [
          TitleTextWidget(
              label: "${viewModel.listOfFeelingsContent[index].title}",
              fontSize: 18),
          const Spacer(),
          IconButton(
            onPressed: () => viewModel.shareMessage(index),
            icon: Icon(
              Icons.share,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          IconButton(
            onPressed: () {
              viewModel.copyMessage(index);
            },
            icon: Icon(
              CupertinoIcons.doc_on_clipboard_fill,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetsManager.messageJar,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          Flexible(
            child: ContentTextWidget(
                label: viewModel.listOfFeelingsContent[index].body,
                textAlign: TextAlign.center),
          ),
        ],
      ),
      actions: [
        Center(
          child: TextButton(
              style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Theme.of(context).iconTheme.color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                viewModel.goBack();
              },
              child: SubtitleTextWidget(
                label: "اغلاق",
                color: Theme.of(context).primaryColor,
                fontSize: 18,
              )),
        ),
      ],
    );
  }
}
