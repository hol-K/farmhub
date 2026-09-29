import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../constants/app_config.dart';

/// Accès central à Firebase. À utiliser après `Firebase.initializeApp()` (fait dans main.dart).
abstract final class FirebaseService {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  static CollectionReference<Map<String, dynamic>> get users =>
      firestore.collection(AppConfig.usersCollection);

  static CollectionReference<Map<String, dynamic>> get products =>
      firestore.collection(AppConfig.productsCollection);

  /// Emplacement de la photo d'un produit : products/{productId}.jpg
  static Reference productPhoto(String productId) =>
      storage.ref('${AppConfig.productPhotosFolder}/$productId.jpg');
}
