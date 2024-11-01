import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/feelings/view_model/feeling_view_model.dart';
import 'package:happiness_jar/view/widgets/title_text.dart';

import '../../../widgets/subtitle_text.dart';
import '../model/FeelingsCategoriesModel.dart';

class FeelingsDropdownButton extends StatelessWidget {
  FeelingsDropdownButton(this.viewModel,{super.key});
  FeelingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: DropdownButton<FeelingsCategories>(
        hint: const TitleTextWidget(label: 'اختر شعورك؟',),
        value: viewModel.listOfFeelingsContent.isNotEmpty ? viewModel.listOfFeelingsCategories[viewModel.selectedFeeling!] : null,
        onChanged: (FeelingsCategories? newValue) {
          viewModel.setSelectedCategory(newValue?.id);
          viewModel.getListOfFeelingsContent(newValue?.id);
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
