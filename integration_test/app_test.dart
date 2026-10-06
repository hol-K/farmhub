// Parcours réels sur téléphone, avec le vrai projet Firebase.
// Lancer : flutter test integration_test/app_test.dart
// Prérequis : les 2 numéros de test existent dans Authentication, et leurs
// profils ont déjà été créés (producteur / acheteur). Aucune donnée n'est modifiée.

import 'package:farmhub/core/constants/app_texts.dart';
import 'package:farmhub/core/providers/onboarding_provider.dart';
import 'package:farmhub/firebase_options.dart';
import 'package:farmhub/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const producerPhone = '0165656655';
const buyerPhone = '0160601122';
const testCode = '123456';

late SharedPreferences prefs;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingDone', true); // onboarding testé à part
    // Numéros de test uniquement : saute reCAPTCHA / Play Integrity.
    await FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  });

  // Chaque test part déconnecté.
  setUp(() => FirebaseAuth.instance.signOut());

  testWidgets('producteur : connexion → Mes produits → déconnexion', (tester) async {
    await _login(tester, producerPhone);
    await _waitFor(tester, find.text(AppTexts.myProductsTitle));
    expect(find.text(AppTexts.publishFab), findsOneWidget);

    await _logout(tester);
  });

  testWidgets('acheteur : connexion → Récoltes → filtres de recherche', (tester) async {
    await _login(tester, buyerPhone);
    await _waitFor(tester, find.text(AppTexts.harvestsTitle));

    await tester.tap(find.byTooltip(AppTexts.searchTitle));
    await _waitFor(tester, find.text(AppTexts.maxPrice));
    expect(find.text(AppTexts.sortRecent), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'kg'), findsOneWidget);

    await tester.pageBack();
    await _waitFor(tester, find.text(AppTexts.harvestsTitle));
    await _logout(tester);
  });
}

Future<void> _login(WidgetTester tester, String phone) async {
  await tester.pumpWidget(ProviderScope(
    overrides: [prefsProvider.overrideWithValue(prefs)],
    child: const FarmHubApp(),
  ));
  await _waitFor(tester, find.text(AppTexts.sendCode));

  await tester.enterText(find.byType(TextFormField), phone);
  await tester.tap(find.text(AppTexts.sendCode));
  await _waitFor(tester, find.text(AppTexts.otpTitle));

  // 6 chiffres → validation automatique (OtpScreen).
  await tester.enterText(find.byType(TextFormField), testCode);
}

Future<void> _logout(WidgetTester tester) async {
  await tester.tap(find.byTooltip(AppTexts.profileTitle));
  await _waitFor(tester, find.text(AppTexts.logout));
  await tester.ensureVisible(find.text(AppTexts.logout));
  await tester.tap(find.text(AppTexts.logout));
  await _waitFor(tester, find.text(AppTexts.sendCode));
}

/// pumpAndSettle bloquerait sur les indicateurs de chargement animés :
/// on avance par pas de 200 ms jusqu'à voir [finder].
Future<void> _waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Introuvable après ${timeout.inSeconds} s : $finder');
}
