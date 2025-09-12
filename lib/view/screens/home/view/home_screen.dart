import 'package:badges/badges.dart' as badges;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/constants/local_notification_constants.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/services/local_notification_service.dart';
import 'package:happiness_jar/services/locator.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/view/screens/home/view_model/home_view_model.dart';
import 'package:happiness_jar/view/screens/home/widgets/share_app_dialog.dart';
import 'package:happiness_jar/view/screens/posts/view/posts_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/app_constants.dart';
import '../../../../constants/assets_manager.dart';
import '../../../../constants/shared_preferences_constants.dart';
import '../../../widgets/app_bar_text.dart';
import '../../base_screen.dart';
import '../../categories/view/categories_screen.dart';
import '../../favorite/view/favorite_screen.dart';
import '../../messages/view/messages_screen.dart';
import '../../notifications/view/notifications_screen.dart';
import '../widgets/today_advice_dialog.dart';
import 'more_main_sections_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController? controller;
  String appBarTitle = "رسائل البرطمان";
  int selectedIndex = 0;

  List<Widget> screens = [
    const MessagesScreen(),
    const NotificationsScreen(),
    const CategoriesScreen(),
    const PostsScreen(),
    const FavoriteScreen(),
    const MoreMainSectionsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: selectedIndex);
    setFirebaseMessaging();
    setLocalNotification();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(onModelReady: (viewModel) async {
      final bool isLogin =
          await viewModel.prefs.getBoolean(SharedPrefsConstants.isLogin);
      if (!isLogin) {
        locator<NavigationService>()
            .navigateToAndClearStack(RouteName.REGISTER);
        return;
      }
      viewModel.showOpenAd(context);
      viewModel.getUserData();
      viewModel.getNotificationsCount();
      viewModel.refreshToken();
      viewModel.getTodayAdvice();
      viewModel.showInAppReview();
      viewModel.checkNotificationsPermission(context);
    }, onFinish: (viewModel) {
      viewModel.destroy();
    }, builder: (context, viewModel, child) {
      return Scaffold(
          appBar: AppBar(
            title: AppBarTextWidget(
              title: appBarTitle,
            ),
            leading: viewModel.giftBoxMessage == null
                ? GestureDetector(
                    onTap: () {
                      ShareAppDialog.show(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image.asset(AssetsManager.appLogoNoTitle,
                          fit: BoxFit.contain),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      TodayAdviceDialog.show(context, viewModel.giftBoxMessage);
                      setState(() {
                        viewModel.giftBoxMessage = null;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child:
                          Image.asset(AssetsManager.giftBox, fit: BoxFit.cover),
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
            children: screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              resetCountsIfNeeded(index, viewModel);
              setAppBarTitle(index);
              setState(() {
                selectedIndex = index;
              });
              controller?.jumpToPage(index);
            },
            destinations: [
              const NavigationDestination(
                  selectedIcon: Icon(IconlyLight.home),
                  icon: Icon(IconlyBold.home),
                  label: "الرسائل"),
              NavigationDestination(
                  selectedIcon: const Icon(IconlyLight.notification),
                  icon: badges.Badge(
                    showBadge:
                        viewModel.newNotificationsCount == 0 ? false : true,
                    badgeContent:
                        Text(viewModel.newNotificationsCount.toString()),
                    child: const Icon(IconlyBold.notification),
                  ),
                  label: "الإشعارات"),
              const NavigationDestination(
                  selectedIcon: Icon(IconlyLight.category),
                  icon: Icon(IconlyBold.category),
                  label: "الأقسام"),
              NavigationDestination(
                  selectedIcon: const Icon(IconlyLight.paper),
                  icon: badges.Badge(
                    showBadge: viewModel.newPostsCount == 0 ? false : true,
                    badgeContent: Text(viewModel.newPostsCount.toString()),
                    child: const Icon(IconlyBold.paper),
                  ),
                  label: "الإقتباسات"),
              const NavigationDestination(
                  selectedIcon: Icon(IconlyLight.heart),
                  icon: Icon(IconlyBold.heart),
                  label: "المفضلة"),
              const NavigationDestination(
                  selectedIcon: Icon(IconlyLight.more_circle),
                  icon: Icon(IconlyBold.more_circle),
                  label: "المزيد"),
            ],
          ));
    });
  }

  void resetCountsIfNeeded(int index, HomeViewModel viewModel) {
    if (index == 1 && viewModel.newNotificationsCount != 0) {
      viewModel.newNotificationsCount = 0;
      viewModel.saveNotificationsCountLocal("notifications");
    } else if (index == 3 && viewModel.newPostsCount != 0) {
      viewModel.newPostsCount = 0;
      viewModel.saveNotificationsCountLocal("posts");
    }
  }

  void setFirebaseMessaging() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      // The app was closed and opened via notification
      if (message != null) {
        checkMessagePayload(message);
      }
      if (kDebugMode) {
        print('onLaunch: Message clicked!');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // The app is in the foreground and you receive a notification
      final clickAction = message.data["click_action"];
      final actionsMap = {
        "rate": () => rateApp(),
        "openUrl": () {
          final url = message.data["url"];
          if (url != null) openUrl(url);
        },
      };
      // Execute the corresponding action based on click_action
      actionsMap[clickAction]?.call();
      // Show local notification if no specific action is matched
      if (!actionsMap.containsKey(clickAction)) {
        if (clickAction == null) return;
        final localNotificationService = locator<LocalNotificationService>();
        localNotificationService.showNotificationFromFCM(message);
      }
      if (kDebugMode) {
        print('onMessage: Message clicked!');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // The app is in the background and was opened via notification
      checkMessagePayload(message);
      if (kDebugMode) {
        print('onMessageOpenedApp: Message clicked!');
      }
    });
  }

  void checkMessagePayload(RemoteMessage message) {
    final clickAction = message.data["click_action"];
    final actionsMap = {
      "home": () => jumpToPage(0),
      "notification": () => jumpToPage(1),
      "categories": () => jumpToPage(2),
      "posts": () => jumpToPage(3),
      "favorite": () => jumpToPage(4),
      "feelings": () => navigateToScreen(RouteName.FEELINGS_SCREEN),
      "fadfada": () => navigateToScreen(RouteName.FADFADA_SCREEN),
      "rate": () => rateApp(),
      "openUrl": () {
        final url = message.data["url"];
        if (url != null) openUrl(url);
      },
    };

    // Execute the corresponding action based on the click_action
    actionsMap[clickAction]?.call();
  }

  void jumpToPage(int selectIndex) {
    Future.delayed(const Duration(milliseconds: 100), () {
      setAppBarTitle(selectIndex);
      setState(() {
        selectedIndex = selectIndex;
      });
      controller?.jumpToPage(selectIndex);
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
        appBarTitle = "الإقتباسات";
        break;
      case 4:
        appBarTitle = "المفضلة";
        break;
      case 5:
        appBarTitle = "المزيد ..";
        break;
      default:
        appBarTitle = "رسائل البرطمان";
    }
  }

  void rateApp() {
    final InAppReview inAppReview = InAppReview.instance;
    inAppReview.openStoreListing(appStoreId: AppConstants.appStoreId);
  }

  @override
  void dispose() {
    controller?.dispose();
    streamController.close();
    super.dispose();
  }

  void setLocalNotification() {
    streamController.stream.listen((notificationResponse) {
      final payload = notificationResponse?.payload;

      if (payload == LocalNotificationConstants.notificationPayload) {
        jumpToPage(1);
      } else if (payload ==
          LocalNotificationConstants.birthdayNotificationPayload) {

      } else {
        _handleNotificationAction(payload);
      }
    });
  }

  void _handleNotificationAction(String? action) {
    final actionsMap = {
      "home": () => jumpToPage(0),
      "notification": () => jumpToPage(1),
      "categories": () => jumpToPage(2),
      "posts": () => jumpToPage(3),
      "favorite": () => jumpToPage(4),
      "feelings": () => navigateToScreen(RouteName.FEELINGS_SCREEN),
      "fadfada": () => navigateToScreen(RouteName.FADFADA_SCREEN),
    };

    actionsMap[action]?.call();
  }

  Future<void> openUrl(String getUrl) async {
    final Uri url = Uri.parse(getUrl);

    // Try to open the URL, first in the browser, if not possible, open externally
    final success = await canLaunchUrl(url);
    if (success) {
      launchUrl(url);
    } else {
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void navigateToScreen(String routeName) {
    locator<NavigationService>().navigateTo(routeName);
  }
}
