import 'package:cat_tinder/core/di/app_scope.dart';
import 'package:cat_tinder/domain/entities/breed.dart';
import 'package:cat_tinder/domain/entities/cat_card.dart';
import 'package:cat_tinder/domain/repositories/auth_repository.dart';
import 'package:cat_tinder/domain/repositories/cat_repository.dart';
import 'package:cat_tinder/domain/repositories/onboarding_repository.dart';
import 'package:cat_tinder/domain/usecases/complete_onboarding_use_case.dart';
import 'package:cat_tinder/domain/usecases/get_startup_destination_use_case.dart';
import 'package:cat_tinder/domain/usecases/get_breeds_use_case.dart';
import 'package:cat_tinder/domain/usecases/get_random_cat_use_case.dart';
import 'package:cat_tinder/domain/usecases/login_use_case.dart';
import 'package:cat_tinder/domain/usecases/logout_use_case.dart';
import 'package:cat_tinder/domain/usecases/sign_up_use_case.dart';
import 'package:cat_tinder/presentation/controllers/app_controller.dart';
import 'package:cat_tinder/presentation/controllers/breeds_controller.dart';
import 'package:cat_tinder/presentation/controllers/random_cat_controller.dart';
import 'package:cat_tinder/presentation/screens/app_root.dart';
import 'package:cat_tinder/presentation/screens/auth_screen.dart';
import 'package:cat_tinder/presentation/screens/main_shell_screen.dart';
import 'package:cat_tinder/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<bool> isLoggedIn() async => false;

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {}
}

class _FakeOnboardingRepository implements OnboardingRepository {
  @override
  Future<bool> isCompleted() async => false;

  @override
  Future<void> setCompleted() async {}
}

class _FakeCatRepository implements CatRepository {
  @override
  Future<CatCard> fetchRandomCatWithBreed() async {
    return CatCard(
      imageId: 'test-cat',
      imageUrl: 'https://example.com/cat.jpg',
      breed: const Breed(
        id: 'abys',
        name: 'Abyssinian',
        description: 'Test breed',
        rawData: {'origin': 'Egypt'},
      ),
    );
  }

  @override
  Future<List<Breed>> fetchBreeds() async {
    return const [
      Breed(
        id: 'abys',
        name: 'Abyssinian',
        description: 'Test breed',
        rawData: {'origin': 'Egypt'},
      ),
    ];
  }
}

class _FakeScope implements AppScope {
  _FakeScope(this.appController, this.catRepository);

  @override
  final AppController appController;

  @override
  final CatRepository catRepository;

  @override
  BreedsController createBreedsController() {
    return BreedsController(GetBreedsUseCase(catRepository));
  }

  @override
  RandomCatController createRandomCatController() {
    return RandomCatController(GetRandomCatUseCase(catRepository));
  }
}

AppController _createController() {
  final authRepository = _FakeAuthRepository();
  final onboardingRepository = _FakeOnboardingRepository();

  return AppController(
    getStartupDestination: GetStartupDestinationUseCase(
      onboardingRepository,
      authRepository,
    ),
    completeOnboarding: CompleteOnboardingUseCase(onboardingRepository),
    login: LoginUseCase(authRepository),
    signUp: SignUpUseCase(authRepository),
    logout: LogoutUseCase(authRepository),
  );
}

void main() {
  testWidgets('auth stage blocks back pop', (tester) async {
    final controller = _createController();
    controller.stage = AppStage.auth;
    final scope = _FakeScope(controller, _FakeCatRepository());

    await tester.pumpWidget(MaterialApp(home: AppRoot(scope: scope)));

    expect(find.byType(AuthScreen), findsOneWidget);

    final didPop = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(didPop, true);
    expect(find.byType(AuthScreen), findsOneWidget);
  });

  testWidgets('onboarding stage blocks back pop', (tester) async {
    final controller = _createController();
    controller.stage = AppStage.onboarding;
    final scope = _FakeScope(controller, _FakeCatRepository());

    await tester.pumpWidget(MaterialApp(home: AppRoot(scope: scope)));

    expect(find.byType(OnboardingScreen), findsOneWidget);

    final didPop = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(didPop, true);
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });

  testWidgets('onboarding completion opens auth stage', (tester) async {
    final controller = _createController();
    controller.stage = AppStage.onboarding;
    final scope = _FakeScope(controller, _FakeCatRepository());

    await tester.pumpWidget(MaterialApp(home: AppRoot(scope: scope)));

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(AuthScreen), findsNothing);

    await tester.tap(find.text('Далее'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Далее'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Начать'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsOneWidget);
    expect(controller.stage, AppStage.auth);
  });

  testWidgets('auth success opens main stage', (tester) async {
    final controller = _createController();
    controller.stage = AppStage.auth;
    final scope = _FakeScope(controller, _FakeCatRepository());

    await tester.pumpWidget(MaterialApp(home: AppRoot(scope: scope)));

    await tester.enterText(find.byType(TextFormField).at(0), 'cat@tinder.dev');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('Войти'));
    await tester.pumpAndSettle();

    expect(controller.stage, AppStage.main);
    expect(find.byType(MainShellScreen), findsOneWidget);
  });
}
