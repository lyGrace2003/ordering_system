import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ordering_system/auth/authcontroller.dart';
import 'package:ordering_system/screens/customer/home_screen.dart';
import 'package:ordering_system/screens/login_screen.dart';
import 'package:ordering_system/screens/register_screen.dart';

class GlobalRouter{
  static void initialize() {
    GetIt.instance.registerSingleton<GlobalRouter>(GlobalRouter());
  }

  // Static getter to access the instance through GetIt
  static GlobalRouter get instance => GetIt.instance<GlobalRouter>();

  static GlobalRouter get I => GetIt.instance<GlobalRouter>();

  late GoRouter router;
  late GlobalKey<NavigatorState> _rootNavigatorKey;
  late GlobalKey<NavigatorState> _shellNavigatorKey;

  FutureOr<String?> handleRedirect(
      BuildContext context, GoRouterState state) async {
        if (AuthController.I.state == AuthState.authenticated) {
          if (state.matchedLocation == Loginscreen.route) {
            return CustomerHomeScreen.route;
          }
          if (state.matchedLocation == RegisterScreen.route) {
            return CustomerHomeScreen.route;
          }
          return null;
        }
        if (AuthController.I.state != AuthState.authenticated) {
          if (state.matchedLocation == Loginscreen.route) {
            return null;
          }
          if (state.matchedLocation == RegisterScreen.route) {
            return null;
          }
          return Loginscreen.route;
        }
    return null;
  }

  GlobalRouter() {
     _rootNavigatorKey = GlobalKey<NavigatorState>();
    _shellNavigatorKey = GlobalKey<NavigatorState>();
    router = GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: Loginscreen.route,
        redirect: handleRedirect,
        refreshListenable: AuthController.I,
        routes: [
          GoRoute(
             parentNavigatorKey: _rootNavigatorKey,
              path: Loginscreen.route,
              name: Loginscreen.name,
              builder: (context, _) {
                return const Loginscreen();
              },
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
              path: RegisterScreen.route,
              name: RegisterScreen.name,
              builder: (context, _) {
                return const RegisterScreen();
              }
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: CustomerHomeScreen.route,
            name: CustomerHomeScreen.name,
            builder: (context, _){
              return const CustomerHomeScreen();
            }
          ),
        ]
    );
  }
}