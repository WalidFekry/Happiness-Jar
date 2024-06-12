import 'package:flutter/material.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:iconly/iconly.dart';

import '../../../../services/assets_manager.dart';
import '../../../widgets/app_name_text.dart';
import '../../categories/view/categories_screen.dart';
import '../../favorite/view/favorite_screen.dart';
import '../../messages/view/messages_screen.dart';
import '../../profile/view/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController controller;
  int selectedIndex = 0;
  String? appBarTitle = "الرئيسية";

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const MessagesScreen(),
      const CategoriesScreen(),
      const FavoriteScreen(),
      const ProfileScreen()
    ];
    return Scaffold(
        appBar: AppBar(
          title: AppBarTextWidget(
            title: appBarTitle,
          ),
          leading: GestureDetector(
            onTap: (){
              locator<NavigationService>().navigateTo(RouteName.PROFILE);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AssetsManager.iconAppBar),
            ),
          ),
        ),
        body: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;

            });
            controller.jumpToPage(selectedIndex);
            switch (index) {
              case 0:
                appBarTitle = "الرئيسية";
                break;
              case 1:
                appBarTitle = "الأقسام";
                break;
              case 2:
                appBarTitle = "المفضلة";
                break;
              case 3:
                appBarTitle = "الحساب";
                break;
              default:
                appBarTitle = "الرئيسية";
            }
          },

          destinations: const [
            NavigationDestination(
                selectedIcon: Icon(IconlyLight.home),
                icon: Icon(IconlyBold.home),
                label: "الرئيسية"),
            NavigationDestination(
                selectedIcon: Icon(IconlyLight.category),
                icon: Icon(IconlyBold.category),
                label: "الأقسام"),
            NavigationDestination(
                selectedIcon: Icon(IconlyLight.heart),
                icon: Icon(IconlyBold.heart),
                label: "المفضلة"),
            NavigationDestination(
                selectedIcon: Icon(IconlyLight.profile),
                icon: Icon(IconlyBold.profile),
                label: "الحساب"),
          ],
        ));
  }
}
