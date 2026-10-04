import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:farmhub/features/buyer/providers.dart';
import 'package:farmhub/features/buyer/widgets/call_button.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsStreamProvider);
    final product = ref.watch(productByIdProvider(productId));
    final theme = Theme.of(context);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Détail')),
        body: Center(
          child: productsAsync.isLoading
              ? const CircularProgressIndicator()
              : const Text('Produit introuvable.'),
        ),
      );
    }

    final price = NumberFormat('#,##0', 'fr_FR').format(product.price);
    final quantity = NumberFormat('#,##0.##', 'fr_FR').format(product.quantity);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: product.imageUrl.isEmpty
                  ? _placeholder()
                  : Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _placeholder(),
                      loadingBuilder: (context, child, progress) =>
                          progress == null ? child : _placeholder(),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (product.variety.isNotEmpty)
            Text('Variété : ${product.variety}',
                style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Text(
            '$price FCFA / ${product.unit}',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _infoRow(Icons.inventory_2, 'Quantité disponible',
              '$quantity ${product.unit}'),
          _infoRow(Icons.location_on, 'Localisation', product.location),
          if (product.farmerName.isNotEmpty)
            _infoRow(Icons.person, 'Producteur', product.farmerName),
          if (product.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Description', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(product.description),
          ],
          const SizedBox(height: 24),
          CallButton(phone: product.phone),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        color: Colors.green.shade50,
        child: const Center(
          child: Icon(Icons.eco, size: 64, color: Colors.green),
        ),
      );

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text('$label : ',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}