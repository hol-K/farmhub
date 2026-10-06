import 'package:farmhub/core/constants/app_texts.dart';
import 'package:farmhub/core/providers/onboarding_provider.dart';
import 'package:farmhub/features/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ProviderContainer> pumpOnboarding(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [prefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: OnboardingScreen()),
    ));
    return container;
  }

  testWidgets('Suivant ×2 puis Commencer : onboarding terminé et mémorisé', (tester) async {
    final container = await pumpOnboarding(tester);
    expect(container.read(onboardingProvider), isFalse);
    expect(find.text(AppTexts.onboarding1Title), findsOneWidget);

    await tester.tap(find.text(AppTexts.next));
    await tester.pumpAndSettle();
    expect(find.text(AppTexts.onboarding2Title), findsOneWidget);

    await tester.tap(find.text(AppTexts.next));
    await tester.pumpAndSettle();
    expect(find.text(AppTexts.onboarding3Title), findsOneWidget);
    expect(find.text(AppTexts.skip), findsNothing); // dernière page : pas de « Passer »

    await tester.tap(find.text(AppTexts.start));
    await tester.pump();
    expect(container.read(onboardingProvider), isTrue);
    expect(container.read(prefsProvider).getBool('onboardingDone'), isTrue);
  });

  testWidgets('Passer termine directement', (tester) async {
    final container = await pumpOnboarding(tester);
    await tester.tap(find.text(AppTexts.skip));
    await tester.pump();
    expect(container.read(onboardingProvider), isTrue);
  });
}
