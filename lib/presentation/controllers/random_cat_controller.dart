import 'package:flutter/foundation.dart';

import '../../domain/entities/cat_card.dart';
import '../../domain/usecases/get_random_cat_use_case.dart';

class RandomCatController extends ChangeNotifier {
  RandomCatController(this._getRandomCat);

  final GetRandomCatUseCase _getRandomCat;

  CatCard? currentCat;
  bool isLoading = false;
  int likesCounter = 0;

  Future<void> loadRandomCat() async {
    isLoading = true;
    notifyListeners();

    try {
      currentCat = await _getRandomCat();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> like() async {
    likesCounter += 1;
    notifyListeners();
    await loadRandomCat();
  }

  Future<void> dislike() async {
    await loadRandomCat();
  }
}
