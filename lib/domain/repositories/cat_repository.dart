import '../entities/breed.dart';
import '../entities/cat_card.dart';

abstract class CatRepository {
  Future<CatCard> fetchRandomCatWithBreed();
  Future<List<Breed>> fetchBreeds();
}
