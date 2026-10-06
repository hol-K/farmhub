import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_texts.dart';
import '../../core/providers/onboarding_provider.dart';
import '../../core/theme/app_theme.dart';

/// 3 pages de présentation au premier lancement. Swipe ou « Suivant » ;
/// « Passer » va directement à la connexion (le router redirige tout seul).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _pages = [
    (Icons.agriculture_rounded, AppTexts.onboarding1Title, AppTexts.onboarding1Body),
    (Icons.search_rounded, AppTexts.onboarding2Title, AppTexts.onboarding2Body),
    (Icons.handshake_rounded, AppTexts.onboarding3Title, AppTexts.onboarding3Body),
  ];

  final _controller = PageController();
  var _index = 0;

  bool get _isLast => _index == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() => ref.read(onboardingProvider.notifier).complete();

  void _next() => _isLast
      ? _finish()
      : _controller.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Hauteur fixe : la page ne saute pas quand « Passer » disparaît.
            SizedBox(
              height: 48,
              child: Align(
                alignment: Alignment.centerRight,
                child: _isLast
                    ? null
                    : TextButton(
                        onPressed: _finish,
                        child: const Text(AppTexts.skip),
                      ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: [
                  for (final (icon, title, body) in _pages)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, size: 96, color: AppTheme.primary),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            title,
                            style: theme.textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            body,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey.shade700),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _pages.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _index ? AppTheme.primary : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing * 1.5),
              child: FilledButton(
                onPressed: _next,
                child: Text(_isLast ? AppTexts.start : AppTexts.next),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
