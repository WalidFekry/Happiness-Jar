import 'package:get_it/get_it.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/services/ads_service.dart';
import 'package:happiness_jar/services/api_service.dart';
import 'package:happiness_jar/services/local_notification_service.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/services/shared_pref_services.dart';
import 'package:happiness_jar/view/screens/auth/view_model/register_view_model.dart';
import 'package:happiness_jar/view/screens/categories/view_model/categories_view_model.dart';
import 'package:happiness_jar/view/screens/favorite/view_model/favorite_view_model.dart';
import 'package:happiness_jar/view/screens/home/view_model/home_view_model.dart';
import 'package:happiness_jar/view/screens/home/widgets/greeting_dialog.dart';
import 'package:happiness_jar/view/screens/messages/view_model/messages_view_model.dart';
import 'package:happiness_jar/view/screens/notifications/view_model/notifications_view_model.dart';
import 'package:happiness_jar/view/screens/posts/view_model/posts_view_model.dart';
import 'package:happiness_jar/view/screens/profile/view_model/profile_view_model.dart';

import '../view/screens/feelings/view_model/feelings_view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<SharedPrefServices>(SharedPrefServices());
  locator.registerSingleton<ApiService>(ApiService());
  locator.registerSingleton<GreetingDialog>(GreetingDialog());
  locator.registerSingleton<AdsService>(AdsService());
  locator.registerSingleton<LocalNotificationService>(LocalNotificationService());

  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => CategoriesViewModel());
  locator.registerLazySingleton(() => FavoriteViewModel());
  locator.registerLazySingleton(() => AppDatabase());
  locator.registerLazySingleton(() => FeelingsViewModel());

  locator.registerFactory(() => RegisterViewModel());
  locator.registerFactory(() => MessagesViewModel());
  locator.registerFactory(() => HomeViewModel());
  locator.registerFactory(() => NotificationsViewModel());
  locator.registerFactory(() => ProfileViewModel());
  locator.registerFactory(() => PostsViewModel());
}