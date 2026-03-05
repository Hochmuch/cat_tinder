class Breed {
  const Breed({
    required this.id,
    required this.name,
    required this.description,
    required this.rawData,
  });

  final String id;
  final String name;
  final String description;
  final Map<String, dynamic> rawData;

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Unknown breed').toString(),
      description: (json['description'] ?? 'Нет описания').toString(),
      rawData: Map<String, dynamic>.from(json),
    );
  }

  String get origin {
    final value = rawData['origin'];
    return value == null || value.toString().trim().isEmpty
        ? 'Не указано'
        : value.toString();
  }

  String get temperament {
    final value = rawData['temperament'];
    return value == null || value.toString().trim().isEmpty
        ? 'Не указано'
        : value.toString();
  }

  String get lifeSpan {
    final value = rawData['life_span'];
    return value == null || value.toString().trim().isEmpty
        ? 'Не указано'
        : '${value.toString()} лет';
  }

  String get intelligence {
    final value = rawData['intelligence'];
    return value == null ? 'Не указано' : value.toString();
  }

  String get shortInfo => '$origin • ${temperament.split(',').first}';
}
