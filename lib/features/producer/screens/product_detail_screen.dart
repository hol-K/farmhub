import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_texts.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/connectivity_provider.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/utils/extensions.dart';
import '../models/product.dart';
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
                        SyncBadge(
                          pending: item.hasPendingWrites,
                          sold: item.sold,
                        ),
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
                      value: item.priceLabel,
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
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () =>
                          context.push('/producer/product/${item.id}/edit'),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text(AppTexts.edit),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      // Pas d'await : fonctionne aussi hors-ligne.
                      onPressed: () => FirebaseService.products
                          .doc(item.id)
                          .update({'sold': !item.sold})
                          .ignore(),
                      icon: Icon(
                        item.sold ? Icons.replay : Icons.check_circle_outline,
                      ),
                      label: Text(
                        item.sold ? AppTexts.markAvailable : AppTexts.markSold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => _delete(context, item),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text(AppTexts.delete),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
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

  Future<void> _delete(BuildContext context, Product item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppTexts.deleteConfirmTitle),
        content: const Text(AppTexts.deleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(AppTexts.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(AppTexts.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    FirebaseService.products.doc(item.id).delete().ignore();
    // Photo absente (pas encore envoyée, ou Storage inactif) : erreur ignorée.
    if (item.photoUrl != null) {
      FirebaseService.productPhoto(item.id).delete().ignore();
    }

    final messenger = ScaffoldMessenger.of(context);
    context.pop();
    messenger.showSnackBar(
      const SnackBar(content: Text(AppTexts.deleteSuccess)),
    );
  }
}
