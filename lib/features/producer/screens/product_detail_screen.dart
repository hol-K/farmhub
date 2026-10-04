import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_texts.dart';
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
      appBar: AppBar(title: const Text(AppTexts.productDetailTitle)),
      body: Column(
        children: [
          if (!online) const OfflineBanner(),
          Expanded(
            child: product.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  const Center(child: Text(AppTexts.productLoadError)),
              data: (item) {
                if (item == null || item.producerId != user?.uid) {
                  return const Center(child: Text(AppTexts.productNotFound));
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
                    DetailRow(
                      label: AppTexts.detailQuantity,
                      value: '${item.quantity} ${item.unit}',
                    ),
                    DetailRow(
                      label: AppTexts.minimumPrice,
                      value: item.minPrice.fcfa,
                    ),
                    DetailRow(
                      label: AppTexts.detailHarvest,
                      value: item.harvestDate.dmy,
                    ),
                    DetailRow(
                      label: AppTexts.detailLocation,
                      value: item.address,
                    ),
                    if (item.createdAt != null)
                      DetailRow(
                        label: AppTexts.detailPublishedOn,
                        value: item.createdAt!.dmy,
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
}
