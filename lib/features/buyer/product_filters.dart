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
/// [currency] = monnaie de l'acheteur : le prix max s'y exprime, donc les
/// produits dans une autre monnaie sont écartés ; au tri par prix, ils passent après.
List<Product> applyBuyerFilters(
  List<Product> products, {
  String? unit,
  int? maxPrice,
  ProductSort sort = ProductSort.recent,
  String currency = 'XOF',
}) {
  final result = products
      .where((p) => unit == null || p.unit == unit)
      .where(
        (p) => maxPrice == null || (p.currency == currency && p.minPrice <= maxPrice),
      )
      .toList();
  if (sort == ProductSort.recent) return result; // déjà trié par allProductsProvider

  int foreign(Product p) => p.currency == currency ? 0 : 1;
  final direction = sort == ProductSort.priceAsc ? 1 : -1;
  result.sort((a, b) {
    final byCurrency = foreign(a).compareTo(foreign(b));
    if (byCurrency != 0) return byCurrency;
    return direction * a.minPrice.compareTo(b.minPrice);
  });
  return result;
}
