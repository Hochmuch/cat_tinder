import 'package:flutter/material.dart';

import '../controllers/random_cat_controller.dart';
import '../widgets/error_dialog.dart';
import 'cat_details_screen.dart';

class RandomCatScreen extends StatefulWidget {
  const RandomCatScreen({super.key, required this.controller});

  final RandomCatController controller;

  @override
  State<RandomCatScreen> createState() => _RandomCatScreenState();
}

class _RandomCatScreenState extends State<RandomCatScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await widget.controller.loadRandomCat();
    } catch (error) {
      if (!mounted) {
        return;
      }
      await showErrorDialog(context, error);
    }
  }

  Future<void> _like() async {
    try {
      await widget.controller.like();
    } catch (error) {
      if (!mounted) {
        return;
      }
      await showErrorDialog(context, error);
    }
  }

  Future<void> _dislike() async {
    try {
      await widget.controller.dislike();
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
        final cat = widget.controller.currentCat;

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
              child: widget.controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : cat == null
                  ? Center(
                      child: FilledButton(
                        onPressed: _load,
                        child: const Text('Попробовать снова'),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          cat.breed.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Dismissible(
                            key: ValueKey(cat.imageId),
                            direction: DismissDirection.horizontal,
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                await _like();
                              } else {
                                await _dislike();
                              }
                              return false;
                            },
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.green,
                                size: 48,
                              ),
                            ),
                            secondaryBackground: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 48,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => CatDetailsScreen(
                                      imageUrl: cat.imageUrl,
                                      breed: cat.breed,
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  cat.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (_, __, ___) {
                                    return const ColoredBox(
                                      color: Colors.black12,
                                      child: Center(
                                        child: Text(
                                          'Не удалось загрузить изображение',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Text(
                    'Лайки: ${widget.controller.likesCounter}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      heroTag: 'dislike_btn',
                      onPressed: _dislike,
                      child: const Icon(Icons.close),
                    ),
                    const SizedBox(width: 24),
                    FloatingActionButton(
                      heroTag: 'like_btn',
                      onPressed: _like,
                      child: const Icon(Icons.favorite),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
