import 'breed.dart';

class CatCard {
  const CatCard({
    required this.imageId,
    required this.imageUrl,
    required this.breed,
  });

  final String imageId;
  final String imageUrl;
  final Breed breed;
}
