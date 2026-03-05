import 'dart:math';

import '../../domain/entities/breed.dart';
import '../../domain/entities/cat_card.dart';
import '../../domain/repositories/cat_repository.dart';
import '../remote/cat_remote_data_source.dart';

class CatRepositoryImpl implements CatRepository {
  CatRepositoryImpl(this._remoteDataSource);

  final CatRemoteDataSource _remoteDataSource;
  final Random _random = Random();
  List<Breed>? _breedsCache;

  @override
  Future<CatCard> fetchRandomCatWithBreed() async {
    final selectedBreed = await _getRandomBreed();

    const maxAttempts = 3;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final imageData = await _remoteDataSource.fetchRandomImageByBreedId(
        selectedBreed.id,
      );

      if (imageData == null) {
        continue;
      }

      final imageId = (imageData['id'] ?? '').toString();
      final imageUrl = (imageData['url'] ?? '').toString();
      if (imageUrl.isEmpty) {
        continue;
      }

      Breed breed = selectedBreed;
      final responseBreeds = imageData['breeds'];
      if (responseBreeds is List && responseBreeds.isNotEmpty) {
        final firstBreed = responseBreeds.first;
        if (firstBreed is Map) {
          breed = Breed.fromJson(Map<String, dynamic>.from(firstBreed));
        }
      }

      return CatCard(imageId: imageId, imageUrl: imageUrl, breed: breed);
    }

    throw const ApiException(
      'Не удалось загрузить котика. Попробуйте ещё раз.',
    );
  }

  @override
  Future<List<Breed>> fetchBreeds() async {
    if (_breedsCache != null && _breedsCache!.isNotEmpty) {
      return _breedsCache!;
    }

    final rawBreeds = await _remoteDataSource.fetchBreeds();
    final breeds = rawBreeds.map(Breed.fromJson).toList(growable: false);
    _breedsCache = breeds;
    return breeds;
  }

  Future<Breed> _getRandomBreed() async {
    final breeds = await fetchBreeds();
    final valid = breeds
        .where((breed) => breed.id.trim().isNotEmpty)
        .toList(growable: false);

    if (valid.isEmpty) {
      throw const ApiException('Не удалось получить IDs пород.');
    }

    return valid[_random.nextInt(valid.length)];
  }
}
