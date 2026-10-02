import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/connectivity_provider.dart';
import '../../../core/utils/extensions.dart';
import '../../producer/providers.dart';
import '../../producer/widgets/product_card.dart';
import '../../producer/widgets/sync_badge.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider(productId));
    final online = ref.watch(connectivityProvider).value ?? true;

    return Scaffold(
      appBar: AppBar(title: const Text('Détail du produit')),
      body: Column(
        children: [
          if (!online) const OfflineBanner(),
          Expanded(
            child: product.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => const Center(child: Text('Impossible de charger ce produit.')),
              data: (item) {
                if (item == null) {
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
                        const SizedBox(width: 8),
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
                    _DetailRow(label: 'Quantité', value: '${item.quantity} ${item.unit}'),
                    _DetailRow(label: 'Prix minimum', value: item.minPrice.fcfa),
                    _DetailRow(label: 'Récolte prévue', value: item.harvestDate.dmy),
                    _DetailRow(label: 'Localisation', value: item.address),
                    if (item.createdAt != null)
                      _DetailRow(label: 'Publié le', value: item.createdAt!.dmy),
                    const SizedBox(height: 16),
                    Text('Producteur', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(item.producerName),
                    Text(item.producerPhone),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => _callProducer(item.producerPhone),
                      icon: const Icon(Icons.phone),
                      label: const Text('Appeler'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callProducer(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
