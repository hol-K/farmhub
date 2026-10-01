import 'package:flutter/material.dart';

import '../../../core/constants/app_texts.dart';

// PLACEHOLDER (Lot 1) — à remplacer par le Lot 4.
class ProductSearchScreen extends StatelessWidget {
  const ProductSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppTexts.searchTitle)),
      body: const Center(
        child: Text(AppTexts.searchPlaceholder, textAlign: TextAlign.center),
      ),
    );
  }
}
