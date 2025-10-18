import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/items/data/datasources/items_local_ds.dart';
import '../../features/items/data/datasources/items_remote_ds.dart';
import '../../features/items/data/repositories/items_repo_impl.dart';
import '../../features/items/domain/repositories/items_repository.dart';
import '../../features/items/domain/usecases/get_items_page.dart';
import '../../features/items/domain/usecases/refresh_items.dart';
import '../../features/items/presentation/cubit/items_cubit.dart';
import '../network/connectivity_guard.dart';
import '../network/dio_client.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initHive();
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<ConnectivityGuard>(() => ConnectivityGuard());

  sl.registerLazySingleton<LanguageService>(
    () => LanguageService(prefs: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<ThemeService>(
    () => ThemeService(prefs: sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  sl.registerLazySingleton<ItemsRemoteDataSource>(
    () => ItemsRemoteDataSourceImpl(
      dio: sl<Dio>(),
      connectivityGuard: sl<ConnectivityGuard>(),
    ),
  );

  sl.registerLazySingleton<ItemsLocalDataSource>(
    () => ItemsLocalDataSourceImpl(box: sl<Box<Map>>()),
  );

  sl.registerLazySingleton<ItemsRepository>(
    () => ItemsRepositoryImpl(
      remoteDataSource: sl<ItemsRemoteDataSource>(),
      localDataSource: sl<ItemsLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton(() => GetItemsPage(sl<ItemsRepository>()));
  sl.registerLazySingleton(() => RefreshItems(sl<ItemsRepository>()));

  sl.registerFactory(
    () => ItemsCubit(
      getItemsPage: sl<GetItemsPage>(),
      refreshItems: sl<RefreshItems>(),
      repository: sl<ItemsRepository>(),
    ),
  );
}

Future<void> _initHive() async {
  await Hive.initFlutter();

  final itemsBox = await Hive.openBox<Map>('items_cache');
  sl.registerLazySingleton<Box<Map>>(() => itemsBox);
}
