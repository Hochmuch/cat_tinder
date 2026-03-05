import 'package:flutter/material.dart';
import 'dart:math' as math;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onCompleted});

  final Future<void> Function() onCompleted;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  static const _steps = [
    'Свайпай карточки котиков вправо/влево\nи ставь лайк или дизлайк',
    'Открывай детали породы\nпо тапу на изображение',
    'Изучай список пород\nво вкладке «Список пород»',
  ];

  int _pageIndex = 0;

  Widget _buildAnimatedCat(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        final page = _pageController.hasClients
            ? (_pageController.page ?? _pageIndex.toDouble())
            : _pageIndex.toDouble();

        final progress = (page - index).clamp(-1.0, 1.0);
        final absProgress = progress.abs();

        final mainScale = 1 - (absProgress * 0.25);
        final mainRotation = progress * 0.45;
        final mainOffsetX = progress * 120;
        final mainOffsetY = math.sin(progress * math.pi) * 16;

        final pawOffsetX = -progress * 90;
        final pawOffsetY = 24 + (absProgress * 20);
        final pawOpacity = (1 - absProgress * 0.7).clamp(0.25, 1.0);

        return SizedBox(
          width: 230,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: Offset(pawOffsetX, pawOffsetY),
                child: Opacity(
                  opacity: pawOpacity,
                  child: const Icon(
                    Icons.pets,
                    size: 62,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(mainOffsetX, mainOffsetY),
                child: Transform.rotate(
                  angle: mainRotation,
                  child: Transform.scale(
                    scale: mainScale,
                    child: const Icon(
                      Icons.pets,
                      size: 150,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _pageIndex = index),
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAnimatedCat(index),
                        const SizedBox(height: 28),
                        Text(
                          _steps[index],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(
                        _steps.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: index == _pageIndex
                                ? Colors.deepPurple
                                : Colors.deepPurple.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () async {
                      if (_pageIndex < _steps.length - 1) {
                        await _pageController.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                        return;
                      }
                      await widget.onCompleted();
                    },
                    child: Text(
                      _pageIndex == _steps.length - 1 ? 'Начать' : 'Далее',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
