import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_exceptions.dart';
import '../local/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._localDataSource);

  final AuthLocalDataSource _localDataSource;

  @override
  Future<void> signUp({required String email, required String password}) async {
    await _localDataSource.saveCredentials(email: email, password: password);
    await _localDataSource.setLoggedIn(true);
  }

  @override
  Future<void> login({required String email, required String password}) async {
    final stored = await _localDataSource.readCredentials();
    if (stored == null) {
      throw const AuthException('Пользователь не зарегистрирован');
    }

    if (stored.email != email || stored.password != password) {
      throw const AuthException('Неверный email или пароль');
    }

    await _localDataSource.setLoggedIn(true);
  }

  @override
  Future<void> logout() => _localDataSource.clearSession();

  @override
  Future<bool> isLoggedIn() => _localDataSource.isLoggedIn();
}
