import '../repositories/auth_repository.dart';
import 'auth_exceptions.dart';
import 'validators.dart';

class SignUpUseCase {
  const SignUpUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> call({required String email, required String password}) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      throw AuthException(emailError);
    }

    final passwordError = validatePassword(password);
    if (passwordError != null) {
      throw AuthException(passwordError);
    }

    await _authRepository.signUp(email: email.trim(), password: password);
  }
}
