import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmhub/features/buyer/data/product_repository.dart';
import 'package:farmhub/features/buyer/models/product.dart';

/// Le repository (un seul exemplaire pour toute l'app).
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

/// Tous les produits disponibles, en temps réel (et depuis le cache hors-ligne).
final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).watchAvailableProducts();
});

/// Le texte tapé dans la barre de recherche.
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) => state = value;
  void clear() => state = '';
}

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

/// Produits filtrés par nom, variété ou localisation.
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final productsAsync = ref.watch(productsStreamProvider);
  return productsAsync.whenData(
    (products) => products.where((p) => p.matches(query)).toList(),
  );
});

/// Un produit précis (pour la fiche détail), cherché dans la liste déjà chargée.
final productByIdProvider = Provider.family<Product?, String>((ref, id) {
  final products = ref.watch(productsStreamProvider).value ?? const [];
  for (final p in products) {
    if (p.id == id) return p;
  }
  return null;
});