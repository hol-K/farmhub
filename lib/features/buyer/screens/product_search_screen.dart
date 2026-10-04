import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../product_filters.dart';
import '../../producer/providers.dart';
import '../../producer/widgets/product_card.dart';

class ProductSearchScreen extends ConsumerStatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  ConsumerState<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends ConsumerState<ProductSearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(allProductsProvider);
    final query = _controller.text;

    final filtered = products.when(
      loading: () => const <dynamic>[],
      error: (error, stackTrace) => const <dynamic>[],
      data: (items) => filterProductsByQuery(items, query),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Rechercher')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Nom, variété, lieu ou producteur',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Aucun résultat pour cette recherche.'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => ProductCard(
                      product: filtered[index],
                      onTap: () => context.push('/buyer/product/${filtered[index].id}'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
