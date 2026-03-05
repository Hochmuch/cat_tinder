import '../../domain/repositories/onboarding_repository.dart';
import '../local/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._localDataSource);

  final OnboardingLocalDataSource _localDataSource;

  @override
  Future<bool> isCompleted() => _localDataSource.isCompleted();

  @override
  Future<void> setCompleted() => _localDataSource.setCompleted();
}
