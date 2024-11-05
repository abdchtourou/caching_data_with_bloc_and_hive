import 'package:caching_data_with_bloc_and_hive/core/dependency_injection/di.dart';
import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupDi();

  runApp(const App());
}

