import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../favorites/view/favorites_view.dart';
import '../../../home/view/home_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  // Top-level routes
  static const initial = '/';
  // Bottom Navigation routes
  static const home = '/home';
  static const favorites = '/favorites';
  static const photoView = '/photo_view';

  // static final GoRoute _bookmarks = GoRoute(
  //   path: bookmarks,
  //   builder: (context, state) => const BookmarksView(),
  // );

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initial,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeView()),
      GoRoute(path: favorites, builder: (context, state) => const FavoritesView()),
    ],
  );
}
