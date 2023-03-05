import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:github_repo_view/auth/presentation/authorization_screen.dart';
import 'package:github_repo_view/auth/shared/providers.dart';
import 'package:github_repo_view/core/presentation/routes/app_router.gr.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    MdiIcons.github,
                    size: 150,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "welcome to\nRepo Viewer",
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read(authNotifierProvider.notifier).signIn(
                        (authorizationUrl) {
                          final completer = Completer<Uri>();
                          AutoRouter.of(context).push(
                            AuthorizationScreenRoute(
                              authorizationUrl: authorizationUrl,
                              onAuthorizationCodeRedirectAttempt: (redirectedUrl) {
                                completer.complete(redirectedUrl);
                              },
                            ),
                          );
                          return completer.future;
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    child: const Text("Sign In"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
