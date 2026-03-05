import '../../data/local/auth_local_data_source.dart';
import '../../data/local/onboarding_local_data_source.dart';
import '../../data/local/secure_key_value_store.dart';
import '../../data/remote/cat_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/cat_repository_impl.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/cat_repository.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/usecases/complete_onboarding_use_case.dart';
import '../../domain/usecases/get_breeds_use_case.dart';
import '../../domain/usecases/get_random_cat_use_case.dart';
import '../../domain/usecases/get_startup_destination_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/sign_up_use_case.dart';
import '../../presentation/controllers/app_controller.dart';
import '../../presentation/controllers/breeds_controller.dart';
import '../../presentation/controllers/random_cat_controller.dart';

class AppScope {
  AppScope._({required this.catRepository, required this.appController});

  final CatRepository catRepository;
  final AppController appController;

  static Future<AppScope> create() async {
    final storage = SecureKeyValueStore();

    final authLocal = AuthLocalDataSource(storage);
    final onboardingLocal = OnboardingLocalDataSource(storage);
    final catRemote = CatRemoteDataSource();

    final AuthRepository authRepository = AuthRepositoryImpl(authLocal);
    final OnboardingRepository onboardingRepository = OnboardingRepositoryImpl(
      onboardingLocal,
    );
    final CatRepository catRepository = CatRepositoryImpl(catRemote);

    final appController = AppController(
      getStartupDestination: GetStartupDestinationUseCase(
        onboardingRepository,
        authRepository,
      ),
      completeOnboarding: CompleteOnboardingUseCase(onboardingRepository),
      login: LoginUseCase(authRepository),
      signUp: SignUpUseCase(authRepository),
      logout: LogoutUseCase(authRepository),
    );

    await appController.init();

    return AppScope._(
      catRepository: catRepository,
      appController: appController,
    );
  }

  RandomCatController createRandomCatController() {
    return RandomCatController(GetRandomCatUseCase(catRepository));
  }

  BreedsController createBreedsController() {
    return BreedsController(GetBreedsUseCase(catRepository));
  }
}
