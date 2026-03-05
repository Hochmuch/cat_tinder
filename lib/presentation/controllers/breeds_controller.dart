import 'package:flutter/foundation.dart';

import '../../domain/entities/breed.dart';
import '../../domain/usecases/get_breeds_use_case.dart';

class BreedsController extends ChangeNotifier {
  BreedsController(this._getBreeds);

  final GetBreedsUseCase _getBreeds;

  bool isLoading = false;
  List<Breed> breeds = const [];

  Future<void> loadBreeds() async {
    isLoading = true;
    notifyListeners();

    try {
      breeds = await _getBreeds();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
