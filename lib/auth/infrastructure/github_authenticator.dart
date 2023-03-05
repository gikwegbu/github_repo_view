import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_repo_view/auth/domain/auth_failure.dart';
import 'package:github_repo_view/auth/infrastructure/credentials_storage/credentials_storage.dart';
import 'package:github_repo_view/core/infrastructure/dio_extensions.dart';
import 'package:github_repo_view/core/shared/encoders.dart';
import 'package:oauth2/oauth2.dart';
import 'package:http/http.dart' as http;

class GithubOAuthHttpClient extends http.BaseClient {
  /// We are creating our own GithubOAuthHttpClient, because we need to format the response
  /// we'd be getting from github, instead of a urlEncoded format, we'd get
  /// a Json format.
  final httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return httpClient.send(request);
  }
}

class GithubAuthenticator {
  final CredentialsStorage _credentialsStorage;
  final Dio _dio;

  GithubAuthenticator(this._credentialsStorage, this._dio);

  static const clientId = "5468089d6bgik04b4a433f5";
  static const clientSecret = "08454dd2e51fcf2545ea9wegbu5e0fc6561a0da5dd316";
  static const scopes = ["read:user", "repo"];
  static final authorizationEndpoint =
      Uri.parse("https://github.com/login/oauth/authorize");
  static final tokenEndpoint =
      Uri.parse("https://github.com/login/oauth/access_token");
  static final revocationEndpoint =
      Uri.parse("https://api.github.com/applications/$clientId/token");
  static final redirectUrl = Uri.parse("http://localhost:3000/callback");

  /// The web can use the redirectUrl, but for mobile,
  /// We will intercept it before the url is launched, and take the queryParam passed back through it.

  Future<Credentials?> getSignedInCredentials() async {
    try {
      final storedCredentials = await _credentialsStorage.read();
      // Implementing refreshToken and accessToken.
      // This is not required in Github auth, but other api might require it.
      if (storedCredentials != null) {
        if (storedCredentials.canRefresh && storedCredentials.isExpired) {
          // TODO: refresh
          final failureOrCredentials = await refreshToken(storedCredentials);
          // B fold<B>(B Function(AuthFailure) ifLeft, B Function(Credentials) ifRight)  Containing class: Either
          // Type: FutureOr<Credentials?> Function(FutureOr<Credentials?> Function(AuthFailure), FutureOr<Credentials?> Function(Credentials)


          /// The refreshToken is configured this way
          /// Future<Either<AuthFailure, Credentials>> refreshToken(Credentials credentials)
          /// now using fold, means, if the AuthFailure occurs, then we return null, meaning user was not authenticated
          /// Else, if the right part has a value, we return it instead
          return failureOrCredentials.fold((l) => null, (r) => r);
        }
      }
      return storedCredentials;
    } on PlatformException {
      return null; // we can actually put this in the secure_credentials_storage.dart
    }
  }

  // Here, since the getSignedInCredentials returns Credentials
  /// I.e if it's null, means user has not signed in
  /// if it's not null, the user has signed in
  Future<bool> isSignedIn() =>
      getSignedInCredentials().then((credentials) => credentials != null);

  AuthorizationCodeGrant createGrant() => AuthorizationCodeGrant(
        clientId,
        authorizationEndpoint,
        tokenEndpoint,
        secret: clientSecret,
        httpClient: GithubOAuthHttpClient(),
      );

  Uri getAuthorizationUrl(AuthorizationCodeGrant grant) {
    return grant.getAuthorizationUrl(redirectUrl, scopes: scopes);
  }

  /// Unit is just same as void,
  /// i.e, Future<void>
  /// but since we want to transfer exceptions to AuthFailures,
  /// we include the Unit
  Future<Either<AuthFailure, Unit>> handleAuthorizationResponse(
      AuthorizationCodeGrant grant, Map<String, String> queryParams) async {
    /// This queryParams contains the authorizationUrl which has the
    /// accessToken I need to authenticate the user for other Github actions.
    /// But grant.handleAuthorizationResponse below has a return type of httpClient
    /// And this is so cus some folks wanna use the httpClient to do some other dumb shit
    /// But we will be using dio, so we just strip our credentials out
    try {
      final httpClient = await grant.handleAuthorizationResponse(queryParams);

      /// Check grant.handleAuthorizationResponse, and see the possible errors it throws,
      /// and then we handle them in the catch block
      await _credentialsStorage.save(httpClient.credentials);
      return right(unit); // Means everything went well.
    } on FormatException {
      return left(const AuthFailure.server());
    } on AuthorizationException catch (e) {
      return left(AuthFailure.server("${e.error}: ${e.description}"));
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Unit>> signOut() async {
    /// Here we would first get the accessToken
    final accessToken = await _credentialsStorage
        .read()
        .then((credentials) => credentials?.accessToken);

    /// We need the utf8 to encode the cliendId and clientSecret strings to Int
    /// This encoded Int is then passed to the base64 which required List<int>
    // final usernameAndPassword = base64.encode(utf8.encode('$clientId:$clientSecret'));

    /// Another way of doing this would be
    // final stringToBase64 = utf8.fuse(base64);
    final usernameAndPassword =
        stringToBase64.encode('$clientId:$clientSecret');

    try {
      /// Here we need to revoke the access_token,
      /// Because, even if the user signs out and logs back in
      /// A new token is generated, while the old one still remains valid
      /// So we need to revoke it
      /// This methods is from the Github documentation.
      try {
        _dio.deleteUri(
          revocationEndpoint,
          data: {
            'access_token': accessToken,
          },
          options: Options(
            headers: {
              'Authorization': 'basic $usernameAndPassword',
            },
          ),
        );
      } on DioError catch (e) {
        if (e.isNoConncectionError) {
          debugPrint("Token not revoked");
        } else {
          rethrow;
        }
      }
      await _credentialsStorage.clear();
      return right(unit);
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Credentials>> refreshToken(
    Credentials credentials,
  ) async {
    try {
      final refreshedCredentials = await credentials.refresh(
        httpClient: GithubOAuthHttpClient(),
        identifier: clientId,
        secret: clientSecret,
      );
      await _credentialsStorage.save(refreshedCredentials);
      return right(refreshedCredentials);
    } on FormatException {
      return left(const AuthFailure.server());
    } on AuthorizationException catch (e) {
      return left(AuthFailure.server("${e.error}: ${e.description}"));
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }
}
