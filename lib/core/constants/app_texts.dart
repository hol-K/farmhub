abstract final class AppTexts {
  // === Commun ===
  static const appName = 'FarmHub';
  static const tagline = 'Vendez votre récolte directement';
  static const offline = 'Hors-ligne';
  static const genericError = 'Une erreur est survenue. Réessayez.';
  static const save = 'Enregistrer';
  static const retry = 'Réessayer';

  // === Onboarding (premier lancement) ===
  static const skip = 'Passer';
  static const next = 'Suivant';
  static const start = 'Commencer';
  static const onboarding1Title = 'Vendez votre récolte directement';
  static const onboarding1Body =
      'Producteur : publiez votre récolte en une minute, avec photo, quantité et prix. '
      'Même sans internet, l\'envoi se fait dès le retour du réseau.';
  static const onboarding2Title = 'Trouvez les récoltes près de vous';
  static const onboarding2Body =
      'Acheteur : cherchez par produit, lieu ou prix, et voyez ce qui est disponible maintenant.';
  static const onboarding3Title = 'Traitez sans intermédiaire';
  static const onboarding3Body =
      'Appelez ou écrivez au producteur sur WhatsApp en un geste. '
      'Il fixe son prix, vous discutez en direct.';

  // === Lot 1 : Connexion ===
  static const phoneTitle = 'Votre numéro de téléphone';
  static const phoneHint = '01 XX XX XX XX';
  static const phoneInvalid = 'Numéro invalide (10 chiffres, commence par 01)';
  static const phoneHintOther = 'Votre numéro';
  static String phoneInvalidFor(String country) => 'Numéro invalide pour : $country';
  static const country = 'Pays';
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

  // === Gestion d'un produit (producteur) ===
  static const editTitle = 'Modifier la récolte';
  static const edit = 'Modifier';
  static const editSuccess = 'Modifications enregistrées.';
  static const markSold = 'Marquer vendu';
  static const markAvailable = 'Remettre en vente';
  static const sold = 'Vendu';
  static const delete = 'Supprimer';
  static const deleteConfirmTitle = 'Supprimer ce produit ?';
  static const deleteConfirmBody = 'Il disparaîtra pour tous les acheteurs. Action définitive.';
  static const deleteSuccess = 'Produit supprimé.';

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
  static const maxPrice = 'Prix max';
  static const allUnits = 'Tout';
  static const sortRecent = 'Plus récents';
  static const sortPriceAsc = 'Prix croissant';
  static const sortPriceDesc = 'Prix décroissant';
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
