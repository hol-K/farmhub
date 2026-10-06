import '../producer/models/product.dart';

enum ProductSort { recent, priceAsc, priceDesc }

List<Product> filterProductsByQuery(List<Product> products, String query) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) {
    return products;
  }

  return products.where((product) {
    final haystack = [
      product.name,
      product.variety,
      product.address,
      product.producerName,
      product.unit,
    ].join(' ').toLowerCase();

    return haystack.contains(normalized);
  }).toList();
}

/// Unité, prix max et tri de l'écran Rechercher. null = pas de filtre.
List<Product> applyBuyerFilters(
  List<Product> products, {
  String? unit,
  int? maxPrice,
  ProductSort sort = ProductSort.recent,
}) {
  final result = products
      .where((p) => unit == null || p.unit == unit)
      .where((p) => maxPrice == null || p.minPrice <= maxPrice)
      .toList();
  switch (sort) {
    case ProductSort.recent:
      break; // déjà trié par allProductsProvider
    case ProductSort.priceAsc:
      result.sort((a, b) => a.minPrice.compareTo(b.minPrice));
    case ProductSort.priceDesc:
      result.sort((a, b) => b.minPrice.compareTo(a.minPrice));
  }
  return result;
}
