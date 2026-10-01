import 'package:flutter/material.dart';

import '../../../core/constants/app_texts.dart';

// PLACEHOLDER (Lot 1) — à remplacer par le Lot 3.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppTexts.detail)),
      body: Center(
        child: Text(
          AppTexts.producerDetailPlaceholder(productId),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
