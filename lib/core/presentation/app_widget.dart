import 'package:flutter/material.dart';
import 'package:github_repo_view/auth/application/auth_notifier.dart';
import 'package:github_repo_view/auth/presentation/sign_in_screen.dart';
import 'package:github_repo_view/auth/shared/providers.dart';
import 'package:github_repo_view/core/presentation/routes/app_router.gr.dart';
import 'package:hooks_riverpod/all.dart';

final initializationProvider = FutureProvider((ref) async {
  final authNotifier = ref.read(authNotifierProvider.notifier);
  await authNotifier.checkAndUpdateAuthStatus();
});

class AppWidget extends StatelessWidget {
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: initializationProvider,
      onChange: (context, value) {},
      child: ProviderListener<AuthState>(
        provider: authNotifierProvider,
        onChange: (context, state) {
          state.maybeMap(
            orElse: () {},
            authenticated: (_) {
              appRouter.pushAndPopUntil(
                const StarredRepoScreenRoute(),
                predicate: (route) => false,
              );
            },
            unauthenticated: (_) {
              appRouter.pushAndPopUntil(
                const SignInScreenRoute(),
                predicate: (route) => false,
              );
            },
          );
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: "REpo Viewer",
          routerDelegate: appRouter.delegate(),
          routeInformationParser: appRouter.defaultRouteParser(),
        ),
      ),
    );
  }
}
