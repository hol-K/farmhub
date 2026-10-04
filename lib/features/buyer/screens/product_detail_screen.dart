import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_texts.dart';
import '../../../core/providers/connectivity_provider.dart';
import '../../../core/utils/extensions.dart';
import '../../producer/models/product.dart';
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
      appBar: AppBar(title: const Text(AppTexts.productDetailTitle)),
      body: Column(
        children: [
          if (!online) const OfflineBanner(),
          Expanded(
            child: product.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  const Center(child: Text(AppTexts.productLoadError)),
              data: (item) => item == null
                  ? const Center(child: Text(AppTexts.productNotFound))
                  : _Details(product: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProductImage(product: product, size: 220),
        const SizedBox(height: 20),
        Text(product.name, style: theme.textTheme.headlineSmall),
        if (product.variety.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(product.variety, style: theme.textTheme.titleMedium),
        ],
        const SizedBox(height: 8),
        Text(
          product.minPrice.fcfa,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        DetailRow(
          label: AppTexts.detailQuantity,
          value: '${product.quantity} ${product.unit}',
        ),
        DetailRow(
          label: AppTexts.detailHarvest,
          value: product.harvestDate.dmy,
        ),
        DetailRow(label: AppTexts.detailLocation, value: product.address),
        if (product.createdAt != null)
          DetailRow(
            label: AppTexts.detailPublishedOn,
            value: product.createdAt!.dmy,
          ),
        const SizedBox(height: 16),
        Text(AppTexts.roleProducer, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(product.producerName),
            subtitle: Text(product.producerPhone.phoneFr),
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () =>
              _open(context, Uri(scheme: 'tel', path: product.producerPhone)),
          icon: const Icon(Icons.phone),
          label: const Text(AppTexts.call),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _open(context, _whatsappUri),
          icon: const Icon(Icons.chat_outlined),
          label: const Text(AppTexts.whatsapp),
        ),
      ],
    );
  }

  Uri get _whatsappUri => Uri.parse(
    'https://wa.me/${product.producerPhone.digitsOnly}'
    '?text=${Uri.encodeComponent(AppTexts.whatsappMessage(product.name))}',
  );

  static Future<void> _open(BuildContext context, Uri uri) async {
    final messenger = ScaffoldMessenger.of(context);
    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    ).catchError((Object _) => false);
    if (!opened) {
      messenger.showSnackBar(
        const SnackBar(content: Text(AppTexts.contactError)),
      );
    }
  }
}
