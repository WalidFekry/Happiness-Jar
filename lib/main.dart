import 'package:flutter/material.dart';
import 'package:happiness_jar/happiness_jar_app.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  Provider.debugCheckInvalidValueType = null;
  runApp(easyLocalization(const HappinessJarApp()));
  }
