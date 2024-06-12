import 'package:flutter/material.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/view/screens/home/view_model/home_view_model.dart';
import 'package:iconly/iconly.dart';

import '../../../../services/assets_manager.dart';
import '../../../widgets/app_name_text.dart';
import '../../base_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
        onModelReady: (viewModel){
          viewModel.isUserLogin();
          viewModel.setController();
    },
    builder: (context,viewModel, child){
      return Scaffold(
          appBar: AppBar(
            title: AppBarTextWidget(
              title: viewModel.appBarTitle,
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
            controller: viewModel.controller,
            physics: const NeverScrollableScrollPhysics(),
            children: viewModel.screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: viewModel.selectedIndex,
            onDestinationSelected: (index) {
              viewModel.jumpToPage(index);
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
    });
  }
}
