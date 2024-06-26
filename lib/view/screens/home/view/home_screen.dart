import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/locator.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/view/screens/home/view_model/home_view_model.dart';
import 'package:iconly/iconly.dart';

import '../../../../consts/shared_preferences_constants.dart';
import '../../../../services/assets_manager.dart';
import '../../../widgets/app_name_text.dart';
import '../../base_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController? controller;
  String? appBarTitle = "رسائل البرطمان";
  int selectedIndex = 0;

  @override
  void initState() {
    controller = PageController(initialPage: selectedIndex);
    setFirebaseMessaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(onModelReady: (viewModel) async {
      viewModel.getStarted =
          await viewModel.prefs.getBoolean(SharedPrefsConstants.GET_STARTED);
      viewModel.isLogin =
          await viewModel.prefs.getBoolean(SharedPrefsConstants.IS_LOGIN);
      if (!viewModel.getStarted) {
        locator<NavigationService>()
            .navigateToAndClearStack(RouteName.GET_STARTED);
        return;
      }
      if (!viewModel.isLogin) {
        locator<NavigationService>()
            .navigateToAndClearStack(RouteName.REGISTER);
        return;
      }
      viewModel.getUserData();
      viewModel.refreshToken();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.showGreetingDialog(context);
        viewModel.checkNotificationsPermission(context);
      });
    }, builder: (context, viewModel, child) {
      return Scaffold(
          appBar: AppBar(
            title: AppBarTextWidget(
              title: appBarTitle,
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                AssetsManager.iconAppBar,
                height: 50,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  locator<NavigationService>().navigateTo(RouteName.PROFILE);
                },
                child: Container(
                  height: 50,
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: viewModel.image != null
                          ? FileImage(viewModel.image!)
                          : const AssetImage(AssetsManager.userProfile)
                              as ImageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: PageView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            children: viewModel.screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
              controller?.jumpToPage(index);
              setAppBarTitle(index);
            },
            destinations: const [
              NavigationDestination(
                  selectedIcon: Icon(IconlyLight.home),
                  icon: Icon(IconlyBold.home),
                  label: "الرئيسية"),
              NavigationDestination(
                  selectedIcon: Icon(IconlyLight.notification),
                  icon: Icon(IconlyBold.notification),
                  label: "إشعارات"),
              NavigationDestination(
                  selectedIcon: Icon(IconlyLight.category),
                  icon: Icon(IconlyBold.category),
                  label: "الأقسام"),
              NavigationDestination(
                  selectedIcon: Icon(IconlyLight.heart),
                  icon: Icon(IconlyBold.heart),
                  label: "المفضلة"),
            ],
          ));
    });
  }

  setFirebaseMessaging() {
    Future.delayed(const Duration(milliseconds: 50), () {
      selectedIndex = 2;
      controller?.jumpToPage(selectedIndex);
      setAppBarTitle(selectedIndex);
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      // The app was closed and opened via notification
      if (kDebugMode) {
        print('onLaunch: Message clicked!');
      }
      });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // The app is in the foreground and you receive a notification
      if (kDebugMode) {
        print('onMessage: Message clicked!');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // The app is in the background and was opened via notification
      if (kDebugMode) {
        print('onMessageOpenedApp: Message clicked!');
      }
    });
  }

  void setAppBarTitle(int index) {
    switch (index) {
      case 0:
        appBarTitle = "رسائل البرطمان";
        break;
      case 1:
        appBarTitle = "إشعارات البرطمان";
        break;
      case 2:
        appBarTitle = "الأقسام";
        break;
      case 3:
        appBarTitle = "المفضلة";
        break;
      default:
        appBarTitle = "الرئيسية";
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
