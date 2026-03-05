import '../entities/cat_card.dart';
import '../repositories/cat_repository.dart';

class GetRandomCatUseCase {
  const GetRandomCatUseCase(this._repository);

  final CatRepository _repository;

  Future<CatCard> call() => _repository.fetchRandomCatWithBreed();
}
