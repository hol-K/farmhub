import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/connectivity_provider.dart';
import '../../producer/providers.dart';
import '../../producer/widgets/sync_badge.dart';
import '../widgets/call_button.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productProvider(productId));
    final online = ref.watch(connectivityProvider).value ?? true;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: Column(
        children: [
          if (!online) const OfflineBanner(),
          Expanded(
            child: productAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  const Center(child: Text('Impossible de charger ce produit.')),
              data: (product) {
                if (product == null) {
                  return const Center(child: Text('Produit introuvable.'));
                }
                final price =
                    NumberFormat('#,##0', 'fr_FR').format(product.minPrice);
                final quantity =
                    NumberFormat('#,##0.##', 'fr_FR').format(product.quantity);
                final harvest =
                    DateFormat('dd/MM/yyyy').format(product.harvestDate);

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: (product.photoUrl == null ||
                                product.photoUrl!.isEmpty)
                            ? _placeholder()
                            : Image.network(
                                product.photoUrl!,
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
                      'À partir de $price FCFA / ${product.unit}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _infoRow(Icons.inventory_2_outlined, 'Quantité',
                        '$quantity ${product.unit}'),
                    _infoRow(Icons.location_on_outlined, 'Localisation',
                        product.address),
                    _infoRow(Icons.event_outlined, 'Récolte', harvest),
                    if (product.producerName.isNotEmpty)
                      _infoRow(Icons.person_outline, 'Producteur',
                          product.producerName),
                    const SizedBox(height: 24),
                    CallButton(phone: product.producerPhone),
                  ],
                );
              },
            ),
          ),
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