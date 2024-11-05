
import 'di_ex.dart';

GetIt di = GetIt.instance;

Future<void> setupDi() async {
  /// Network services
  di.registerSingleton<Dio>(Dio());

  /// Helper
  di.registerSingleton(InternetConnectionHelper());

  /// Hive DataBase
  await Hive.initFlutter();

  /// DB Service
  // Home DataBase Service
  di.registerSingleton<HomeDataBaseService>(HomeDataBaseService());
  await di<HomeDataBaseService>().initDataBase();

  ///DB Provider
  di.registerSingleton(HomeDbProvider(baseService: di<HomeDataBaseService>()));

  /// Home Api Provider
  di.registerSingleton(HomeApiProvider(di<Dio>()));

  /// Repository
  // Home
  di.registerSingleton(
      HomeRepository(di<HomeDbProvider>(), di<HomeApiProvider>()));

  di.registerSingleton<HomeBloc>(HomeBloc(di<HomeRepository>()));
}
