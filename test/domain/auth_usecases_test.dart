import 'package:cat_tinder/domain/repositories/auth_repository.dart';
import 'package:cat_tinder/domain/usecases/auth_exceptions.dart';
import 'package:cat_tinder/domain/usecases/login_use_case.dart';
import 'package:cat_tinder/domain/usecases/sign_up_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  String? storedEmail;
  String? storedPassword;
  bool loggedIn = false;

  @override
  Future<String?> getRegisteredEmail() async => storedEmail;

  @override
  Future<bool> isLoggedIn() async => loggedIn;

  @override
  Future<void> login({required String email, required String password}) async {
    if (storedEmail != email || storedPassword != password) {
      throw const AuthException('Неверный email или пароль');
    }
    loggedIn = true;
  }

  @override
  Future<void> logout() async {
    loggedIn = false;
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    storedEmail = email;
    storedPassword = password;
    loggedIn = true;
  }
}

void main() {
  group('Auth use cases', () {
    test('sign up stores user and marks logged in', () async {
      final repository = _FakeAuthRepository();
      final useCase = SignUpUseCase(repository);

      await useCase(email: 'cat@gmail.com', password: '123456');

      expect(repository.storedEmail, 'cat@gmail.com');
      expect(repository.loggedIn, true);
    });

    test('login throws exception for invalid email format', () async {
      final repository = _FakeAuthRepository();
      final useCase = LoginUseCase(repository);

      expect(
        () => useCase(email: 'wrong-email', password: '123456'),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
