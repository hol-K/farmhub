/// Tous les textes affichés dans l'app.
/// Chaque lot ajoute ses textes dans SA section. Dev 5 relit et harmonise.
abstract final class AppTexts {
  // === Commun ===
  static const appName = 'FarmHub';
  static const tagline = 'Vendez votre récolte directement';
  static const offline = 'Hors-ligne';
  static const genericError = 'Une erreur est survenue. Réessayez.';
  static const save = 'Enregistrer';
  static const detail = 'Détail';

  // === Lot 1 : Connexion ===
  static const phoneTitle = 'Votre numéro de téléphone';
  static const phoneHint = '01 XX XX XX XX';
  static const phoneInvalid = 'Numéro invalide (10 chiffres, commence par 01)';
  static const sendCode = 'Recevoir le code';

  static const otpTitle = 'Code reçu par SMS';
  static String otpSentTo(String phone) => 'Code envoyé au $phone';
  static const otpInvalid = 'Code à 6 chiffres';
  static const validate = 'Valider';
  static const resendCode = 'Renvoyer le code';

  static const roleTitle = 'Qui êtes-vous ?';
  static const nameLabel = 'Votre nom';
  static const nameRequired = 'Entrez votre nom';
  static const iAmProducer = 'Je suis producteur';
  static const iAmBuyer = 'Je suis acheteur';

  static const errInvalidPhone = 'Numéro de téléphone invalide.';
  static const errInvalidCode = 'Code incorrect.';
  static const errCodeExpired = 'Code expiré. Demandez un nouveau code.';
  static const errTooManyRequests = 'Trop d\'essais. Réessayez plus tard.';
  static const errNetwork = 'Pas de connexion internet.';

  // === Lot 2 : Publication ===
  static const publishTitle = 'Publier';
  static const publishPlaceholder = 'À faire — Lot 2';

  // === Lot 3 : Mes produits ===
  static const myProductsTitle = 'Mes produits';
  static const myProductsPlaceholder = 'À faire — Lot 3\n(voir un détail)';
  static const publishFab = 'Publier';
  static String producerDetailPlaceholder(String productId) =>
      'À faire — Lot 3\n(produit $productId)';

  // === Lot 4 : Acheteur ===
  static const harvestsTitle = 'Récoltes';
  static const harvestsPlaceholder = 'À faire — Lot 4\n(voir un détail)';
  static const searchTitle = 'Rechercher';
  static const searchPlaceholder = 'À faire — Lot 4';
  static String buyerDetailPlaceholder(String productId) =>
      'À faire — Lot 4\n(produit $productId)';

  // === Lot 5 : Profil ===
  static const profileTitle = 'Profil';
  static const phoneLabel = 'Numéro de téléphone';
  static const phoneReadonlyHint = 'Non modifiable';
  static const roleLabel = 'Rôle';
  static const roleProducer = 'Producteur';
  static const roleBuyer = 'Acheteur';
  static const logout = 'Se déconnecter';
  static const nameSaved = 'Nom enregistré';
  static const nameSaveError = 'Impossible d\'enregistrer le nom. Réessayez.';
  static const profileUnavailable = 'Profil indisponible. Réessayez plus tard.';

  static String roleLabelFor(String roleName) => switch (roleName) {
        'producer' => roleProducer,
        'buyer' => roleBuyer,
        _ => roleName,
      };
}
