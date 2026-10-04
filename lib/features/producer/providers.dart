import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/services/firebase_service.dart';
import 'models/product.dart';

// Fichier partagé entre le Lot 2 et le Lot 3 : chacun écrit uniquement dans sa section.

// === Lot 2 : Publication (publishStateProvider) ===

// === Lot 3 : Mes produits (myProductsProvider) ===
final allProductsProvider = StreamProvider<List<Product>>((ref) {
  return FirebaseService.products
      .orderBy('createdAt', descending: true)
      .snapshots(includeMetadataChanges: true)
      .map((snapshot) {
        final products = snapshot.docs.map(Product.fromFirestore).toList();
        products.sort((a, b) {
          final aDate = a.createdAt ?? a.harvestDate;
          final bDate = b.createdAt ?? b.harvestDate;
          return bDate.compareTo(aDate);
        });
        return products;
      });
});

final myProductsProvider = StreamProvider<List<Product>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(const []);

  return FirebaseService.products
      .where('producerId', isEqualTo: user.uid)
      .snapshots(includeMetadataChanges: true)
      .map((snapshot) {
        final products = snapshot.docs.map(Product.fromFirestore).toList();
        products.sort((a, b) {
          final aDate = a.createdAt ?? a.harvestDate;
          final bDate = b.createdAt ?? b.harvestDate;
          return bDate.compareTo(aDate);
        });
        return products;
      });
});

final productProvider = StreamProvider.family<Product?, String>((
  ref,
  productId,
) {
  return FirebaseService.products
      .doc(productId)
      .snapshots(includeMetadataChanges: true)
      .map((doc) => doc.exists ? Product.fromFirestore(doc) : null);
});
