import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unsplash_app/di/di.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await Hive.initFlutter();

    final bookmarksBox = await Hive.openBox<String>('favorites');
    injector.registerSingleton<Box<String>>(bookmarksBox);

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory((await getTemporaryDirectory()).path),
    );

    await Future.wait([initServices()]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    runApp(await builder());
  }, (error, stackTrace) => log(error.toString(), stackTrace: stackTrace, name: 'ERROR'));
}
