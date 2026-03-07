import 'package:flutter/foundation.dart';

import '../../domain/usecases/auth_exceptions.dart';
import '../../domain/services/analytics_service.dart';
import '../../domain/usecases/complete_onboarding_use_case.dart';
import '../../domain/usecases/get_registered_email_use_case.dart';
import '../../domain/usecases/get_startup_destination_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/sign_up_use_case.dart';

enum AuthMode { login, signUp }

enum AppStage { loading, onboarding, auth, main }

class AppController extends ChangeNotifier {
  AppController({
    required GetStartupDestinationUseCase getStartupDestination,
    required CompleteOnboardingUseCase completeOnboarding,
    required GetRegisteredEmailUseCase getRegisteredEmail,
    required AnalyticsService analytics,
    required LoginUseCase login,
    required SignUpUseCase signUp,
    required LogoutUseCase logout,
  }) : _getStartupDestination = getStartupDestination,
       _completeOnboarding = completeOnboarding,
       _getRegisteredEmail = getRegisteredEmail,
       _analytics = analytics,
       _login = login,
       _signUp = signUp,
       _logout = logout;

  final GetStartupDestinationUseCase _getStartupDestination;
  final CompleteOnboardingUseCase _completeOnboarding;
  final GetRegisteredEmailUseCase _getRegisteredEmail;
  final AnalyticsService _analytics;
  final LoginUseCase _login;
  final SignUpUseCase _signUp;
  final LogoutUseCase _logout;

  AppStage stage = AppStage.loading;
  AuthMode authMode = AuthMode.login;
  String? rememberedEmail;

  Future<void> init() async {
    rememberedEmail = await _getRegisteredEmail();
    final destination = await _getStartupDestination();
    stage = switch (destination) {
      StartupDestination.onboarding => AppStage.onboarding,
      StartupDestination.auth => AppStage.auth,
      StartupDestination.main => AppStage.main,
    };
    notifyListeners();
  }

  void setAuthMode(AuthMode mode) {
    authMode = mode;
    notifyListeners();
  }

  Future<void> finishOnboarding() async {
    await _completeOnboarding();
    stage = AppStage.auth;
    notifyListeners();
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _login(email: email, password: password);
      await _reportAnalytics('auth_login_success');
      rememberedEmail = email.trim();
      stage = AppStage.main;
      notifyListeners();
      return null;
    } on AuthException catch (e) {
      await _reportAnalytics('auth_login_error');
      return e.message;
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _signUp(email: email, password: password);
      await _reportAnalytics('auth_sign_up_success');
      rememberedEmail = email.trim();
      stage = AppStage.main;
      notifyListeners();
      return null;
    } on AuthException catch (e) {
      await _reportAnalytics('auth_sign_up_error');
      return e.message;
    }
  }

  Future<void> _reportAnalytics(String eventName) async {
    try {
      await _analytics.logEvent(eventName);
    } catch (_) {}
  }

  Future<void> logout() async {
    await _logout();
    stage = AppStage.auth;
    authMode = AuthMode.login;
    notifyListeners();
  }
}
