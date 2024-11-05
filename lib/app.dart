import 'package:caching_data_with_bloc_and_hive/core/dependency_injection/di_ex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/theme/app_theme.dart';
import 'core/dependency_injection/di.dart';
import 'features/home/presentation/page/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: BlocProvider<HomeBloc>(
        create: (context) => di<HomeBloc>()..add(HomeCallProductsEvent()),
        child: HomePage(),
      ),
    );
  }
}