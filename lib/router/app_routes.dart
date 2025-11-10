import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/splash_screen.dart';


class AppRoute {
  // Splash
  static String splash = 'splash';

}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      // final loggedIn = token != null;
      // final loc = state.matchedLocation;
      //
      // if (!loggedIn && loc != '/login') return '/login';
      // if (loggedIn && loc == '/login') return '/home';
      // return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.splash,
        builder: (BuildContext context, GoRouterState state) {
          return SplashScreen();
        },
      ),
    ],
  );
});



