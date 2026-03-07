import 'package:flutter/material.dart';

import '../../domain/entities/breed.dart';

class CatDetailsScreen extends StatelessWidget {
  const CatDetailsScreen({
    super.key,
    required this.imageUrl,
    required this.breed,
  });

  static const Set<String> _technicalKeys = {
    'id',
    'name',
    'description',
    'reference_image_id',
    'image',
    'url',
    'breeds',
    'alt_names',
    'country_codes',
    'country_code',
    'vetstreet_url',
    'vcahospitals_url',
    'cfa_url',
    'wikipedia_url',
    'bidability',
    'cat_friendly',
    'suppressed_tail',
    'short_legs',
    'rex',
    'hairless',
    'is_hypoallergenic',
    'experimental',
    'natural',
    'indoor',
    'lap',
  };

  final String imageUrl;
  final Breed breed;

  String _formatTitle(String key) {
    final words = key.split('_').where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) {
      return key;
    }

    return words
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  bool _isDisplayable(String key, dynamic value) {
    if (_technicalKeys.contains(key)) {
      return false;
    }

    if (key.endsWith('_url') || key.contains('url')) {
      return false;
    }

    if (value == null) {
      return false;
    }

    if (value is String) {
      return value.trim().isNotEmpty;
    }

    return value is num || value is bool || value is Map || value is List;
  }

  String _formatValue(dynamic value) {
    if (value is Map) {
      final metric = value['metric'];
      final imperial = value['imperial'];
      if (metric != null && metric.toString().trim().isNotEmpty) {
        return '${metric.toString()} кг';
      }
      if (imperial != null && imperial.toString().trim().isNotEmpty) {
        return imperial.toString();
      }
    }

    if (value is bool) {
      return value ? 'Да' : 'Нет';
    }

    if (value is List) {
      return value.map((item) => item.toString()).join(', ');
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final infoEntries = breed.rawData.entries
        .where((entry) => _isDisplayable(entry.key, entry.value))
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),
          Text(breed.description),
          const SizedBox(height: 16),
          Text('Breed details', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...infoEntries.map(
            (entry) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(_formatTitle(entry.key)),
              subtitle: Text(_formatValue(entry.value)),
            ),
          ),
        ],
      ),
    );
  }
}
