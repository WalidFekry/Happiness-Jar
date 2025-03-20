import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../constants/assets_manager.dart';
import '../../services/locator.dart';
import '../../services/navigation_service.dart';
import '../screens/home/widgets/share_app_dialog.dart';
import 'app_bar_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const CustomAppBar({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AppBarTextWidget(title: title),
      leading: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: GestureDetector(
          onTap: (){
            ShareAppDialog.show(context);
          },
          child: Image.asset(
            AssetsManager.appLogoNoTitle,
            fit: BoxFit.contain,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            locator<NavigationService>().goBack();
          },
          icon: Icon(
            IconlyLight.arrow_left_2,
            size: 35,
            color: Theme.of(context).iconTheme.color,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}