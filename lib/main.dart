import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_texts.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart'; // généré par `flutterfire configure` (voir README)
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Cache local illimité : l'app doit rester utilisable hors-ligne.
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(const ProviderScope(child: FarmHubApp()));
}

class FarmHubApp extends ConsumerWidget {
  const FarmHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppTexts.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: ref.watch(routerProvider),
      locale: const Locale('fr'),
      supportedLocales: const [Locale('fr')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
