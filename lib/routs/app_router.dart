import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happiness_jar/routs/routing_data.dart';
import 'package:happiness_jar/routs/routs_names.dart';
import 'package:happiness_jar/view/screens/auth/view/register_screen.dart';
import 'package:happiness_jar/view/screens/categories/model/messages_categories_model.dart';
import 'package:happiness_jar/view/screens/categories/view/messages_categories_content.dart';
import 'package:happiness_jar/view/screens/fadfada/model/fadfada_model.dart';
import 'package:happiness_jar/view/screens/fadfada/view/add_fadfada_screen.dart';
import 'package:happiness_jar/view/screens/fadfada/view/fadfada_screen.dart';
import 'package:happiness_jar/view/screens/fadfada/view/view_fadfada_screen.dart';
import 'package:happiness_jar/view/screens/feelings/view/feelings_screen.dart';
import 'package:happiness_jar/view/screens/get_started/view/get_notification_screen.dart';
import 'package:happiness_jar/view/screens/get_started/view/get_started_screen.dart';
import 'package:happiness_jar/view/screens/home/view/home_screen.dart';
import 'package:happiness_jar/view/screens/posts/view/posts_user_screen.dart';
import 'package:happiness_jar/view/screens/profile/view/profile_screen.dart';

import '../view/screens/exit_app/view/exit_app_screen.dart';
import '../view/screens/fadfada/view/edit_fadfada_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var uriData = Uri.parse(settings.name!);

    debugPrint('settings.name ${settings.name}');

    var routingData = RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );

    switch (routingData.route) {
      case RouteName.HOME:
        return _getPageRoute(const HomeScreen(), settings);
      case RouteName.GET_STARTED:
        return _getPageRoute(const GetStartedScreen(), settings);
      case RouteName.GET_NOTIFICATION_SCREEN:
        return _getPageRoute(const GetNotificationScreen(), settings);
      case RouteName.REGISTER:
        return _getPageRoute(const RegisterScreen(), settings);
      case RouteName.PROFILE:
        return _getPageRoute(const ProfileScreen(), settings);
      case RouteName.POSTS_USER_SCREEN:
        return _getPageRoute(const PostsUserScreen(), settings);
      case RouteName.FEELINGS_SCREEN:
        return _getPageRoute(const FeelingsScreen(), settings);
      case RouteName.FADFADA_SCREEN:
        return _getPageRoute(const FadfadaScreen(), settings);
      case RouteName.ADD_FADFADA_SCREEN:
        return _getPageRoute(const AddFadfadaScreen(), settings);
      case RouteName.VIEW_FADFADA_SCREEN:
        var fadfadaArguments = settings.arguments as FadfadaModel;
        return _getPageRoute(
            ViewFadfadaScreen(
              fadfada: fadfadaArguments,
            ),
            settings);
      case RouteName.EDIT_FADFADA_SCREEN:
        var fadfadaArguments = settings.arguments as FadfadaModel;
        return _getPageRoute(
            EditFadfadaScreen(
              fadfadaModel: fadfadaArguments,
            ),
            settings);
      case RouteName.MESSAGES_CATEGORIES_CONTENT:
        var messagesCategoriesArguments =
            settings.arguments as MessagesCategories;
        return _getPageRoute(
            MessagesCategoriesContent(messagesCategoriesArguments,
                int.parse(routingData['index'].toString())),
            settings);
      default:
        return _getPageRoute(const ExitAppScreen(), settings);
    }
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget? child;
  final String? routeName;

  _FadeRoute({this.child, this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child!,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
