import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Chargé dans main() avant runApp, puis injecté via ProviderScope.overrides.
final prefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('prefsProvider doit être surchargé dans main()'),
);

const _onboardingKey = 'onboardingDone';

/// true = l'onboarding a déjà été vu (ou passé) sur cet appareil.
class OnboardingController extends Notifier<bool> {
  @override
  bool build() => ref.watch(prefsProvider).getBool(_onboardingKey) ?? false;

  Future<void> complete() async {
    state = true;
    await ref.read(prefsProvider).setBool(_onboardingKey, true);
  }
}

final onboardingProvider = NotifierProvider<OnboardingController, bool>(
  OnboardingController.new,
);
