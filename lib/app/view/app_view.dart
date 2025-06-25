import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/config.dart';

class Unsplash extends StatelessWidget {
  const Unsplash({super.key});

  @override
  Widget build(BuildContext context) {
    // return MultiRepositoryProvider(
    //   providers: [
    //     RepositoryProvider(
    //       create: (context) =>
    //           CharacterRepo(dataSrc: injector<CharacterRemoteDataSrc>()),
    //     ),
    //   ],
    //   child: const UnsplashView(),
    // );

    return const UnsplashView();
  }
}

class UnsplashView extends StatelessWidget {
  const UnsplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ScreenUtilInit(
          designSize: Size(constraints.maxWidth, constraints.maxHeight),
          builder: (context, child) {
            return MaterialApp.router(
              title: 'Unsplash',
              debugShowCheckedModeBanner: false,
              routeInformationProvider:
                  AppRoutes.router.routeInformationProvider,
              routeInformationParser: AppRoutes.router.routeInformationParser,
              routerDelegate: AppRoutes.router.routerDelegate,
            );
          },
        );
      },
    );
  }
}
