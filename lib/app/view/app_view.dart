import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:photo_data_src/photo_data_src.dart';
import 'package:photo_repository/photo_repository.dart';
import 'package:unsplash_app/favorites/cubit/favorites_cubit.dart';

import '../../di/di.dart';
import '../../home/bloc/home_bloc.dart';
import '../config/config.dart';

class Unsplash extends StatelessWidget {
  const Unsplash({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => PhotoRepository(dataSrc: injector<PhotoRemoteDataSrc>())),
      ],
      child: const UnsplashView(),
    );
  }
}

class UnsplashView extends StatelessWidget {
  const UnsplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc(photoRepository: context.read<PhotoRepository>())),
        BlocProvider(create: (context) => FavoritesCubit(injector<Box<String>>(instanceName: 'favorites'))),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ScreenUtilInit(
            designSize: Size(constraints.maxWidth, constraints.maxHeight),
            builder: (context, child) {
              return MaterialApp.router(
                title: 'Unsplash',
                theme: AppTheme().lightTheme,
                darkTheme: AppTheme().darkTheme,
                debugShowCheckedModeBanner: false,
                routeInformationProvider: AppRoutes.router.routeInformationProvider,
                routeInformationParser: AppRoutes.router.routeInformationParser,
                routerDelegate: AppRoutes.router.routerDelegate,
              );
            },
          );
        },
      ),
    );
  }
}
