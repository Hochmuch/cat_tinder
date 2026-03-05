import 'package:flutter/material.dart';

import '../controllers/breeds_controller.dart';
import '../widgets/error_dialog.dart';
import 'breed_details_screen.dart';

class BreedsListScreen extends StatefulWidget {
  const BreedsListScreen({super.key, required this.controller});

  final BreedsController controller;

  @override
  State<BreedsListScreen> createState() => _BreedsListScreenState();
}

class _BreedsListScreenState extends State<BreedsListScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await widget.controller.loadBreeds();
    } catch (error) {
      if (!mounted) {
        return;
      }
      await showErrorDialog(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        if (widget.controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (widget.controller.breeds.isEmpty) {
          return Center(
            child: FilledButton(
              onPressed: _load,
              child: const Text('Повторить загрузку пород'),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _load,
          child: ListView.separated(
            itemCount: widget.controller.breeds.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final breed = widget.controller.breeds[index];
              return ListTile(
                title: Text(breed.name),
                subtitle: Text(
                  breed.shortInfo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => BreedDetailsScreen(breed: breed),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
