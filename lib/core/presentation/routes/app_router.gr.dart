// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../../../auth/presentation/authorization_screen.dart' as _i3;
import '../../../auth/presentation/sign_in_screen.dart' as _i2;
import '../../../splash.presentation/splash_screen.dart' as _i1;
import '../../../starred_repos.presentation/starred_repos_screen.dart' as _i4;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SplashScreen());
    },
    SignInScreenRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.SignInScreen());
    },
    AuthorizationScreenRoute.name: (routeData) {
      final args = routeData.argsAs<AuthorizationScreenRouteArgs>();
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.AuthorizationScreen(
              key: args.key,
              authorizationUrl: args.authorizationUrl,
              onAuthorizationCodeRedirectAttempt:
                  args.onAuthorizationCodeRedirectAttempt));
    },
    StarredRepoScreenRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.StarredRepoScreen());
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(SplashScreenRoute.name, path: '/'),
        _i5.RouteConfig(SignInScreenRoute.name, path: '/sign-in'),
        _i5.RouteConfig(AuthorizationScreenRoute.name, path: '/auth'),
        _i5.RouteConfig(StarredRepoScreenRoute.name, path: '/starred')
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashScreenRoute extends _i5.PageRouteInfo<void> {
  const SplashScreenRoute() : super(SplashScreenRoute.name, path: '/');

  static const String name = 'SplashScreenRoute';
}

/// generated route for
/// [_i2.SignInScreen]
class SignInScreenRoute extends _i5.PageRouteInfo<void> {
  const SignInScreenRoute() : super(SignInScreenRoute.name, path: '/sign-in');

  static const String name = 'SignInScreenRoute';
}

/// generated route for
/// [_i3.AuthorizationScreen]
class AuthorizationScreenRoute
    extends _i5.PageRouteInfo<AuthorizationScreenRouteArgs> {
  AuthorizationScreenRoute(
      {_i6.Key? key,
      required Uri authorizationUrl,
      required void Function(Uri) onAuthorizationCodeRedirectAttempt})
      : super(AuthorizationScreenRoute.name,
            path: '/auth',
            args: AuthorizationScreenRouteArgs(
                key: key,
                authorizationUrl: authorizationUrl,
                onAuthorizationCodeRedirectAttempt:
                    onAuthorizationCodeRedirectAttempt));

  static const String name = 'AuthorizationScreenRoute';
}

class AuthorizationScreenRouteArgs {
  const AuthorizationScreenRouteArgs(
      {this.key,
      required this.authorizationUrl,
      required this.onAuthorizationCodeRedirectAttempt});

  final _i6.Key? key;

  final Uri authorizationUrl;

  final void Function(Uri) onAuthorizationCodeRedirectAttempt;

  @override
  String toString() {
    return 'AuthorizationScreenRouteArgs{key: $key, authorizationUrl: $authorizationUrl, onAuthorizationCodeRedirectAttempt: $onAuthorizationCodeRedirectAttempt}';
  }
}

/// generated route for
/// [_i4.StarredRepoScreen]
class StarredRepoScreenRoute extends _i5.PageRouteInfo<void> {
  const StarredRepoScreenRoute()
      : super(StarredRepoScreenRoute.name, path: '/starred');

  static const String name = 'StarredRepoScreenRoute';
}
