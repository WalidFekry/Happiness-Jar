import 'package:get_it/get_it.dart';
import 'package:happiness_jar/view/screens/messages/view_model/messages_view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //locator.registerLazySingleton(() => NavigationService());

  //initSingleton();

  locator.registerFactory(() => MessagesViewModel());
}

// void initSingleton() {
//   locator<SharedPrefServices>();
// }
