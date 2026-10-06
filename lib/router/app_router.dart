import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/auth_provider.dart';
import '../core/providers/onboarding_provider.dart';
import '../features/auth/screens/otp_screen.dart';
import '../features/auth/screens/phone_input_screen.dart';
import '../features/auth/screens/profile_choice_screen.dart';
import '../features/buyer/screens/product_detail_screen.dart' as buyer;
import '../features/buyer/screens/product_list_screen.dart';
import '../features/buyer/screens/product_search_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/producer/screens/my_products_screen.dart';
import '../features/producer/screens/product_detail_screen.dart' as producer;
import '../features/producer/screens/publish_screen.dart';
import '../features/profile/screens/profile_screen.dart';

const _authRoutes = {'/login', '/otp'};

/// Où envoyer l'utilisateur selon son état. null = rester sur [location].
/// Fonction pure (testée dans test/lot1_test.dart).
String? authRedirect(
  String location, {
  required bool loading,
  required bool signedIn,
  required UserRole? role,
  bool onboarded = true,
}) {
  if (loading) return location == '/' ? null : '/';
  if (!signedIn) {
    // Onboarding : seulement au premier lancement, avant la connexion.
    if (!onboarded) return location == '/onboarding' ? null : '/onboarding';
    return _authRoutes.contains(location) ? null : '/login';
  }
  if (role == null) return location == '/role' ? null : '/role';

  final home = role == UserRole.producer ? '/producer' : '/buyer';
  if (location == '/' || location == '/role' || _authRoutes.contains(location)) {
    return home;
  }
  // Un acheteur n'entre pas dans l'espace producteur, et inversement.
  final otherSpace = role == UserRole.producer ? '/buyer' : '/producer';
  if (location.startsWith(otherSpace)) return home;
  return null;
}

final routerProvider = Provider<GoRouter>((ref) {
  // Relance les redirections quand la connexion ou le profil changent.
  final refresh = ValueNotifier(0);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.listen(authProvider, (_, _) => refresh.value++);
  ref.listen(onboardingProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final user = ref.read(authStateProvider);
      final profile = ref.read(authProvider);
      final signedIn = user.value != null;
      return authRedirect(
        state.matchedLocation,
        loading: user.isLoading || (signedIn && profile.isLoading),
        signedIn: signedIn,
        role: profile.value?.role,
        onboarded: ref.read(onboardingProvider),
      );
    },
    routes: [
      // Écran d'attente pendant la lecture de la session / du profil.
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, _) => const PhoneInputScreen()),
      GoRoute(path: '/otp', builder: (_, _) => const OtpScreen()),
      GoRoute(path: '/role', builder: (_, _) => const ProfileChoiceScreen()),
      GoRoute(
        path: '/producer',
        builder: (_, _) => const MyProductsScreen(),
        routes: [
          GoRoute(path: 'publish', builder: (_, _) => const PublishScreen()),
          GoRoute(
            path: 'product/:id',
            builder: (_, state) =>
                producer.ProductDetailScreen(productId: state.pathParameters['id']!),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (_, state) =>
                    PublishScreen(productId: state.pathParameters['id']!),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/buyer',
        builder: (_, _) => const ProductListScreen(),
        routes: [
          GoRoute(path: 'search', builder: (_, _) => const ProductSearchScreen()),
          GoRoute(
            path: 'product/:id',
            builder: (_, state) =>
                buyer.ProductDetailScreen(productId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
    ],
  );
});
