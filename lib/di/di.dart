import 'package:dio_client_handler/dio_client_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Global service locator
final injector = GetIt.instance;

/// Initialize Hive *and* all your services/boxes in one place
Future<void> initServices() async {
  // ─── Hive Setup ────────────────────────────────────────────────────
  await Hive.initFlutter();

  // Bookmarks box, named "bookmarks"
  final favs = await Hive.openBox<String>('bookmarks');
  injector.registerSingleton<Box<String>>(favs, instanceName: 'bookmarks');

  // 2) cache
  final cache = await Hive.openBox<String>('characters_cache');
  injector.registerSingleton<Box<String>>(cache, instanceName: 'cache');

  // ─── Core Dependencies ────────────────────────────────────────────
  injector.registerLazySingleton<DioClientHandler>(() => DioClientHandler());

  // ─── Data Sources ─────────────────────────────────────────────────
  // injector.registerLazySingleton<CharacterRemoteDataSrc>(
  //   () =>
  //       CharacterRemoteDataSrc(dioClientHandler: injector<DioClientHandler>()),
  // );

  // ─── Repositories ─────────────────────────────────────────────────
  // injector.registerLazySingleton<CharacterRepo>(
  //   () => CharacterRepo(dataSrc: injector<CharacterRemoteDataSrc>()),
  // );
}
