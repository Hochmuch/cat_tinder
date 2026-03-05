import '../models/stored_credentials.dart';
import 'key_value_store.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this._store);

  final KeyValueStore _store;

  static const _emailKey = 'auth_email';
  static const _passwordKey = 'auth_password';
  static const _isLoggedInKey = 'auth_logged_in';

  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _store.write(key: _emailKey, value: email);
    await _store.write(key: _passwordKey, value: password);
  }

  Future<StoredCredentials?> readCredentials() async {
    final email = await _store.read(key: _emailKey);
    final password = await _store.read(key: _passwordKey);

    if (email == null || password == null) {
      return null;
    }

    return StoredCredentials(email: email, password: password);
  }

  Future<void> setLoggedIn(bool value) {
    return _store.write(key: _isLoggedInKey, value: value ? '1' : '0');
  }

  Future<bool> isLoggedIn() async {
    final value = await _store.read(key: _isLoggedInKey);
    return value == '1';
  }

  Future<void> clearSession() => _store.delete(key: _isLoggedInKey);
}
