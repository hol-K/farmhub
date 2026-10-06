/// Valeurs de configuration de l'app (pas de texte affiché ici : voir app_texts.dart).
abstract final class AppConfig {
  // Téléphone : pays et formats dans countries.dart.
  static const otpLength = 6;
  static const otpTimeout = Duration(seconds: 60);

  // Firestore / Storage.
  static const usersCollection = 'users';
  static const productsCollection = 'products';
  static const productPhotosFolder = 'products';

  // Photos.
  static const photoMaxSize = 1024;
  static const photoQuality = 70;

  // Produits.
  static const units = ['kg', 'sac', 'tonne', 'panier'];
}
