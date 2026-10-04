import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:farmhub/features/buyer/providers.dart';
import 'package:farmhub/features/buyer/widgets/product_card.dart';

class ProductSearchScreen extends ConsumerStatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  ConsumerState<ProductSearchScreen> createState() =>
      _ProductSearchScreenState();
}

class _ProductSearchScreenState extends ConsumerState<ProductSearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Repartir d'une recherche vide à chaque ouverture.
    Future.microtask(() => ref.read(searchQueryProvider.notifier).clear());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (v) => ref.read(searchQueryProvider.notifier).setQuery(v),
          decoration: const InputDecoration(
            hintText: 'Nom, variété ou localisation',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              ref.read(searchQueryProvider.notifier).clear();
            },
          ),
        ],
      ),
      body: resultsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            const Center(child: Text('Impossible de charger les produits.')),
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('Aucun résultat.'));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => context.push('/buyer/product/${product.id}'),
              );
            },
          );
        },
      ),
    );
  }
}