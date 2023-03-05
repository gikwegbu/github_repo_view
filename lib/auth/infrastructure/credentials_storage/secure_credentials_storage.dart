import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:github_repo_view/auth/infrastructure/credentials_storage/credentials_storage.dart';
import 'package:oauth2/src/credentials.dart';

class SecureCredentialsStorage implements CredentialsStorage {
  final FlutterSecureStorage _storage;

  static const oauthKey = 'oauth2_credentials';
  Credentials? _cachedCredentials;

  SecureCredentialsStorage(this._storage);
  @override
  Future<Credentials?> read() async {
    if (_cachedCredentials != null) {
      return _cachedCredentials;
    }
    final json = await _storage.read(key: oauthKey);
    if (json == null) {
      return null; // no user signed in
    }
    // Covering the Exception from the Credentials.fromJson(json)
    try {
      return _cachedCredentials = Credentials.fromJson(json);
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> save(Credentials credentials) {
    _cachedCredentials = credentials;
    return _storage.write(key: oauthKey, value: credentials.toJson());
  }

  @override
  Future<void> clear() {
    _cachedCredentials = null;
    return _storage.delete(key: oauthKey);
  }
}
