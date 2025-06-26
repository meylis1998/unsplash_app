import 'package:dio_client_handler/dio_client_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_data_src/photo_data_src.dart';
import 'package:photo_repository/photo_repository.dart';

/// Global service locator
final injector = GetIt.instance;

/// Initialize Hive *and* all your services/boxes in one place
Future<void> initServices() async {
  // ───   Hive Setup ────────────────────────────────────────────────────
  await Hive.initFlutter();

  // Bookmarks box, named "bookmarks"
  final favs = await Hive.openBox<String>('bookmarks');
  injector.registerSingleton<Box<String>>(favs, instanceName: 'bookmarks');

  // ─── Core Dependencies ────────────────────────────────────────────
  injector.registerLazySingleton<DioClientHandler>(() => DioClientHandler());

  // ─── Data Sources ─────────────────────────────────────────────────
  injector.registerLazySingleton<PhotoRemoteDataSrc>(
    () => PhotoRemoteDataSrc(dioClientHandler: injector<DioClientHandler>()),
  );

  // ─── Repositories ─────────────────────────────────────────────────
  injector.registerLazySingleton<PhotoRepository>(
    () => PhotoRepository(dataSrc: injector<PhotoRemoteDataSrc>()),
  );
}
