/// Tous les textes affichés dans l'app.
/// Chaque lot ajoute ses textes dans SA section. Dev 5 relit et harmonise.
abstract final class AppTexts {
  // === Commun ===
  static const appName = 'FarmHub';
  static const tagline = 'Vendez votre récolte directement';
  static const offline = 'Hors-ligne';
  static const genericError = 'Une erreur est survenue. Réessayez.';

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

  // === Lot 3 : Mes produits ===

  // === Lot 4 : Acheteur ===

  // === Lot 5 : Profil ===
}
