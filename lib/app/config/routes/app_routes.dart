import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../home/view/home_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  // Top-level routes
  static const initial = '/';
  // Bottom Navigation routes
  static const home = '/home';
  static const bookmarks = '/bookmarks';

  // static final GoRoute _bookmarks = GoRoute(
  //   path: bookmarks,
  //   builder: (context, state) => const BookmarksView(),
  // );

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initial,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeView(),
        routes: [
          // GoRoute(
          //   path: 'bookmarks', // "/bookmarks"
          //   builder: (context, state) => const BookmarksView(),
          // ),
          // …any other nested tabs
        ],
      ),
    ],
  );
}
