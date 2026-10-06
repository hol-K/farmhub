import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_config.dart';
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
  final _maxPrice = TextEditingController();
  String? _unit;
  var _sort = ProductSort.recent;

  @override
  void dispose() {
    _controller.dispose();
    _maxPrice.dispose();
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _maxPrice,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: AppTexts.maxPrice,
                      suffixText: AppTexts.fcfa,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<ProductSort>(
                  value: _sort,
                  onChanged: (v) => setState(() => _sort = v ?? _sort),
                  items: const [
                    DropdownMenuItem(
                      value: ProductSort.recent,
                      child: Text(AppTexts.sortRecent),
                    ),
                    DropdownMenuItem(
                      value: ProductSort.priceAsc,
                      child: Text(AppTexts.sortPriceAsc),
                    ),
                    DropdownMenuItem(
                      value: ProductSort.priceDesc,
                      child: Text(AppTexts.sortPriceDesc),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Wrap(
              spacing: 8,
              children: [
                for (final unit in [null, ...AppConfig.units])
                  ChoiceChip(
                    label: Text(unit ?? AppTexts.allUnits),
                    selected: _unit == unit,
                    onSelected: (_) => setState(() => _unit = unit),
                  ),
              ],
            ),
          ),
          Expanded(
            child: products.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  const Center(child: Text(AppTexts.productsLoadError)),
              data: (items) {
                final results = applyBuyerFilters(
                  filterProductsByQuery(items, _controller.text),
                  unit: _unit,
                  maxPrice: int.tryParse(_maxPrice.text),
                  sort: _sort,
                );
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
