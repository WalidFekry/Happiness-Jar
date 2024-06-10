import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  Provider.debugCheckInvalidValueType = null;
  runApp(easyLocalization(const MyApp()));
  }
