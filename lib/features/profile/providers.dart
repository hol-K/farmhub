import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_texts.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/firebase_service.dart';

/// État de l'écran profil (sauvegarde du nom, déconnexion).
class ProfileState {
  const ProfileState({this.loading = false, this.error, this.saved = false});

  final bool loading;
  final String? error;
  final bool saved;

  ProfileState copyWith({bool? loading, String? error, bool? saved}) =>
      ProfileState(
        loading: loading ?? this.loading,
        error: error,
        saved: saved ?? false,
      );
}

class ProfileController extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileState();

  /// Met à jour uniquement le nom. Le téléphone et le rôle restent inchangés
  /// (règles Firestore : phone = numéro Auth, role = producer|buyer).
  Future<void> updateName(String name) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(error: AppTexts.nameRequired);
      return;
    }
    if (trimmed == user.name) {
      state = state.copyWith(saved: true);
      return;
    }

    state = const ProfileState(loading: true);
    try {
      await FirebaseService.users.doc(user.uid).update({'name': trimmed});
      if (ref.mounted) state = const ProfileState(saved: true);
    } on FirebaseException {
      if (ref.mounted) {
        state = const ProfileState(error: AppTexts.nameSaveError);
      }
    }
  }

  Future<void> logout() async {
    state = const ProfileState(loading: true);
    try {
      await FirebaseService.auth.signOut();
      if (ref.mounted) state = const ProfileState();
    } on FirebaseException {
      if (ref.mounted) {
        state = const ProfileState(error: AppTexts.genericError);
      }
    }
  }
}

final profileProvider = NotifierProvider<ProfileController, ProfileState>(
  ProfileController.new,
);
