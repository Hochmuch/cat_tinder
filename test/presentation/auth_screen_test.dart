import 'package:cat_tinder/presentation/controllers/app_controller.dart';
import 'package:cat_tinder/presentation/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows validation error on invalid input', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuthScreen(
          mode: AuthMode.login,
          onModeChanged: (_) {},
          onLogin: (_, __) async => null,
          onSignUp: (_, __) async => null,
        ),
      ),
    );

    await tester.tap(find.text('Войти'));
    await tester.pumpAndSettle();

    expect(find.text('Введите email'), findsOneWidget);
    expect(find.text('Введите пароль'), findsOneWidget);
  });

  testWidgets('submits valid login and triggers callback', (tester) async {
    var called = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AuthScreen(
          mode: AuthMode.login,
          onModeChanged: (_) {},
          onLogin: (email, password) async {
            called = true;
            return null;
          },
          onSignUp: (_, __) async => null,
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'cat@tinder.dev');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('Войти'));
    await tester.pumpAndSettle();

    expect(called, true);
  });
}
