abstract final class AppTexts {
  // === Commun ===
  static const appName = 'FarmHub';
  static const tagline = 'Vendez votre récolte directement';
  static const offline = 'Hors-ligne';
  static const genericError = 'Une erreur est survenue. Réessayez.';
  static const save = 'Enregistrer';
  static const retry = 'Réessayer';

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
  static const publishTitle = 'Publier une récolte';
  static const productName = 'Nom du produit';
  static const productNameHint = 'Ex. Tomate';
  static const variety = 'Variété';
  static const varietyHint = 'Ex. Roma';
  static const quantity = 'Quantité disponible';
  static const quantityHint = 'Ex. 50';
  static const unit = 'Unité';
  static const minimumPrice = 'Prix minimum';
  static const minimumPriceHint = 'Ex. 15000';
  static const fcfa = 'FCFA';
  static const harvestDate = 'Date de récolte';
  static const address = 'Adresse';
  static const addressHint = 'Village, commune, point de repère';
  static const productPhoto = 'Photo du produit';
  static const addPhoto = 'Ajouter une photo';
  static const takePhoto = 'Prendre une photo';
  static const chooseFromGallery = 'Choisir dans la galerie';
  static const cancel = 'Annuler';
  static const publish = 'Publier';
  static const publishing = 'Publication en cours...';
  static const changePhoto = 'Changer la photo';
  static const selectDate = 'Choisir une date';

  // Messages de validation
  static const productNameRequired = 'Le nom du produit est obligatoire.';
  static const quantityRequired = 'La quantité est obligatoire.';
  static const quantityInvalid = 'Entrez une quantité valide.';
  static const unitRequired = 'Sélectionnez une unité.';
  static const minimumPriceRequired = 'Le prix minimum est obligatoire.';
  static const minimumPriceInvalid = 'Entrez un prix valide.';
  static const harvestDateRequired = 'La date de récolte est obligatoire.';
  static const addressRequired = 'L’adresse est obligatoire.';

  // Messages photo
  static const photoRequired = 'Ajoutez une photo du produit.';
  static const photoCompressionError = 'Impossible de compresser la photo.';
  static const photoSelectionError = 'Impossible de sélectionner la photo.';

  // Messages de publication
  static const publishSuccess = 'Récolte publiée avec succès.';
  static const publishError = 'Impossible de publier la récolte. Réessayez.';

  // === Produit : statut et détail (partagé producteur / acheteur) ===
  static const syncPending = 'En attente d\'envoi';
  static const syncPublished = 'Publié';
  static const productDetailTitle = 'Détail du produit';
  static const productLoadError = 'Impossible de charger ce produit.';
  static const productNotFound = 'Produit introuvable.';
  static const detailQuantity = 'Quantité';
  static const detailHarvest = 'Récolte prévue';
  static const detailLocation = 'Localisation';
  static const detailPublishedOn = 'Publié le';

  // === Lot 3 : Mes produits ===
  static const myProductsTitle = 'Mes produits';
  static const publishFab = 'Publier';
  static const myProductsLoadError = 'Impossible de charger vos produits.';
  static const publishedCount = 'Produits publiés';
  static const myProductsEmptyTitle = 'Aucun produit pour le moment';
  static const myProductsEmptyBody = 'Vos récoltes publiées apparaîtront ici.';
  static const publishFirst = 'Publier ma première récolte';

  // === Lot 4 : Acheteur ===
  static const harvestsTitle = 'Récoltes';
  static const searchTitle = 'Rechercher';
  static const searchHint = 'Nom, variété, lieu ou producteur';
  static const searchNoResult = 'Aucun résultat pour cette recherche.';
  static const productsLoadError = 'Impossible de charger les produits.';
  static const heroTitle = 'Mieux vivre, mieux vendre';
  static const heroSubtitle = 'Des récoltes locales prêtes à partir.';
  static const marketEmptyTitle = 'Aucune récolte disponible';
  static const marketEmptyBody = 'Les produits publiés apparaîtront ici.';
  static const call = 'Appeler';
  static const whatsapp = 'WhatsApp';
  static const contactError = 'Impossible d\'ouvrir l\'application.';
  static String whatsappMessage(String productName) =>
      'Bonjour, votre récolte de $productName sur FarmHub m\'intéresse.';

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
