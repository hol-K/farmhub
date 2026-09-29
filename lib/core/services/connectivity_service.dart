import 'package:connectivity_plus/connectivity_plus.dart';

/// Flux « en ligne / hors-ligne ».
/// ponytail: détecte un réseau actif (wifi/mobile), pas l'accès réel à internet ;
/// ajouter un ping si les faux « en ligne » posent problème sur le terrain.
abstract final class ConnectivityService {
  static final _connectivity = Connectivity();

  static Stream<bool> get onlineStream async* {
    yield _isOnline(await _connectivity.checkConnectivity());
    yield* _connectivity.onConnectivityChanged.map(_isOnline);
  }

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
