import 'package:flutter/material.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/subtitle_text.dart';
import '../model/FeelingsCategoriesModel.dart';
import '../view_model/feelings_view_model.dart';

class FeelingsDropdownButton extends StatelessWidget {
  FeelingsDropdownButton(this.viewModel,{super.key});
  FeelingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: DropdownButton<FeelingsCategories>(
        hint: const TitleTextWidget(label: 'اختر شعورك؟',),
        value: viewModel.listOfFeelingsContent.isNotEmpty ? viewModel.listOfFeelingsCategories[viewModel.selectedFeeling!] : null,
        onChanged: (FeelingsCategories? newValue) async {
          viewModel.setSelectedCategory(newValue?.id);
          await viewModel.getListOfFeelingsContent(newValue?.id);
          if (viewModel.listOfFeelingsContent.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(
                  backgroundColor:
                  Theme.of(context).cardColor,
                  message: "تحقق من اتصالك بالانترنت",
                  icon: Icon(
                    Icons.error,
                    color:
                    Theme.of(context).iconTheme.color,
                    size: 50,
                  ),
                ),
              );
            });
          }
        },
        items: viewModel.listOfFeelingsCategories.map<DropdownMenuItem<FeelingsCategories>>((FeelingsCategories category) {
          return DropdownMenuItem<FeelingsCategories>(
            value: category,
            child: SubtitleTextWidget(label: category.title!,),
          );
        }).toList(),
      ),
    );
  }
}
