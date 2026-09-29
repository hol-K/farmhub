import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/services/firebase_service.dart';

// PLACEHOLDER (Lot 1) — à remplacer par le Lot 5.
// La déconnexion marche déjà : le router renvoie vers /login.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('À faire — Lot 5\n\n${user?.name}\n${user?.phone}\n${user?.role.name}'),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: FirebaseService.auth.signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
