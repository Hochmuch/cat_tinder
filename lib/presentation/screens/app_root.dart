import 'package:flutter/material.dart';

import '../../core/di/app_scope.dart';
import '../controllers/app_controller.dart';
import 'auth_screen.dart';
import 'main_shell_screen.dart';
import 'onboarding_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key, required this.scope});

  final AppScope scope;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scope.appController,
      builder: (context, _) {
        switch (scope.appController.stage) {
          case AppStage.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case AppStage.onboarding:
            return PopScope(
              canPop: false,
              child: OnboardingScreen(
                onCompleted: scope.appController.finishOnboarding,
              ),
            );
          case AppStage.auth:
            return PopScope(
              canPop: false,
              child: AuthScreen(
                mode: scope.appController.authMode,
                initialEmail: scope.appController.rememberedEmail,
                onModeChanged: scope.appController.setAuthMode,
                onLogin: (email, password) =>
                    scope.appController.login(email: email, password: password),
                onSignUp: (email, password) => scope.appController.signUp(
                  email: email,
                  password: password,
                ),
              ),
            );
          case AppStage.main:
            return MainShellScreen(
              scope: scope,
              onLogout: scope.appController.logout,
            );
        }
      },
    );
  }
}
