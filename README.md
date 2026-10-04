# FarmHub

Mise en relation directe entre producteurs agricoles du Bénin et acheteurs (commerçants, restaurateurs), sans intermédiaire. Développement en Flutter et Dart.

## Stack technique

- Flutter et Dart (Android en priorité)
- Backend : Firebase (Auth par téléphone + OTP, Firestore avec cache hors-ligne, Cloud Storage)
- Gestion d'état : Riverpod
- Navigation : go_router

## Architecture

Le projet suit une architecture par fonctionnalités :

- `lib/core` : éléments partagés (constantes et textes, thème, services Firebase et réseau, providers globaux, utilitaires)
- `lib/features/auth` : connexion par téléphone, OTP, choix du rôle
- `lib/features/producer` : modèle `Product`, publication, liste « Mes produits », synchronisation
- `lib/features/buyer` : liste des récoltes, recherche, détail, bouton « Appeler »
- `lib/features/profile` : profil utilisateur
- `lib/router` : routes et redirections


## Répartition des tâches (5 lots)

**Lot 1 - Fondations** ✅
Chef de projet : configuration Firebase, thème, services, connexion par téléphone + OTP + choix du rôle, modèle `Product`, router avec redirections et écrans provisoires pour les autres lots.

**Lot 2 - Publication producteur**
Membre en charge de la publication : formulaire de récolte (nom, variété, quantité, unité, prix minimum, date, adresse, photo), validation des champs, compression de la photo et file d'attente d'envoi des photos hors-ligne.

**Lot 3 - Mes produits et synchronisation**
Membre en charge de l'espace producteur : liste des produits du producteur, badge « En attente d'envoi » / « Publié », bandeau « Hors-ligne » et écran de détail d'un produit.

**Lot 4 - Parcours acheteur**
Membre en charge de l'espace acheteur : liste de toutes les récoltes, recherche (nom, variété, adresse), écran de détail et bouton « Appeler » qui affiche le numéro puis ouvre le composeur.

**Lot 5 - Profil, textes et UX**
Membre en charge du profil et de l'expérience : écran profil (nom modifiable, déconnexion), centralisation de tous les textes dans `app_texts.dart` et relecture UX de tous les écrans (gros boutons, peu de texte).

**Chef de projet**
Coordination générale, architecture, configuration Firebase, gestion du dépôt Git, intégration des lots dans la branche principale.

## Démarrage

```bash
flutter pub get
flutterfire configure --project=farmhub-229 --platforms=android,ios
flutter run
```

Il faut aussi : être membre du projet Firebase `farmhub-229`, avoir le SDK Android (Android Studio) et ajouter ses empreintes SHA-1 / SHA-256 dans la console Firebase (`cd android` puis `.\gradlew signingReport`).

Numéros de test (sans vrai SMS) : `0165656655` ou `0160601122`, code `123456`.

Rendu : **6 octobre 2026 à 23h59**.
