import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/connectivity_service.dart';

/// `true` = en ligne. Usage : `ref.watch(connectivityProvider).value ?? true`.
final connectivityProvider = StreamProvider<bool>(
  (ref) => ConnectivityService.onlineStream,
);
