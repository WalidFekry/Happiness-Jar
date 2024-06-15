import 'package:flutter/material.dart';
import 'package:happiness_jar/view/screens/base_screen.dart';
import 'package:happiness_jar/view/screens/categories/view_model/categories_view_model.dart';
import 'package:happiness_jar/view/widgets/subtitle_text.dart';

import 'package:iconly/iconly.dart';

import '../../../../services/assets_manager.dart';
import '../../../widgets/app_name_text.dart';
import '../../../widgets/title_text.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CategoriesViewModel>(
      onModelReady: (viewModel){
        viewModel.getCategories();
      },
      builder: (context,viewModel, child){
        return Scaffold(
          body:
          viewModel.list.isNotEmpty ?
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListView.builder(itemCount: viewModel.list.length,itemBuilder: (context,index){
              return InkWell(
                onTap: (){
                  viewModel.navigateToContent(index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey,width: 1),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(22),bottomLeft:Radius.circular(22))
                    ),
                    child: ListTile(
                      title: Center(child: SubtitleTextWidget(label: viewModel.list[index].title)),
                      leading: Icon(Icons.tag,color: Theme.of(context).cardColor),
                      trailing: Icon(IconlyLight.arrow_left,color: Theme.of(context).iconTheme.color),
                    ),
                  ),
                ),
              );
            }),
          ): Center(
          child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).iconTheme.color,
          strokeAlign: 5,
          strokeWidth: 5,
        ),
        ),
        );
      }
    );
  }
}
