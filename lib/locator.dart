import 'package:get_it/get_it.dart';
import 'package:happiness_jar/db/app_database.dart';
import 'package:happiness_jar/services/api_service.dart';
import 'package:happiness_jar/services/navigation_service.dart';
import 'package:happiness_jar/view/screens/categories/view_model/categories_view_model.dart';
import 'package:happiness_jar/view/screens/favorite/view_model/favorite_view_model.dart';
import 'package:happiness_jar/view/screens/messages/view_model/messages_view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => AppDatabase());
  locator.registerLazySingleton(() => NavigationService());

  //initSingleton();

  locator.registerFactory(() => MessagesViewModel());
  locator.registerFactory(() => CategoriesViewModel());
  locator.registerFactory(() => FavoriteViewModel());
}

// void initSingleton() {
//   locator<SharedPrefServices>();
// }
