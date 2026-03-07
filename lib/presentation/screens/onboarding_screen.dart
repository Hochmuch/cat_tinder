import 'dart:math' as math;

import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final minImageSize = (screenWidth * 0.28).clamp(110.0, 150.0);
    final maxImageSize = (screenWidth * 0.936).clamp(312.0, 520.0);
    final maxPage = (_steps.length - 1).toDouble();

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/onboarding/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      physics: const PageScrollPhysics(),
                      onPageChanged: (index) =>
                          setState(() => _pageIndex = index),
                      itemCount: _steps.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.72),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _steps[index],
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    IgnorePointer(
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            final page = _pageController.hasClients
                                ? (_pageController.page ??
                                      _pageIndex.toDouble())
                                : _pageIndex.toDouble();
                            final normalized = maxPage <= 0
                                ? 0.0
                                : (page / maxPage).clamp(0.0, 1.0);
                            final acceleratedScaleProgress = math
                                .pow(normalized, 0.6)
                                .toDouble();
                            final size =
                                minImageSize +
                                (maxImageSize - minImageSize) *
                                    acceleratedScaleProgress;
                            final angle = normalized * 2 * math.pi;

                            return Align(
                              alignment: const Alignment(0, 0.08),
                              child: Transform.rotate(
                                angle: angle,
                                child: SizedBox(
                                  width: size,
                                  height: size,
                                  child: Image.asset(
                                    'assets/onboarding/cat.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
