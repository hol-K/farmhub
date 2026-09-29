import 'package:flutter/material.dart';

// PLACEHOLDER (Lot 1) — à remplacer par le Lot 4.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: Center(child: Text('À faire — Lot 4\n(produit $productId)', textAlign: TextAlign.center)),
    );
  }
}
