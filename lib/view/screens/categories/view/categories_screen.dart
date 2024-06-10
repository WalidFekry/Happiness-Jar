import 'package:flutter/material.dart';

import 'package:iconly/iconly.dart';

import '../../../../services/assets_manager.dart';
import '../../../widgets/app_name_text.dart';
import '../../../widgets/title_text.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const AppBarTextWidget(
         title: "أقسام الرسائل",
       ),
       leading: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Image.asset(AssetsManager.iconAppBar),
       ),
     ),
     body: ListView.builder(itemCount: 15,itemBuilder: (context,index){
       return Padding(
         padding: const EdgeInsets.all(8.0),
         child: Container(
           decoration: BoxDecoration(
             border: Border.all(color: Theme.of(context).iconTheme.color!,width: 1),
             borderRadius: const BorderRadius.only(topLeft: Radius.circular(22),bottomLeft:Radius.circular(22))
           ),
           child: ListTile(
             title: const Center(child: TitleTextWidget(label: "الحمد لله",fontFamily: "avenir_medium",)),
             leading: Icon(Icons.tag,color: Theme.of(context).cardColor),
             trailing: Icon(IconlyLight.arrow_left,color: Theme.of(context).iconTheme.color),
           ),
         ),
       );
     }),
   );
  }
}
