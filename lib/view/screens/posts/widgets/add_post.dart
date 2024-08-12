import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../helpers/spacing.dart';
import '../../../widgets/title_text.dart';
class AddPost extends StatelessWidget {
  const AddPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TitleTextWidget(label: "كُن إيجابياً 💙"),
        const Spacer(),
        Icon(IconlyLight.arrow_left,color: Theme.of(context).iconTheme.color,size: 30,),
        const Spacer(),
        IconButton(onPressed: (){}, icon: Icon(Icons.post_add,color: Theme.of(context).cardColor,size: 30,),),
        IconButton(onPressed: (){}, icon: Icon(Icons.history,color: Theme.of(context).cardColor,size: 30,),)
      ],
    );
  }
}
