import 'package:flutter/material.dart';

import '../../domain/entities/breed.dart';

class BreedDetailsScreen extends StatelessWidget {
  const BreedDetailsScreen({super.key, required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(breed.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text('Происхождение: ${breed.origin}')),
              Chip(label: Text('Темперамент: ${breed.temperament}')),
              Chip(label: Text('Продолжительность жизни: ${breed.lifeSpan}')),
              Chip(label: Text('Интеллект: ${breed.intelligence}')),
            ],
          ),
        ],
      ),
    );
  }
}
