import 'package:flutter/material.dart';
import 'package:happiness_jar/happiness_jar_app.dart';
import 'package:home_widget/home_widget.dart';
import 'package:happiness_jar/services/widget_service.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'update_message') {
    await WidgetService.handleWidgetAction(uri);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  
  HomeWidget.registerInteractivityCallback(backgroundCallback);
  
  Provider.debugCheckInvalidValueType = null;
  final getStarted = await checkFirstOpen();
  runApp(easyLocalization(HappinessJarApp(getStarted)));
  }
