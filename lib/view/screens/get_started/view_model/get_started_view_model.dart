import 'package:happiness_jar/consts/shared_preferences_constants.dart';

import '../../../../locator.dart';
import '../../../../services/shared_pref_services.dart';
import '../../base_view_model.dart';

class GetStartedViewModel extends BaseViewModel {
  final prefs = locator<SharedPrefServices>();

  void setDoneGetStarted() {
    prefs.saveBoolean(SharedPrefsConstants.GET_STARTED, true);
  }

}