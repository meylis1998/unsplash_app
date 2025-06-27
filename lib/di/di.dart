import 'package:dio_client_handler/dio_client_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_data_src/photo_data_src.dart';
import 'package:photo_repository/photo_repository.dart';

/// Global service locator
final injector = GetIt.instance;

/// Initialize Hive *and* all your services/boxes in one place
Future<void> initServices() async {
  await Hive.initFlutter();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  final favs = await Hive.openBox<String>('favorites');
  injector.registerSingleton<Box<String>>(favs, instanceName: 'favorites');

  // ─── Core Dependencies ────────────────────────────────────────────
  injector.registerLazySingleton<DioClientHandler>(() => DioClientHandler());

  // ─── Data Sources ─────────────────────────────────────────────────
  injector.registerLazySingleton<PhotoRemoteDataSrc>(() => PhotoRemoteDataSrc());

  // ─── Repositories ─────────────────────────────────────────────────
  injector.registerLazySingleton<PhotoRepository>(
    () => PhotoRepository(dataSrc: injector<PhotoRemoteDataSrc>()),
  );
}
