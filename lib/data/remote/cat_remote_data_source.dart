import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class CatRemoteDataSource {
  CatRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;
  static final Uri _breedsUri = Uri.parse(
    'https://api.thecatapi.com/v1/breeds',
  );

  Future<List<Map<String, dynamic>>> fetchBreeds() async {
    http.Response response;
    try {
      response = await _client.get(_breedsUri);
    } catch (_) {
      throw const ApiException('Сетевая ошибка при получении списка пород.');
    }

    if (response.statusCode != 200) {
      throw ApiException(
        'Ошибка API при получении списка пород: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const ApiException('Некорректный формат ответа для списка пород.');
    }

    return decoded
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<Map<String, dynamic>?> fetchRandomImageByBreedId(
    String breedId,
  ) async {
    final randomImageUri = Uri.parse(
      'https://api.thecatapi.com/v1/images/search?limit=1&has_breeds=1&breed_ids=$breedId',
    );

    http.Response response;
    try {
      response = await _client.get(randomImageUri);
    } catch (_) {
      throw const ApiException('Сетевая ошибка при получении котика.');
    }

    if (response.statusCode != 200) {
      throw ApiException(
        'Ошибка API при получении котика: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);
    final items = switch (decoded) {
      List<dynamic> list => list,
      Map<String, dynamic> map => [map],
      _ => const <dynamic>[],
    };

    if (items.isEmpty || items.first is! Map) {
      return null;
    }

    return Map<String, dynamic>.from(items.first as Map);
  }
}
