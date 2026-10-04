import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/connectivity_provider.dart';
import '../../../core/utils/extensions.dart';
import '../providers.dart';
import '../widgets/product_card.dart';
import '../widgets/sync_badge.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider(productId));
    final user = ref.watch(authStateProvider).value;
    final online = ref.watch(connectivityProvider).value ?? true;

    return Scaffold(
      appBar: AppBar(title: const Text('Détail du produit')),
      body: Column(
        children: [
          if (!online) const OfflineBanner(),
          Expanded(
            child: product.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const Center(
                child: Text('Impossible de charger ce produit.'),
              ),
              data: (item) {
                if (item == null || item.producerId != user?.uid) {
                  return const Center(child: Text('Produit introuvable.'));
                }
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ProductImage(product: item, size: 220),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SyncBadge(pending: item.hasPendingWrites),
                      ],
                    ),
                    if (item.variety.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.variety,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                    const SizedBox(height: 20),
                    _DetailRow(
                      label: 'Quantité',
                      value: '${item.quantity} ${item.unit}',
                    ),
                    _DetailRow(
                      label: 'Prix minimum',
                      value: item.minPrice.fcfa,
                    ),
                    _DetailRow(
                      label: 'Récolte prévue',
                      value: item.harvestDate.dmy,
                    ),
                    _DetailRow(label: 'Localisation', value: item.address),
                    if (item.createdAt != null)
                      _DetailRow(
                        label: 'Publié le',
                        value: item.createdAt!.dmy,
                      ),
                    const SizedBox(height: 16),
                    Text(
                      'Contact producteur',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(item.producerName),
                    Text(item.producerPhone),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
