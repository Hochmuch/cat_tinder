abstract class AuthRepository {
  Future<void> signUp({required String email, required String password});
  Future<void> login({required String email, required String password});
  Future<void> logout();
  Future<bool> isLoggedIn();
}
