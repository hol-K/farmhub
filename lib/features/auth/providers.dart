import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_config.dart';
import '../../core/constants/app_texts.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/firebase_service.dart';

/// État du parcours de connexion : numéro → code SMS → profil.
class PhoneAuthState {
  const PhoneAuthState({
    this.loading = false,
    this.error,
    this.phone,
    this.verificationId,
    this.resendToken,
  });

  final bool loading;
  final String? error;

  /// Numéro complet, ex. +2290197000000.
  final String? phone;

  /// Non null = SMS envoyé, on peut saisir le code.
  final String? verificationId;
  final int? resendToken;

  /// `loading` et `error` repartent à zéro sauf s'ils sont fournis.
  PhoneAuthState copyWith({
    bool loading = false,
    String? error,
    String? phone,
    String? verificationId,
    int? resendToken,
  }) =>
      PhoneAuthState(
        loading: loading,
        error: error,
        phone: phone ?? this.phone,
        verificationId: verificationId ?? this.verificationId,
        resendToken: resendToken ?? this.resendToken,
      );
}

class PhoneAuthController extends Notifier<PhoneAuthState> {
  @override
  PhoneAuthState build() => const PhoneAuthState();

  /// [phone] : numéro complet avec indicatif (ex. +2290197000000), voir Country.toE164.
  Future<void> sendCode(String phone) async {
    state = PhoneAuthState(loading: true, phone: phone);
    await _verify();
  }

  Future<void> resendCode() async {
    state = state.copyWith(loading: true);
    await _verify(resendToken: state.resendToken);
  }

  Future<void> verifyCode(String smsCode) async {
    final verificationId = state.verificationId;
    if (verificationId == null) return;
    state = state.copyWith(loading: true);
    await _signIn(PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    ));
  }

  /// Crée users/{uid}. Le router redirige tout seul dès que le profil existe.
  Future<void> createProfile({required String name, required UserRole role}) async {
    final user = FirebaseService.auth.currentUser;
    if (user == null) return;
    state = state.copyWith(loading: true);
    try {
      await FirebaseService.users.doc(user.uid).set({
        'phone': user.phoneNumber,
        'name': name.trim(),
        'role': role.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (ref.mounted) state = const PhoneAuthState();
    } on FirebaseException catch (e) {
      if (ref.mounted) state = state.copyWith(error: _message(e));
    }
  }

  Future<void> _verify({int? resendToken}) async {
    try {
      await FirebaseService.auth.verifyPhoneNumber(
        phoneNumber: state.phone!,
        timeout: AppConfig.otpTimeout,
        forceResendingToken: resendToken,
        // Android : le SMS est parfois lu automatiquement → connexion directe.
        verificationCompleted: _signIn,
        verificationFailed: (e) {
          if (ref.mounted) state = state.copyWith(error: _message(e));
        },
        codeSent: (verificationId, resendToken) {
          if (ref.mounted) {
            state = state.copyWith(
              verificationId: verificationId,
              resendToken: resendToken,
            );
          }
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } on FirebaseException catch (e) {
      if (ref.mounted) state = state.copyWith(error: _message(e));
    }
  }

  Future<void> _signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseService.auth.signInWithCredential(credential);
      if (ref.mounted) state = const PhoneAuthState();
    } on FirebaseException catch (e) {
      if (ref.mounted) state = state.copyWith(error: _message(e));
    }
  }

  static String _message(FirebaseException e) => switch (e.code) {
        'invalid-phone-number' => AppTexts.errInvalidPhone,
        'invalid-verification-code' => AppTexts.errInvalidCode,
        'session-expired' => AppTexts.errCodeExpired,
        'too-many-requests' => AppTexts.errTooManyRequests,
        'network-request-failed' || 'unavailable' => AppTexts.errNetwork,
        _ => AppTexts.genericError,
      };
}

final phoneAuthProvider = NotifierProvider<PhoneAuthController, PhoneAuthState>(
  PhoneAuthController.new,
);
