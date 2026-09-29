import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/firebase_service.dart';

enum UserRole { producer, buyer }

/// Profil stocké dans users/{uid}.
class AppUser {
  const AppUser({
    required this.uid,
    required this.phone,
    required this.name,
    required this.role,
  });

  final String uid;
  final String phone;
  final String name;
  final UserRole role;

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AppUser(
      uid: doc.id,
      phone: data['phone'] as String? ?? '',
      name: data['name'] as String? ?? '',
      role: UserRole.values.byName(data['role'] as String),
    );
  }
}

/// Compte Firebase Auth (null = pas connecté).
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseService.auth.authStateChanges(),
);

/// Profil de l'utilisateur connecté (null = pas connecté OU profil pas encore créé).
/// Usage : `ref.watch(authProvider).value?.role`.
final authProvider = StreamProvider<AppUser?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  return FirebaseService.users
      .doc(user.uid)
      .snapshots()
      // Un « n'existe pas » venant du cache local n'est pas fiable : on attend le serveur.
      .where((doc) => doc.exists || !doc.metadata.isFromCache)
      .map((doc) => doc.exists ? AppUser.fromFirestore(doc) : null);
});
