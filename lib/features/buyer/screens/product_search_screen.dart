import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_texts.dart';
import '../../producer/providers.dart';
import '../../producer/widgets/product_card.dart';
import '../product_filters.dart';

class ProductSearchScreen extends ConsumerStatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  ConsumerState<ProductSearchScreen> createState() =>
      _ProductSearchScreenState();
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

    return Scaffold(
      appBar: AppBar(title: const Text(AppTexts.searchTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: AppTexts.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(_controller.clear),
                      ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: products.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  const Center(child: Text(AppTexts.productsLoadError)),
              data: (items) {
                final results = filterProductsByQuery(items, _controller.text);
                if (results.isEmpty) {
                  return const Center(child: Text(AppTexts.searchNoResult));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: results.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => ProductCard(
                    product: results[index],
                    showSync: false,
                    onTap: () =>
                        context.push('/buyer/product/${results[index].id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
