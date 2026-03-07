import '../repositories/auth_repository.dart';

class GetRegisteredEmailUseCase {
  const GetRegisteredEmailUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<String?> call() {
    return _authRepository.getRegisteredEmail();
  }
}
