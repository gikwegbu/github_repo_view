import 'package:auto_route/annotations.dart';
import 'package:github_repo_view/auth/presentation/authorization_screen.dart';
import 'package:github_repo_view/auth/presentation/sign_in_screen.dart';
import 'package:github_repo_view/splash.presentation/splash_screen.dart';
import 'package:github_repo_view/starred_repos.presentation/starred_repos_screen.dart';

@MaterialAutoRouter(
  routes: [
    MaterialRoute(page: SplashScreen, initial: true),
    MaterialRoute(page: SignInScreen, path: '/sign-in'),
    MaterialRoute(page: AuthorizationScreen, path: '/auth'),
    MaterialRoute(page: StarredRepoScreen, path: '/starred'),
  ],
)
// You can't just call it AppRouter, use $
class $AppRouter {}
