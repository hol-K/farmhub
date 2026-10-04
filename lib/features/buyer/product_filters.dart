import '../producer/models/product.dart';

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
