import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/app_colors.dart';
import 'package:happiness_jar/view/screens/fadfada/view_model/fadfada_view_model.dart';
import 'package:happiness_jar/view/widgets/content_text.dart';

import '../../../../constants/lists_constants.dart';
import '../../../../enums/screen_state.dart';
class FadfadaCategories extends StatelessWidget {
  const FadfadaCategories({super.key, required this.viewModel});

  final FadfadaViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fadfadaCategories.length,
        itemBuilder: (context, index) {
          final category = fadfadaCategories[index];
          return GestureDetector(
            onTap: () {
              viewModel.selectedCategory = category;
              viewModel.setState(ViewState.Idle);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: viewModel.selectedCategory == category
                    ? Theme.of(context).cardColor
                    : AppColors.gray300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ContentTextWidget(
                fontSize: 16,
                label: category,
                color: viewModel.selectedCategory == category ? Colors.white
                    : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
