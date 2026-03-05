import 'package:flutter/material.dart';

import '../../domain/entities/breed.dart';

class CatDetailsScreen extends StatelessWidget {
  const CatDetailsScreen({
    super.key,
    required this.imageUrl,
    required this.breed,
  });

  final String imageUrl;
  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final infoEntries = breed.rawData.entries
        .where((entry) => entry.value != null)
        .where((entry) {
          final value = entry.value;
          if (value is String) {
            return value.trim().isNotEmpty;
          }
          return true;
        })
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
          Text(
            'Вся информация о породе',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...infoEntries.map(
            (entry) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(entry.key),
              subtitle: Text(entry.value.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
