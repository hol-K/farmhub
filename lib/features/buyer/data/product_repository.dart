import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmhub/features/buyer/models/product.dart';

class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  /// Flux en temps réel de tous les produits disponibles.
  /// Hors-ligne, Firestore renvoie automatiquement les données en cache.
  Stream<List<Product>> watchAvailableProducts() {
    return _products
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map(Product.fromFirestore).toList();
      // Tri côté app (plus récent d'abord), évite de créer un index Firestore.
      list.sort((a, b) {
        final da = a.createdAt;
        final db = b.createdAt;
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });
      return list;
    });
  }

  /// Récupère un produit par son id (utile pour la fiche détail).
  Future<Product?> getProduct(String id) async {
    final doc = await _products.doc(id).get();
    if (!doc.exists) return null;
    return Product.fromFirestore(doc);
  }
}