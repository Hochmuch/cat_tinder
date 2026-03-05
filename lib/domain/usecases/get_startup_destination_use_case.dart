import '../repositories/auth_repository.dart';
import '../repositories/onboarding_repository.dart';

enum StartupDestination { onboarding, auth, main }

class GetStartupDestinationUseCase {
  const GetStartupDestinationUseCase(
    this._onboardingRepository,
    this._authRepository,
  );

  final OnboardingRepository _onboardingRepository;
  final AuthRepository _authRepository;

  Future<StartupDestination> call() async {
    final onboardingDone = await _onboardingRepository.isCompleted();
    if (!onboardingDone) {
      return StartupDestination.onboarding;
    }

    final isLoggedIn = await _authRepository.isLoggedIn();
    return isLoggedIn ? StartupDestination.main : StartupDestination.auth;
  }
}
